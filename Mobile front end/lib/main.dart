/*
* File : Main File
* Version : 1.0.0
* */
import 'dart:ffi';
import "dart:io" as io;
import 'package:UIKit/Address.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:UIKit/AppTheme.dart';
import 'package:UIKit/AppThemeNotifier.dart';
import 'package:UIKit/screens/auth/OTPVerificationScreen.dart';
import 'package:UIKit/ScreensHome.dart';
import 'package:UIKit/sqlite.dart';
import 'package:UIKit/screens/SelectThemeDialog.dart';
import 'package:UIKit/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/themes/app_theme.dart';
import 'package:flutx/themes/app_theme_notifier.dart';
import 'package:flutx/utils/spacing.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import "package:path/path.dart";
import 'package:UIKit/Student.dart';
import 'package:UIKit/screens/dashboard/LMSNotificationScreen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:restart_app/restart_app.dart';

Future<void> main() async {
  //You will need to initialize AppThemeNotifier class for theme changes.
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(ChangeNotifierProvider<AppThemeNotifier>(
      create: (context) => AppThemeNotifier(),
      child: ChangeNotifierProvider<FxAppThemeNotifier>(
        create: (context) => FxAppThemeNotifier(),
        child: MyApp(),
      ),
    ));
  });
}

class MyApp extends StatelessWidget  {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: FxAppTheme.getThemeFromThemeMode(),
            home: MyHomePage());
      },
    );
  }
}


class MyHomePage extends StatefulWidget  {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin  {
  int _selectedPage = 0;
  late ThemeData themeData;
  late CustomAppTheme customAppTheme;
  int _currentIndex = 0;
  final Connectivity _connectivity = Connectivity();
  late var  db = new SqliteDB();
  bool _isLoading = false;
  List<Student> students =[];
  Student? _selectedstu;
  TabController? _tabController;
  late List<Widget> _fragmentView;
  bool dbexists = true;

  _handleTabSelection() {
    setState(() {
      _currentIndex = _tabController!.index;
    });
  }

  @override
  void initState()  {
    super.initState();
    inistudent().whenComplete((){
      refreshData();
      setState(() {});
    });
    initab();
  }
  void initab(){
    _tabController = new TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController!.addListener(_handleTabSelection);
    _tabController!.animation!.addListener(() {
      final aniValue = _tabController!.animation!.value;
      if (aniValue - _currentIndex > 0.5) {
        setState(() {
          _currentIndex = _currentIndex + 1;
        });
      } else if (aniValue - _currentIndex < -0.5) {
        setState(() {
          _currentIndex = _currentIndex - 1;
        });
      }
    });
  }
  inistudent()async{
    setState(() {
      _isLoading = true;
      // your loader has started to load
    });

    //ConnectivityResult connectivityResult = await _connectivity.checkConnectivity();
    //if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)
    //{await db.getData("09121668152");}
    await dbExists();
    //print("Db Exists:"+dbexists.toString());
    if(dbexists)
     {
       this.students = await db.getAllStudents();
       if(this.students.length > 0)
       {
         await iniimages();
         this._selectedstu = this.students[0];
       }
    _fragmentView =  [
      ScreensHome( _selectedstu),
      LMSNotificationScreen( _selectedstu,false),
    ];
    setState(() {
      _isLoading = false; // your loder will stop to finish after the data fetch
    });}
     //print("fragments + "+this._fragmentView.length.toString());
     //await db.getimg(this._selectedstu!.StudentID.toString());
  }
  onTapped(value) {
    setState(() {
      _currentIndex = value;
    });
  }

 // this._fragmentView =
  dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  final List<String> _fragmentTitle = [
    "Asco Progress Academy",
    "Parent(Guardian) Verification",
    "Notifications",
  ];

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
   dbExists () async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "done.db");
    bool dbexist = await databaseExists(path);
    setState(() {
      dbexists = dbexist;
    });
  }

 Future<int> iniimages  () async
 {
   for(int i=0;i< this.students.length; i++)
   {this.students[i].img ="./assets/brand/progress_logo.png";
   io.Directory documentDirectory = await getApplicationDocumentsDirectory();
   String path = "/storage/emulated/0"+ documentDirectory.path ;
   io.File direct = new io.File(join(path, "photo/"+this.students[i].StudentID.toString()+".png"));
   String imgpath =join(path, "photo/"+this.students[i].StudentID.toString()+".png");
   //print("the path is here .."+imgpath);
   if(await direct.exists())
   {
     this.students[i].img = imgpath;
   }
   }
   return 0 ;
 }
 inipages ()
 {
   setState(() {
   _fragmentView =  [
     ScreensHome( _selectedstu),
     LMSNotificationScreen( _selectedstu,false),
     ];});
 }
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Future<Null> refreshData() async {
    refreshKey.currentState?.show(atTop: false);
    ConnectivityResult connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)
    {
      List<Addresses> add = await db.getAddressByStudent(_selectedstu!.StudentID);
      await db.getDataNopermission(add[0].FathersMobile == "" ? add[0].MothersMobile : add[0].FathersMobile);
      inistudent().whenComplete((){
      setState(() {});
                });
    }
  }
  Future<void> logout()
  async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    //String path = join(documentDirectory.path, "progress.db");
    String path2 = join(documentDirectory.path, "done.db");
    //await deleteDatabase(path);
    await deleteDatabase(path2);
    await dbExists ();
    Restart.restartApp();
  }

  @override
  Widget build(BuildContext context)  {
    //You will need to initialize MySize class for responsive spaces.
    MySize().init(context);
    themeData = Theme.of(context);
    if(!_isLoading)
    {WidgetsBinding.instance!.addPostFrameCallback((_) => inipages());}
    if(!dbexists)
      {WidgetsBinding.instance!.addPostFrameCallback((_) => inistudent());}
       return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
        customAppTheme = AppTheme.getCustomAppTheme(value.themeMode());
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: FxAppTheme.theme.copyWith(
                colorScheme: AppTheme.theme.colorScheme
                    .copyWith(secondary: AppTheme.theme.colorScheme.primary.withAlpha(80))),
            home:  Scaffold(
              key: _drawerKey,
              bottomNavigationBar: BottomAppBar(
                  elevation: 0,
                  shape: CircularNotchedRectangle(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: themeData.bottomAppBarTheme.color,
                      boxShadow: [
                        BoxShadow(
                          color: themeData.cardTheme.shadowColor!.withAlpha(40),
                          blurRadius: 3,
                          offset: Offset(0, -3),
                        ),
                      ],
                    ),
                    padding: Spacing.vertical(12),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: themeData.colorScheme.primary,
                      tabs: <Widget>[
                        Container(
                          child: (_currentIndex == 0)
                              ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                MdiIcons.home,
                                color: themeData.colorScheme.primary,
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 4),
                                decoration: BoxDecoration(
                                    color: themeData.primaryColor,
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(2.5))),
                                height: 5,
                                width: 5,
                              )
                            ],
                          )
                              : Icon(
                            MdiIcons.homeOutline,
                            color: themeData.colorScheme.onBackground,
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: 24),
                            child: (_currentIndex == 1)
                                ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  MdiIcons.androidMessages,
                                  color: themeData.colorScheme.primary,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 4),
                                  decoration: BoxDecoration(
                                      color: themeData.primaryColor,
                                      borderRadius: new BorderRadius.all(
                                          Radius.circular(2.5))),
                                  height: 5,
                                  width: 5,
                                )
                              ],
                            )
                                : Icon(
                              MdiIcons.androidMessages,
                              color: themeData.colorScheme.onBackground,
                            )),
                      ],
                    ),
                  )),
              backgroundColor: FxAppTheme.customTheme.bgLayer1,
              appBar: AppBar(
                elevation: 0,

                backgroundColor: FxAppTheme.customTheme.bgLayer2,
                title: Text(_fragmentTitle[_selectedPage],
                    style: AppTheme.getTextStyle(themeData.textTheme.headline6,
                        fontWeight: 600)),
              ),
              body:  !dbexists ? OTPVerificationScreen() : (_isLoading
                ?Center(child: CircularProgressIndicator(),) :
              new TabBarView(
                controller: _tabController,
                children:<Widget>[
                Tab(child:new RefreshIndicator(
                  onRefresh:refreshData,
                    key: refreshKey,
                    child:_fragmentView[0]
                )),
                _fragmentView[1],]
              )),// _isLoading
                  //?Center(child: CircularProgressIndicator(),) : TabBarView(
                //controller: _tabController,
                //children: <Widget>[
                  //_fragmentView[2],
                  //fragmentView[4],
               // ]),
              //Row(children:<Widget>[_fragmentView[_selectedPage],
              //  ]),
              drawer:  !dbexists ?Drawer(
                  child: Container(
                    color: customAppTheme.bgLayer1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SafeArea(
                          child: Container(
                            padding: Spacing.only(left: 16, bottom: 24, top: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image(
                                  image: AssetImage("./assets/brand/progress_logo.png"),
                                  height: 102,
                                  width: 102,
                                ),
                                Space.height(16),
                                Container(
                                  padding: Spacing.fromLTRB(12, 4, 12, 4),
                                  decoration: BoxDecoration(
                                      color: themeData.colorScheme.primary
                                          .withAlpha(40),
                                      borderRadius: Shape.circular(16)),
                                  child: Text("Nothing succeeds like success.",
                                      style: AppTheme.getTextStyle(
                                          themeData.textTheme.caption,
                                          color: themeData.colorScheme.primary,
                                          fontWeight: 600,
                                          letterSpacing: -0.2)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  )):Drawer(
                  child: Container(
                color: customAppTheme.bgLayer1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SafeArea(
                      child: Container(
                        padding: Spacing.only(left: 16, bottom: 24, top: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image: AssetImage("./assets/brand/progress_logo.png"),
                              height: 102,
                              width: 102,
                            ),
                            Space.height(16),
                            Container(
                              padding: Spacing.fromLTRB(12, 4, 12, 4),
                              decoration: BoxDecoration(
                                  color: themeData.colorScheme.primary
                                      .withAlpha(40),
                                  borderRadius: Shape.circular(16)),
                              child: Text("Nothing succeeds like success.",
                                  style: AppTheme.getTextStyle(
                                      themeData.textTheme.caption,
                                      color: themeData.colorScheme.primary,
                                      fontWeight: 600,
                                      letterSpacing: -0.2)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    Container(
                      color: customAppTheme.bgLayer1,
                      child: ListTile(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  SelectThemeDialog());
                        },
                        title: Text(
                          "Select Theme",
                          style: AppTheme.getTextStyle(
                              themeData.textTheme.subtitle2,
                              fontWeight: 600),
                        ),
                        trailing: Icon(Icons.chevron_right,
                            color: themeData.colorScheme.onBackground),
                      ),
                    ),
                    Divider(),
                    Container(
                        padding: FxSpacing.fromLTRB(16,8,0,0),
                        child: FxText.caption("Students".toUpperCase(),fontWeight: 700,muted: true,letterSpacing: 0.5,)),
                    Expanded(
                      flex: 5,
                      child: Container(
                        color: customAppTheme.bgLayer1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: this.students.map((e) {
                              return new ListTile(
                              leading: Icon(
                                MdiIcons.faceProfile,
                                color: _selectedPage == 2
                                    ? themeData.colorScheme.primary
                                    : themeData.colorScheme.onBackground,
                                size: 24,
                              ),
                              title: Text(e.Name,
                                  style: AppTheme.getTextStyle(
                                      themeData.textTheme.subtitle2,
                                      fontWeight:
                                      _selectedPage == 2 ? 700 : 600,
                                      color: _selectedPage == 2
                                          ? themeData.colorScheme.primary
                                          : themeData
                                          .colorScheme.onBackground)),
                              onTap: () {
                                setState(() {
                                  _selectedstu = e;
                                  _drawerKey.currentState!.openEndDrawer();
                                  _tabController!.index = 0;
                                });
                              },
                            );
                          }).toList()
                        ),
                      ),
                    ),
                    Divider(),
                    Container(
                      color: customAppTheme.bgLayer1,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(
                                MdiIcons.logout,
                                color: _selectedPage == 2
                                    ? themeData.colorScheme.primary
                                    : themeData.colorScheme.onBackground,
                                size: 24,
                              ),
                              title: Text("Log Out",
                                  style: AppTheme.getTextStyle(
                                      themeData.textTheme.subtitle2,
                                      fontWeight:
                                      _selectedPage == 2 ? 700 : 600,
                                      color: _selectedPage == 2
                                          ? themeData.colorScheme.primary
                                          : themeData
                                          .colorScheme.onBackground)),
                              onTap: () {
                                logout();
                                setState(() {
                                  _drawerKey.currentState!.openEndDrawer();
                                });
                              },
                            )
                          ]
                      ),
                    )
                  ],
                ),
              )),
            ));
      },
    );
  }

}


