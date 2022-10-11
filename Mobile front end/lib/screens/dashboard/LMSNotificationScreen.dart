import 'dart:math';
import 'package:UIKit/AppTheme.dart';
import 'package:UIKit/AppThemeNotifier.dart';
import 'package:UIKit/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:UIKit/Student.dart';
import 'package:UIKit/Notice.dart';
import 'package:UIKit/sqlite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:UIKit/Quotes.dart';
class LMSNotificationScreen extends StatefulWidget {
  Student? _selectedstu;
  bool caller = false;
  LMSNotificationScreen(Student? stu,bool callerr)
  {
    this._selectedstu = stu;
    this.caller = callerr;
  }
  @override
  _LMSNotificationScreenState createState() =>
      _LMSNotificationScreenState();
}

class _LMSNotificationScreenState extends State<LMSNotificationScreen> {
  List<Notice> _Notice=[];
  final db = SqliteDB();
  bool _isLoading = false;
  FToast fToast = FToast();
  List<Quotes> quote = [];
  late ThemeData themeData;
  late CustomAppTheme customAppTheme;
  initdata()async {
    setState(() {
      _isLoading = true; // your loader has started to load
    });
    List<Notice> _notice = await db.getNoticeByStudent(widget._selectedstu!.StudentID);
    this._Notice = _notice;
    this.quote = await db.getAllQuotes();
   // print(this._Notice.toString());
     db.UpdateSeen(widget._selectedstu!.StudentID);
    setState(() {
      _isLoading = false; // your loder will stop to finish after the data fetch
    });
  }
  void initState()  {
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
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
        int themeType = value.themeMode();
        themeData = AppTheme.getThemeFromThemeMode(themeType);
        customAppTheme = AppTheme.getCustomAppTheme(themeType);
        return SafeArea(
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.getThemeFromThemeMode(themeType),
              home: Scaffold(
                  body: Container(
                      color: customAppTheme.bgLayer1,
                      child: ListView(
                        padding: Spacing.bottom(16),
                        children: <Widget>[
                          Container(
                            margin: Spacing.fromLTRB(24, 16, 24, 0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  child: !widget.caller
                                      ? Center(child: Text(""),):InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      MdiIcons.chevronLeft,
                                      color: themeData.colorScheme.onBackground,
                                      size: MySize.size24,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Center(
                                    child: Container(
                                      child:GestureDetector(
                                        onTap:(){
                                          _showToast();
                                        },
                                        child:Text(
                                          widget._selectedstu!.Name + " " +widget._selectedstu!.GradeName+"-"+widget._selectedstu!.Section,
                                          style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                                              fontWeight: 790,fontSize:18),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: _isLoading
                                ? Center(child: CircularProgressIndicator(),):Column(
                              children: this._Notice.map((e) {
                                return Container(
                                  margin: Spacing.fromLTRB(24, 24, 24, 0),
                                  child: singleAnnouncement(
                                      title: e.Title,
                                      desc: e.Value,
                                      date: e.AssignedTo,
                                      time: e.Seen,
                                      venue: e.Type),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                      )))),
        );
      },
    );
  }

  Widget singleAnnouncement(
      {required String title, required String date, required String time, required String venue, required String desc}) {
    return Container(
      padding: Spacing.vertical(24),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(MySize.size8!)),
          color: customAppTheme.bgLayer1,
        border: Border.all(color: customAppTheme.bgLayer4,width: 1),
          boxShadow: [
            BoxShadow(
                color: customAppTheme.shadowColor,
                blurRadius: MySize.size4!,
                offset: Offset(0, 1))
          ]
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: Spacing.horizontal(24),
            child: Text(
              title,
              style: AppTheme.getTextStyle(themeData.textTheme.subtitle1,
                  color: themeData.colorScheme.onBackground, fontWeight: 600),
            ),
          ),
          Container(
            padding: Spacing.horizontal(24),
            margin: Spacing.top(4),
            child: Text(
              desc,
              style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,
                  color: themeData.colorScheme.onBackground,
                  letterSpacing: 0.3,
                  fontWeight: 500,
                  height: 1.7),
            ),
          ),
          Container(
              margin: Spacing.top(16),
              child: Divider(
                height: 0,
              )),
          Container(
            padding: Spacing.only(left: 24, right: 24, top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  date,
                  style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,
                      color: themeData.colorScheme.primary),
                ),
                Text(
                  time,
                  style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,
                      color: themeData.colorScheme.primary),
                ),
              ],
            ),
          ),
          Container(
            margin: Spacing.top(4),
            padding: Spacing.horizontal(24),
            child: Text(
              venue,
              style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,
                  color: themeData.colorScheme.onBackground.withAlpha(160),
                  fontWeight: 500),
            ),
          )
        ],
      ),
    );
  }


}
