import 'dart:math';
import 'package:UIKit/screens/dashboard/LMSDashboardScreen.dart';
import 'package:UIKit/screens/dashboard/MaintenanceScreen.dart';
import 'package:UIKit/screens/wallet/WalletHomeScreen.dart';
import 'package:UIKit/screens/dashboard/LMSNotificationScreen.dart';
import 'package:UIKit/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'AppTheme.dart';
import 'AppThemeNotifier.dart';
import 'SingleGridItem.dart';
import 'package:UIKit/Student.dart';
import 'package:UIKit/Notice.dart';
import "dart:io" as io;
import 'package:UIKit/sqlite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:UIKit/Quotes.dart';
import 'package:UIKit/screens/dashboard/LMScommbookselect.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class ScreensHome extends StatefulWidget {
   Student?  _selectedstu ;
  ScreensHome(Student? stu)
  {
    this._selectedstu = stu;
  }

  @override
  _ScreensHomeState createState() => _ScreensHomeState( );

}

class _ScreensHomeState extends State<ScreensHome>  {
  io.File? file;
  List<Notice> _Notice=[];
  List<Quotes> quote = [];
  int? newcount = 0;
  List<Notice> newnotice =[];
  double c_width = 0;
  bool needsComm = false;
  List<String> _commbookGradelist = ["Grade  1","Grade  2","Grade  3","Grade  4","KG","Nursery","Preparatory"];
  bool imexists = false;
  bool _isLoading = false;
  final db = SqliteDB();
   FToast fToast = FToast();

  @override
  void initState()  {
    super.initState();
    fToast.init(context);
    initdata().whenComplete((){
      if(newcount! > 0 && !_isLoading)
      {WidgetsBinding.instance!.addPostFrameCallback((_) => _showStartDialog());}
      setState(() {});
    });
  }
  //int _currentIndex = 1;
  CustomAppTheme? customAppTheme;

  initdata()async {
    setState(() {
      _isLoading = true; // your loader has started to load
    });
    initimg();
    //print(imexists.toString());
      List<Notice> _notice = await db.getNoticeByStudent(widget._selectedstu!.StudentID);
      this._Notice = _notice;

      this.quote = await db.getAllQuotes();
    WidgetsBinding.instance!.addPostFrameCallback((_) => _showToast());
    setState(() {
       newnotice = _notice.where((i)=> i.Seen == "NEW !!" ).toList();
       newcount = _notice.where((i)=> i.Seen == "NEW !!" ).toList().length;
      _isLoading = false; // your loder will stop to finish after the data fetch
    });
   // print("new "+newcount.toString());
  }
  initimg()async
  {
    this.file = new io.File(widget._selectedstu!.img);
    if(await this.file!.exists())
    {
      setState(() {
        imexists = true; // your loader has started to load
      });
    }
    else
      {
        setState(() {
          imexists = false; // your loader has started to load
        });
      }
    if(_commbookGradelist.where((i)=>i == widget._selectedstu!.GradeName).length > 0)
    {
      needsComm = true;
    }
    else
      {
        needsComm = false;
      }
  }
  Future<void> _showStartDialog() async {
    // flutter defined function
   return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("New Notifications",
              style: TextStyle(
             // color: Colors.redAccent,
              fontWeight: FontWeight.bold,
                  color:Colors.blue
          )),
          content: SingleChildScrollView( child: Column(
            children: this.newnotice.map((e) {
              return Container(
                margin: Spacing.fromLTRB(4, 4, 4, 0),
                child: singleAnnouncement(
                    title: e.Title,
                    desc: e.Value,
                    date: e.AssignedTo,
                    time: e.Seen,
                    venue: e.Type),
              );
            }).toList(),
          ),),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new TextButton(
        child: Text('Seen',style: TextStyle(
        // color: Colors.redAccent,
        fontWeight: FontWeight.bold,
        fontSize: 16
        )),
        onPressed: () {
          db.UpdateSeen(widget._selectedstu!.StudentID);
        Navigator.of(context).pop();
        },
        ),
          ],
        );
      },
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
    ThemeData themeData = Theme.of(context);
    if(!_isLoading) {
      initimg();
      //this.file = new io.File(widget._selectedstu!.img);
    }

    //builder:_showToast();
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
        customAppTheme = AppTheme.getCustomAppTheme(value.themeMode());
        return Container(
            padding: EdgeInsets.only(
                left: 8, right: 8, bottom: 12),
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: <Widget>[
                Container(
                  margin: Spacing.fromLTRB(16, 16, 16, 0),
                  child: Row(
                    children: <Widget>[

                      Expanded(
                        child: Container(
                                    child: GestureDetector(
                                    onTap:(){
                                      _showToast();
                                    },
                                    child:Text(
                                          "Hello",
                                          style: AppTheme.getTextStyle(
                                          themeData.textTheme.bodyText1,
                                          color: themeData
                                              .colorScheme.onBackground,
                                          fontWeight: 600),
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
                                        fontSize: 12,
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
                _isLoading
                    ? Center(child: CircularProgressIndicator(),):Container(
                  padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
                  child: Card (
                    shadowColor: Colors.blue,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(top: 8, left: 8, bottom: 4),
                          child:Center(
                        child: CircleAvatar(
                          backgroundImage: imexists ? FileImage(this.file!) : AssetImage(widget._selectedstu!.img) as ImageProvider,
                          radius: 80.0,
                        ),
                      )),
                      Divider(),
                      Container(
                        padding: EdgeInsets.only(top: 8, left: 8, bottom: 8),
                        child: Text(
                              'STUDENT INFO.',
                              style: TextStyle(
                              color: Colors.grey,
                              letterSpacing: 2.0,
                              ),
                      )),
                      Container(
                        padding: EdgeInsets.only(top: 8, left: 8, bottom: 12),
                       child:Column(
                         children:<Widget> [
                           Row(
                             children: [
                               Text(
                                 widget._selectedstu!.Name,
                                   style: TextStyle(
                                       color: Colors.blue,
                                       letterSpacing: 2.0,
                                       fontWeight: FontWeight.bold
                                   ),
                               ),
                             ],
                           ),
                           SizedBox(height: 10.0),
                           Row(
                             children: [
                               Text(
                                 widget._selectedstu!.GradeName+"-"+widget._selectedstu!.Section,
                                 style: TextStyle(
                                     color: Colors.blue,
                                     letterSpacing: 2.0,
                                     fontWeight: FontWeight.bold
                                 ),
                               ),
                             ],
                           ),
                           SizedBox(height: 10.0),
                           Row(
                             children: <Widget>[
                               Text(
                                 '',
                                 style: TextStyle(
                                     color: Colors.blue,
                                     letterSpacing: 2.0,
                                     fontSize: 14.0,
                                     fontWeight: FontWeight.bold
                                 ),
                               )
                             ],
                           )
                         ],
                       ) ,
                      ),


                    ],
                  ),
                )),
                Container(
                  padding: EdgeInsets.only(top: 16, left: 8, bottom: 12),
                  child: Text(
                    "CONTENT",
                    style: TextStyle(
                      color: Colors.grey,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                GridView.count(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    crossAxisCount: 2,
                    padding: EdgeInsets.all(4),
                    mainAxisSpacing: 16,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 16,

                    children: <Widget>[
                      SinglePageItem(
                        title: "Exam Results",
                        icon: './assets/icons/school-outline.png',
                        navigation: LMSDashboardScreen(widget._selectedstu!),
                      ),
                      needsComm
                          ? SinglePageItem(
                        title: "Communication Book",
                        icon: './assets/icons/email-outline.png',
                        navigation: LMSDcommbookselect(widget._selectedstu!),
                      ):Container(),
                      SinglePageItem(
                        title: "Fees",
                        icon: './assets/icons/file-tray-full-outline.png',
                        navigation:WalletHomeScreen(widget._selectedstu!),
                      ),
                      SinglePageItem(
                      title: "Teaching Aid",
                      icon: './assets/icons/course-outline.png',
                      navigation: MaintenanceScreen(),
                      ),
                    ]),

              ],
            ));
      },
    );
  }
  Widget singleAnnouncement(
      {required String title, required String date, required String time, required String venue, required String desc}) {
    ThemeData themeData = Theme.of(context);
    int idx = date.indexOf(" ");
    String dt = [date.substring(0,idx).trim(), date.substring(idx+1).trim()][0];
    return Container(
      padding: Spacing.vertical(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(MySize.size8!)),
          color: customAppTheme!.bgLayer1,
          border: Border.all(color: customAppTheme!.bgLayer4,width: 1),
          boxShadow: [
            BoxShadow(
                color: customAppTheme!.shadowColor,
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
              style: AppTheme.getTextStyle(themeData.textTheme.subtitle2,
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
            padding: Spacing.only(left: 12, right: 12, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  dt,
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
            padding: Spacing.only(left: 12, right: 12, top: 4),
            child: Text(
              venue,
              style: AppTheme.getTextStyle(themeData.textTheme.bodyText2,
                  color: Colors.redAccent,
                  fontWeight: 500,
                  fontSize:14),
            ),
          )
        ],
      ),
    );
  }
}
