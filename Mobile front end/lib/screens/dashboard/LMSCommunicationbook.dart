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
import 'package:UIKit/distnictdata.dart';
import 'package:UIKit/sqlite.dart';
import 'package:UIKit/Notice.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:UIKit/Quotes.dart';
import 'package:UIKit/CommbookWeekly.dart';
import 'package:UIKit/CommbookMonthly.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class LMSCommunicationBook extends StatefulWidget {
  Student? _selectedstu;
  bool _ismonthly = true;
  LMSCommunicationBook(Student? stu,bool ismonthly)
  {
    this._selectedstu = stu;
    _ismonthly = ismonthly;
  }
  @override
  _LMSDashboardScreenState createState() => _LMSDashboardScreenState();
}

class _LMSDashboardScreenState extends State<LMSCommunicationBook> {
  final db = SqliteDB();
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
      toastDuration: Duration(seconds: 5),
    );
  }
  ScrollController _cont = new ScrollController();
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
                  title: Text("Communication Book",
                      style: AppTheme.getTextStyle(
                          themeData.textTheme.headline6,
                          fontWeight: 600)),
                ),
                body: Container(
                    color: themeData.backgroundColor,
                    child: new ListView(
                     physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
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
                            "Communication Book : ",
                            style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                                fontWeight: 600,fontSize:16,color:Colors.blue),
                          ),
                        ),
                        widget._ismonthly
                              ? _SubmissionWidget(db,widget._selectedstu!) : _SubmissionWidgetweekly(db,widget._selectedstu!),
                      ],
                    ))));
      },
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
class _SubmissionWidgetweekly extends StatefulWidget {
  SqliteDB? db ;
  Student? selected;
  _SubmissionWidgetweekly(SqliteDB dbc,_selectedstu) {
    this.db = dbc;
    this.selected = _selectedstu;
  }
  @override
  _SubmissionWidgetStateweekly createState() => _SubmissionWidgetStateweekly();
}

class _SubmissionWidgetState extends State<_SubmissionWidget> {
  List<Commbookmonthly> _monthly = [];
  List<distnictdata> _months =[];
  bool _isLoading = false;
  int currentStep = 0;
  late ThemeData themeData;
  initdata() async{
    setState(() {
      _isLoading = true; // your loader has started to load
    });
    List<Commbookmonthly> __monthly  = await widget.db!.getMonthlyCommByStudent(widget.selected!.StudentID);
    List<distnictdata> __months = await widget.db!.getDistnictMonthlyCommByStudent(widget.selected!.StudentID);
    this.setState(() {
      this._monthly = __monthly;
      this._months = __months;
    });
    //print(this._monthly.toString());
    //print(this._months.toString());
    setState(() {
      if(_monthly.length > 0)
      {_isLoading = false;
      }
      else
        {
          _NoData();
        }// your loder will stop to finish after the data fetch
    });
  }
  void initState()  {
    super.initState();
    fToast.init(context);
    initdata();
  }
  FToast fToast = FToast();
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
          Expanded(child:Text('No Communication to display, yet ! ( Coming Soon )',
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
  _showToast(String? message) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: message=='Feedback Sent'?Colors.green[400]:Colors.red[400],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12.0,
          ),
          Expanded(child:Text(message!,
            style: TextStyle(
                color: Colors.black,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold
            ),
          )),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 5),
    );
  }
  @override
  void dispose() {
    super.dispose();
    _feedback!.dispose();}
  ScrollController _cont = new ScrollController();
  List<bool> _dataExpansionPanel = [true, false];
  TextEditingController? _feedback = TextEditingController();
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
            { if(pos == this._months.length - 1)
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
      steps: this._months .map((e) {
        return new Step(
          isActive: true,
          state: StepState.complete,
          title: Text(
            e.val,
            style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                fontWeight: 790,fontSize:18),
          ),
          subtitle: Text("Monthly Report",
              style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                  fontWeight: 600,fontSize:16,color:Colors.blue)),
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: new ListView(
                scrollDirection: Axis.vertical,
                physics:ClampingScrollPhysics(),
                controller: _cont,
                shrinkWrap: true,
                children:this._monthly.where((i)=> i.MonthName == e.val ).map((x){
                 return  Container(
                   margin: EdgeInsets.only(bottom: MySize.size8!, left: MySize.size8!,right: MySize.size8!,top:MySize.size8!),
                   padding:EdgeInsets.only(bottom: MySize.size8!, left: MySize.size8!,right: MySize.size8!,top:MySize.size8!) ,
                   decoration: BoxDecoration(
                       border: Border.all(
                         color:Colors.redAccent,
                       ),
                       borderRadius: BorderRadius.all(Radius.circular(10))
                   ),
                   child: new Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children:<Widget>[ Text(
                          x.commitem ,
                         style: TextStyle(
                             color: Colors.blue,
                             letterSpacing: 2.0,
                             fontSize: 14.0,
                             fontWeight: FontWeight.bold
                         ),),
                         SizedBox(height: 5.0),
                         Text(
                           x.Value ,
                           style: themeData.textTheme.caption!.merge(
                               TextStyle(color: themeData.colorScheme.onBackground)),),
                         SizedBox(height: 10.0),
                       ]),
                 );
                }).toList(),
            ),
          ),
        );
      }).toList(),
    ));
  }
  bool connected = false;
  final Connectivity _connectivity = Connectivity();
  checkconnection() async
  {
    ConnectivityResult connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)
    {
      setState(() {
        connected = true;
      });
    }
    else
    {
      setState(() {
        connected = false;
      });
    }
  }


  Widget _buildControlBuilder(int position) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => checkconnection());
    //if (position == 0 || position == 1) {
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
            child: ExpansionPanelList(
                  expandedHeaderPadding: EdgeInsets.all(0),
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _dataExpansionPanel[index] = !isExpanded;
                    });
                  },
                  animationDuration: Duration(milliseconds: 500),
                  children: <ExpansionPanel>[
                    ExpansionPanel(
                        canTapOnHeader: true,
                        headerBuilder:
                            (BuildContext context, bool isExpanded) {
                          return Container(
                              padding: EdgeInsets.all(MySize.size16!),
                              child: Text("Write Feedback",
                                  style: AppTheme.getTextStyle(
                                      themeData.textTheme.subtitle1,
                                      fontWeight: isExpanded
                                          ? 600
                                          : 400)));
                        },
                        body:  Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _feedback,
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.bodyText1,
                                    letterSpacing: 0.1,
                                    color: themeData
                                        .colorScheme.onBackground,
                                    fontWeight: 500),
                                decoration: InputDecoration(
                                  prefixStyle: AppTheme.getTextStyle(
                                      themeData.textTheme.subtitle2,
                                      letterSpacing: 0.1,
                                      color: themeData
                                          .colorScheme.onBackground,
                                      fontWeight: 500),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                      borderSide: BorderSide.none),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                      borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                      borderSide: BorderSide.none),
                                  filled: true,
                                  fillColor:
                                  themeData.colorScheme.background,
                                  prefixIcon: Icon(
                                    MdiIcons.text,
                                    size: 22,
                                    color: themeData
                                        .colorScheme.onBackground
                                        .withAlpha(200),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(0),
                                ),
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                autofocus: false,
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(Spacing.xy(16, 0))
                                  ),
                                  onPressed: () {
                                    if(connected==false)
                                    {
                                      _feedback!.clear();
                                      _showToast("Please Connect to Wifi or to a Data Service ");
                                      _feedback!.clear();
                                    }
                                    else{
                                     // print(_feedback!.text);
                                      widget.db!.sendmonthlyfeedback(widget.selected!.StudentID.toString(),this._months[position].val,_feedback!.text);
                                      //print(this._months[position].val);
                                      _showToast("Feedback Sent");
                                      _feedback!.clear();
                                    }
                                  },
                                  child: Text("Submit",
                                      style: AppTheme.getTextStyle(
                                          themeData.textTheme
                                              .bodyText2,
                                          fontWeight:600,
                                          color: themeData.colorScheme.onPrimary)))
                            ],
                          ),
                        ),

                        isExpanded: _dataExpansionPanel[0]),
                  ],
                ),
                )),
        );
    //}
    
  }
}
class _SubmissionWidgetStateweekly extends State<_SubmissionWidgetweekly> {
  List<Commbookweekly> _weekly=[];
  List<distnictdata> _weeks =[];
  bool _isLoading = false;
  int currentStep = 0;
  List<bool> _dataExpansionPanel = [true, false];
  TextEditingController? _feedback = TextEditingController();
  late ThemeData themeData;
  FToast fToast = FToast();
  @override
  void dispose() {
    super.dispose();
    _feedback!.dispose();}
  initdata() async{
    setState(() {
      _isLoading = true; // your loader has started to load
    });
    List<Commbookweekly> __weekly = await widget.db!.getWeeklyCommByStudent(widget.selected!.StudentID);
    List<distnictdata> __weeks = await widget.db!.getDistnictWeeklyCommByStudent(widget.selected!.StudentID);
    //print(__weekly.toString());
    this.setState(() {
      this._weekly = __weekly;
      this._weeks = __weeks;
    });
    setState(() {
      if(_weekly.length > 0)
      {_isLoading = false;}
      else
        {
          _NoData();
        }// your loder will stop to finish after the data fetch
    });
    //print("results "+this._results.toString());
  }

  void initState()  {
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
          Expanded(child:Text('No Communication to display, yet ! ( Coming Soon )',
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
  _showToast(String? message) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: message=='Feedback Sent'?Colors.green[400]:Colors.red[400],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12.0,
          ),
          Expanded(child:Text(message!,
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
      toastDuration: Duration(seconds: 5),
    );
  }
  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    return  Scrollbar(
        child: _isLoading
        ? Center(child: CircularProgressIndicator(),):
    Stepper(
      physics: ClampingScrollPhysics(),
      controlsBuilder: (BuildContext context,
          {VoidCallback? onStepContinue, VoidCallback? onStepCancel}) {
        return _buildControlBuilder(currentStep);
      },
      currentStep: currentStep,
      onStepTapped: (pos) {
        setState(() {
          if(currentStep == pos)
          { if(pos == this._weeks.length - 1)
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
      steps: this._weeks.map((e) {
        return new Step(
          isActive: true,
          state: StepState.complete,
          title: Text(
            e.val,
            style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                fontWeight: 790,fontSize:18),
          ),
          subtitle: Text("Weekly Report",
              style: AppTheme.getTextStyle(themeData.textTheme.bodyText1,
                  fontWeight: 600,fontSize:16,color:Colors.blue)),
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: ListView(
              shrinkWrap: true,
              physics:ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children:this._weekly.where((i)=> i.WeekName == e.val ).map((x){
                return new Container(
                    margin: EdgeInsets.only(bottom: MySize.size8!, left: MySize.size8!,right: MySize.size8!,top:MySize.size8!),
                    padding:EdgeInsets.only(bottom: MySize.size8!, left: MySize.size8!,right: MySize.size8!,top:MySize.size8!) ,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color:Colors.redAccent,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                    ),
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:<Widget>[ Text(
                         x.commitem ,
                        style: TextStyle(
                            color: Colors.blue,
                            letterSpacing: 2.0,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold
                        ),),
                        SizedBox(height: 5.0),
                        Text(
                          x.Value ,
                          style: themeData.textTheme.caption!.merge(
                              TextStyle(color: themeData.colorScheme.onBackground)),),
                        SizedBox(height: 10.0),
                      ]),
                );
              }).toList(),
            ),
          ),
        );
      }).toList(),
    ));
  }
  bool connected = false;
  final Connectivity _connectivity = Connectivity();
  checkconnection() async
  {
    ConnectivityResult connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi)
    {
      setState(() {
        connected = true;
      });
    }
    else
    {
      setState(() {
        connected = false;
      });
    }
  }

  Widget _buildControlBuilder(int position) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => checkconnection());
    if (position == 0 || position == 1) {
      return Container(
        margin: EdgeInsets.only(top: MySize.size8!),
        child: Align(
          alignment: Alignment.center,
          child: Container(
                child: ExpansionPanelList(
                  expandedHeaderPadding: EdgeInsets.all(0),
                  expansionCallback: (int index, bool isExpanded) {
                    setState(() {
                      _dataExpansionPanel[index] = !isExpanded;
                    });
                  },
                  animationDuration: Duration(milliseconds: 500),
                  children: <ExpansionPanel>[
                    ExpansionPanel(
                        canTapOnHeader: true,
                        headerBuilder:
                            (BuildContext context, bool isExpanded) {
                          return Container(
                              padding: EdgeInsets.all(MySize.size16!),
                              child: Text("Write Feedback ",
                                  style: AppTheme.getTextStyle(
                                      themeData.textTheme.subtitle1,
                                      fontWeight: isExpanded
                                          ? 600
                                          : 400)));
                        },
                        body:  Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                controller: _feedback,
                                style: AppTheme.getTextStyle(
                                    themeData.textTheme.bodyText1,
                                    letterSpacing: 0.1,
                                    color: themeData
                                        .colorScheme.onBackground,
                                    fontWeight: 500),
                                decoration: InputDecoration(
                                  prefixStyle: AppTheme.getTextStyle(
                                      themeData.textTheme.subtitle2,
                                      letterSpacing: 0.1,
                                      color: themeData
                                          .colorScheme.onBackground,
                                      fontWeight: 500),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                      borderSide: BorderSide.none),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                      borderSide: BorderSide.none),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                      borderSide: BorderSide.none),
                                  filled: true,
                                  fillColor:
                                  themeData.colorScheme.background,
                                  prefixIcon: Icon(
                                    MdiIcons.text,
                                    size: 22,
                                    color: themeData
                                        .colorScheme.onBackground
                                        .withAlpha(200),
                                  ),
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(0),
                                ),
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                autofocus: false,
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      padding: MaterialStateProperty.all(Spacing.xy(16, 0))
                                  ),
                                  onPressed: () {
                                    if(connected==false)
                                    {
                                      _feedback!.clear();
                                      _showToast("Please Connect to Wifi or to a Data Service");
                                    }
                                    else{
                                      //print(this._weeks[position].val);
                                      widget.db!.sendweeklyfeedback(widget.selected!.StudentID.toString(),this._weeks[position].val,_feedback!.text);
                                      _showToast("Feedback Sent");
                                      _feedback!.clear();
                                    }
                                  },
                                  child: Text("Submit",
                                      style: AppTheme.getTextStyle(
                                          themeData.textTheme
                                              .bodyText2,
                                          fontWeight:600,
                                          color: themeData.colorScheme.onPrimary)))
                            ],
                          ),
                        ),

                        isExpanded: _dataExpansionPanel[0]),

                  ],
                )),
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
          child: ElevatedButton(

              onPressed: () {},
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(Spacing.xy(16, 0))
              ),              child: Text("Submitted".toUpperCase(),
              style: AppTheme.getTextStyle(themeData.textTheme.caption,
                  color: themeData.colorScheme.onSecondary,
                  letterSpacing: 0.3,
                  fontWeight: 600))),
        ),
        ),
      );
  }
}
