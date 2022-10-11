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
import 'package:UIKit/Result.dart';
import 'package:UIKit/sqlite.dart';
import 'package:UIKit/Notice.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:UIKit/Quotes.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';
class LMSResults extends StatefulWidget {
  Student? _selectedstu;
  String? _subject;
  LMSResults(Student? stu,String? Subj)
  {
    this._selectedstu = stu;
    this._subject = Subj;
  }
  @override
  _LMSDashboardScreenState createState() => _LMSDashboardScreenState();
}

class _LMSDashboardScreenState extends State<LMSResults> {
  final db = SqliteDB();
  String? _subject;
  bool _isLoading = false;
  List<Notice> _Notice=[];
  int? newcount = 0;
  FToast fToast = FToast();
  List<Quotes> quote = [];

  late ThemeData themeData;
  initdata()async {
    setState(() {
      _isLoading = true; // your loader has started to load
    });
    List<Notice> _notice = await db.getNoticeByStudent(widget._selectedstu!.StudentID);

      this._Notice = _notice;
      newcount = _notice.where((i)=> i.Seen == "NEW !!" ).toList().length;
      this.quote = await db.getAllQuotes();
    setState(() {
      _isLoading = false; // your loder will stop to finish after the data fetch
    });
    //print("new "+newcount.toString());
  }
  void initState() {
    fToast.init(context);
    initdata();
  }
  _showToast() {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
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
                                      widget._selectedstu!.Name + ": " +widget._selectedstu!.GradeName+"-"+widget._selectedstu!.Section ,
                                      style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                                          fontWeight: 790,fontSize:18),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  child: _isLoading
                                      ? Center(child: CircularProgressIndicator(),): InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(new MaterialPageRoute<Null>(
                                          builder: (BuildContext context) {
                                            return LMSNotificationScreen(widget._selectedstu,true);
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
                          padding: EdgeInsets.only(
                              top: MySize.size16!,
                              left: MySize.size16!,
                              right: MySize.size16!),
                          child: Text(
                            "All Results for Subject: " + widget._subject!,
                            style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                                fontWeight: 600,fontSize:16,color:Colors.blue),
                          ),
                        ),
                        Container(
                          child: _SubmissionWidget(db,widget._selectedstu!, widget._subject!),
                        )
                      ],
                    ))));
      },
    );
  }
}

class _SubmissionWidget extends StatefulWidget {
  SqliteDB? db ;
  Student? selected;
  String? Subject;
  _SubmissionWidget(SqliteDB dbc,_selectedstu, _subject) {
    this.db = dbc;
    this.selected = _selectedstu;
    this.Subject = _subject;
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
    List<Results?> _result = await widget.db!.getResultByStudentandSubject(widget.selected!.StudentID,widget.Subject!);
    this.setState(() {
      this._results = _result;
    });
    setState(() {
      if(_result.length > 0)
      {_isLoading = false;} // your loder will stop to finish after the data fetch
    });
    //print("results "+this._results.toString());
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
          state: StepState.indexed,
          title: Text(
            e!.SubjectName,
            style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                fontWeight: 790,fontSize:18),
          ),
          subtitle: Text(e.Name,
              style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                  fontWeight: 600,fontSize:16,color:Colors.blue)),
          content: Container(
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
          ),
        );
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
