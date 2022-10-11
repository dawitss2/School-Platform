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
import 'package:UIKit/Notice.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:UIKit/Quotes.dart';
import 'package:UIKit/distnictdata.dart';
import 'package:UIKit/screens/dashboard/LMSCommunicationbook.dart';
import 'package:UIKit/Subject.dart';
class LMSDcommbookselect extends StatefulWidget {
  Student? _selectedstu;

  LMSDcommbookselect(Student? stu)
  {
    this._selectedstu = stu;
  }
  @override
  _LMSDashboardScreenState createState() => _LMSDashboardScreenState(this._selectedstu);
}

class _LMSDashboardScreenState extends State<LMSDcommbookselect> {
  Student? _selectedstu;
  final db = SqliteDB();
  List<Notice> _Notice=[];
  int? newcount = 0;
  bool _isLoading = false;
  FToast fToast = FToast();
  List<Quotes> quote = [];
  List<Subject> commType = [];
  _LMSDashboardScreenState(Student? stu)
  {
    this._selectedstu = stu;
  }

  late ThemeData themeData;
  initdata()async {
    setState(() {
      _isLoading = true; // your loader has started to load
    });
    List<Notice> _notice = await db.getNoticeByStudent(this._selectedstu!.StudentID);
    List<Subject> _subj= await db.getSubjects(this._selectedstu!.StudentID);
    List<distnictdata> _weekly = await db.getDistnictWeeklyCommByStudent(this._selectedstu!.StudentID);
    List<distnictdata> _monthly = await db.getDistnictMonthlyCommByStudent(this._selectedstu!.StudentID);
    commType.add(new Subject(SubjectName: "Weekly", Completed: _weekly.length.toDouble()));
    commType.add(new Subject(SubjectName: "Monthly", Completed: _monthly.length.toDouble()));
    this._Notice = _notice;
    this.quote = await db.getAllQuotes();
    newcount = _notice.where((i)=> i.Seen == "NEW !!" ).toList().length;
    setState(() {
      _isLoading = false; // your loder will stop to finish after the data fetch
    });
    // print("subject"+this._subjects.toString()+"new "+newcount.toString());
  }
  @override
  void initState() {
    super.initState();
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
                  title: Text("Select Communication Book",
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
                                      this._selectedstu!.Name + ": " +_selectedstu!.GradeName+"-"+_selectedstu!.Section,
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
                                            return LMSNotificationScreen(this._selectedstu,true);
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
                              "Communication Book Types",
                              style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                                  fontWeight: 600,fontSize:16,color:Colors.blue),
                            )),
                        Container(
                          child: _isLoading
                              ? Center(child: CircularProgressIndicator(),): GridView.count(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            crossAxisCount: 2,
                            padding: EdgeInsets.only(
                                left: MySize.size16!,
                                right: MySize.size16!,
                                top: MySize.size16!),
                            mainAxisSpacing: MySize.size16!,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: MySize.size16!,
                            children:  this.commType.map((s){
                              return new GestureDetector(
                                  onTap:(){
                                    if(s.SubjectName=="Monthly")
                                    {Navigator.push(context, MaterialPageRoute(builder: (context) => LMSCommunicationBook(this._selectedstu,true)));}
                                    else
                                    {Navigator.push(context, MaterialPageRoute(builder: (context) => LMSCommunicationBook(this._selectedstu,false)));}
                                  },
                                  child:_SingleSubject(
                                    completed: s.Completed.toInt(),
                                    subject: s.SubjectName,
                                    backgroundColor: Colors.primaries[Random().nextInt(10)],
                                  )
                              );
                            }).toList(),
                          ),
                        ),
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
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MySize.size8!),
      ),
      child: Container(
        color: backgroundColor,
        height: 125,
        child: Container(
          padding: EdgeInsets.only(bottom: MySize.size16!, left: MySize.size16!),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(subject,
                  style: AppTheme.getTextStyle(themeData.textTheme.subtitle1,
                      fontWeight: 600, color: Colors.white)),
              Text(completed.floor().toString() + " Reports",
                  style: AppTheme.getTextStyle(themeData.textTheme.caption,
                      fontWeight: 500, color: Colors.white, letterSpacing: 0)),
            ],
          ),
        ),
      ),
    );
  }
}

