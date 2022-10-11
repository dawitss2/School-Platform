/*
* File : LMS Dashboard
* Version : 1.0.0
* */

import 'dart:math';

import 'package:UIKit/AppTheme.dart';
import 'package:UIKit/AppThemeNotifier.dart';
import 'package:UIKit/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:UIKit/screens/dashboard/LMSNotificationScreen.dart';
import 'package:UIKit/Student.dart';
import 'package:UIKit/Subject.dart';
import 'package:UIKit/Result.dart';
import 'package:UIKit/sqlite.dart';
import 'package:UIKit/screens/dashboard/LMSResults.dart';
import 'package:UIKit/Notice.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:UIKit/Quotes.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';
class LMSDashboardScreen extends StatefulWidget {
  Student? _selectedstu;

  LMSDashboardScreen(Student? stu)
  {
    this._selectedstu = stu;
  }
  @override
  _LMSDashboardScreenState createState() => _LMSDashboardScreenState();
}

class _LMSDashboardScreenState extends State<LMSDashboardScreen> {
  final db = SqliteDB();
  List<Subject> _subjects=[];
  List<Notice> _Notice=[];
  int? newcount = 0;
  bool _isLoading = false;
  FToast fToast = FToast();
  List<Quotes> quote = [];

  late ThemeData themeData;
  initdata()async {
    setState(() {
      _isLoading = true; // your loader has started to load
    });
    List<Notice> _notice = await db.getNoticeByStudent(widget._selectedstu!.StudentID);
    List<Subject> _subj= await db.getSubjects(widget._selectedstu!.StudentID);
      this._subjects = _subj;
      this._Notice = _notice;
      this.quote = await db.getAllQuotes();
      newcount = _notice.where((i)=> i.Seen == "NEW !!" ).toList().length;
    setState(() {
      _isLoading = false; // your loder will stop to finish after the data fetch
    });
    print("subject"+this._subjects.toString()+"new "+newcount.toString());
  }
  @override
  void initState() {
    super.initState();
    fToast.init(context);
    initdata();
  }
  _NoData() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.primaries[Random().nextInt(10)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12.0,
          ),
          Expanded(child:Text('No Test Result to display, yet ! ( Coming Soon )',
              style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold
              )
          )),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 10),
    );
  }
  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.primaries[Random().nextInt(10)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12.0,
          ),
          Expanded(child:Text(quote[Random().nextInt(quote.length)].Author+" - "+quote[Random().nextInt(quote.length)].Quote,
              style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold
              )
          )),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 6),
    );
  }
  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    if(!_isLoading && this._subjects.length==0)
    {WidgetsBinding.instance!.addPostFrameCallback((_) => _NoData());}
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
            home: Scaffold(
                appBar: AppBar(
                  backgroundColor: themeData.scaffoldBackgroundColor,
                  elevation: 0,
                  centerTitle: true,
                  leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      MdiIcons.chevronLeft,
                    ),
                  ),
                  title: Text("Exam Results",
                      style: AppTheme.getTextStyle(
                          themeData.textTheme.headline6,
                          fontWeight: 600)),
                ),
                body: Container(
                    color: themeData.backgroundColor,
                    child: ListView(
                      children: <Widget>[
                        Container(
                          margin: Spacing.fromLTRB(16, 16, 16, 0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child:GestureDetector(
                                    onTap:(){
                                      _showToast();
                                    },
                                    child:Text(
                                      widget._selectedstu!.Name + ": " +widget._selectedstu!.GradeName+"-"+widget._selectedstu!.Section,
                                      style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                                          fontWeight: 790,fontSize:18),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  child:_isLoading
                                      ? Center(child: CircularProgressIndicator(),): InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new MaterialPageRoute<Null>(
                                          builder: (BuildContext context) {
                                            return LMSNotificationScreen(widget._selectedstu!,true);
                                          },
                                          fullscreenDialog: true));
                                    },
                                    child: Stack(
                                      clipBehavior: Clip.none, children: <Widget>[
                                      Icon(
                                        MdiIcons.bellOutline,
                                        color: themeData
                                            .colorScheme.onBackground
                                            .withAlpha(200),
                                      ),
                                      Positioned(
                                        right: -2,
                                        top: -2,
                                        child: Container(
                                          padding: EdgeInsets.all(0),
                                          height: MySize.size20,
                                          width: MySize.size20,
                                          decoration: BoxDecoration(
                                              color:Colors.redAccent,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      MySize.size50!))),
                                          child: Center(
                                            child: Text(
                                              newcount.toString(),
                                              style: AppTheme.getTextStyle(
                                                themeData.textTheme.overline,
                                                color: themeData
                                                    .colorScheme.onPrimary,
                                                fontSize: 9,
                                                fontWeight: 500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                    ),
                                  ))
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                top: MySize.size16!,
                                left: MySize.size16!,
                                right: MySize.size16!),
                            child: Text(
                              "SUBJECTS",
                              style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                                  fontWeight: 600,fontSize:16,color:Colors.blue),
                            )),
                        Container(
                          child: _isLoading || this._subjects.length==0
                              ? Center(child: CircularProgressIndicator(),): SafeArea(
                            child: SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: GridView(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),

                              scrollDirection:Axis.horizontal,

                              padding: EdgeInsets.only(
                                  left: MySize.size16!,
                                  right: MySize.size16!,
                                  top: MySize.size16!),

                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 3 / 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20
                            ),
                              children:   this._subjects.map((s){
                                return new GestureDetector(
                                    onTap:(){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => LMSResults(widget._selectedstu!,s.SubjectName)));
                                    },
                                    child:_SingleSubject(
                                      completed: s.Completed.toInt(),
                                      subject: s.SubjectName,
                                      backgroundColor: Colors.primaries[Random().nextInt(10)],
                                    )
                                );
                              }).toList(),
                          ),
                        ),),),
                        Container(
                          padding: EdgeInsets.only(
                              top: MySize.size16!,
                              left: MySize.size16!,
                              right: MySize.size16!),
                          child: Text(
                            "RESENT",
                            style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                                fontWeight: 600,fontSize:16,color:Colors.blue),
                          ),
                        ),
                        Container(
                          child: _SubmissionWidget(db,widget._selectedstu!),
                        )
                      ],
                    ))));
      },
    );
  }
}

class _SingleSubject extends StatelessWidget {
  final Color backgroundColor;
  final String subject;
  final int completed;

  const _SingleSubject(
      {Key? key,
      required this.backgroundColor,
      required this.subject,
      required this.completed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return  Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MySize.size8!),
      ),
      child:  Container(
        color: backgroundColor,
        height: 125,
        child: Container(
          padding: EdgeInsets.only(bottom: MySize.size16!, left: MySize.size16!,right: MySize.size16!),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(subject,
                  style: AppTheme.getTextStyle(themeData.textTheme.subtitle1,
                      fontWeight: 600, color: Colors.white)),
              Text(completed.floor().toString() + "% Completed",
                  style: AppTheme.getTextStyle(themeData.textTheme.caption,
                      fontWeight: 500, color: Colors.white, letterSpacing: 0)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SubmissionWidget extends StatefulWidget {
  SqliteDB? db ;
  Student? selected;
  _SubmissionWidget(SqliteDB dbc,_selectedstu) {
    this.db = dbc;
    this.selected = _selectedstu;
  }
  @override
  _SubmissionWidgetState createState() => _SubmissionWidgetState();
}

class _SubmissionWidgetState extends State<_SubmissionWidget> {
  List<Results?> _results=[];
  bool _isLoading = false;
  int currentStep = 0;
  late ThemeData themeData;
  initdata() async{
    setState(() {
      _isLoading = true; // your loader has started to load
    });
    List<Results?> _result = await widget.db!.getResultByStudentRecent(widget.selected!.StudentID);
    this.setState(() {
      this._results = _result;
    });
    setState(() {
      if(_result.length > 0)
      {_isLoading = false;} // your loder will stop to finish after the data fetch
    });
    //print("results "+this._results.toString()+widget.selected.toString());
  }

  void initState()  {
    super.initState();
    initdata();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return  Scrollbar(
        child: _isLoading
        ? Center(child: CircularProgressIndicator(),):Stepper(
      physics: ClampingScrollPhysics(),
      controlsBuilder: (BuildContext context,
          {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
        return _buildControlBuilder(currentStep);
      },
      currentStep: currentStep,
      onStepTapped: (pos) {
        setState(() {
          if(currentStep == pos)
          { if(pos == this._results.length - 1)
          {
            currentStep = 0;
          }
          else
          {currentStep = pos + 1;}
          }
          else
          {currentStep = pos;}
        });
      },
      steps: this._results.map((e) {
        return new Step(
          isActive: true,
          state: StepState.complete,
          title: Text(
            e!.SubjectName,
            style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                fontWeight: 790,fontSize:18),
          ),
          subtitle: Text(e.Name,
              style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                  fontWeight: 600,fontSize:16,color:Colors.blue)),
          content:Container(
            padding:EdgeInsets.only(
                top: MySize.size16!),
            child: Center(

            child: WidgetCircularAnimator(
              size: 90,
              innerColor: Colors.lightBlue,
              outerColor: Colors.redAccent,
                    child: Container(
                      padding: EdgeInsets.only(
                          left: MySize.size6!,
                          right: MySize.size4!,
                          bottom: MySize.size20!,
                          top: MySize.size20!),
              child: Text(
                e.Result + "/" + e.Value ,
                style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                    fontWeight: 700,fontSize:18,color:Colors.green),
              ),
                ),
        )),
          ));
      }).toList(),
    ));
  }



  Widget _buildControlBuilder(int position) {
    if (position == 0 || position == 1) {
      return Container(
        margin: EdgeInsets.only(top: MySize.size8!),
        child: Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(MySize.size8!)),
              boxShadow: [
                BoxShadow(
                  color: themeData.colorScheme.primary.withAlpha(18),
                  blurRadius: 2,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(MySize.size8!)),
            boxShadow: [
              BoxShadow(
                color: themeData.colorScheme.secondary.withAlpha(18),
                blurRadius: 3,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
        ),
      ),
    );
  }
}
