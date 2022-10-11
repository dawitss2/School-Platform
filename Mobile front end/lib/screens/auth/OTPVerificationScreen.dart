/*
* File : OTP verification
* Version : 1.0.0
* */
import 'package:UIKit/sqlite.dart';
import 'package:dio/dio.dart';
import 'package:UIKit/utils/SizeConfig.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../AppTheme.dart';
import '../../AppThemeNotifier.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class OTPVerificationScreen extends StatefulWidget {
  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  TextEditingController? _numberController,
      _otp1Controller,
      _otp2Controller,
      _otp3Controller,
      _otp4Controller;
  FocusNode? _otp1FocusNode, _otp2FocusNode, _otp3FocusNode, _otp4FocusNode;
  FToast fToast = FToast();
  late ThemeData themeData;
  bool isInVerification = false;
  bool authed = false;
  bool verifying = false;
  bool connected = false;
  bool loading = false;
  List<bool> _dataExpansionPanel = [true, false];
  final Connectivity _connectivity = Connectivity();
  bool permissionGranted = false;
  @override
  void initState() {
    super.initState();
    fToast.init(context);
    checkconnection();
    _numberController = TextEditingController();
    _otp1Controller = TextEditingController();
    _otp2Controller = TextEditingController();
    _otp3Controller = TextEditingController();
    _otp4Controller = TextEditingController();

    _otp1FocusNode = FocusNode();
    _otp2FocusNode = FocusNode();
    _otp3FocusNode = FocusNode();
    _otp4FocusNode = FocusNode();
    _otp1Controller!.addListener(() {
      if (_otp1Controller!.text.length >= 1) {
        _otp2FocusNode!.requestFocus();
      }
    });

    _otp2Controller!.addListener(() {
      if (_otp2Controller!.text.length >= 1) {
        _otp3FocusNode!.requestFocus();
      }
    });

    _otp3Controller!.addListener(() {
      if (_otp3Controller!.text.length >= 1) {
        _otp4FocusNode!.requestFocus();
      }
    });
  }
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
  Future _getStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {
        permissionGranted = false;
      });
    }
  }
  _showToast(String? message) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.red[400],
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
  void dispose() {
    super.dispose();
    _numberController!.dispose();
    _otp1Controller!.dispose();
    _otp2Controller!.dispose();
    _otp3Controller!.dispose();
    _otp4Controller!.dispose();
    _otp1FocusNode!.dispose();
    _otp2FocusNode!.dispose();
    _otp3FocusNode!.dispose();
    _otp4FocusNode!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    themeData = Theme.of(context);
    WidgetsBinding.instance!.addPostFrameCallback((_) => checkconnection());
    if(verifying == true)
      {
        WidgetsBinding.instance!.addPostFrameCallback((_) => authresult(_numberController!.text));
      }
    return Consumer<AppThemeNotifier>(
      builder: (BuildContext context, AppThemeNotifier value, Widget? child) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.getThemeFromThemeMode(value.themeMode()),
            home: Scaffold(
              resizeToAvoidBottomInset:false,
                body:SingleChildScrollView(
                child:Stack(
              children: <Widget>[
                Center(
                  child:Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 16, left: 8, bottom: 12),
                        child: Text(
                          "Parent(Guardian) Verification",
                          style: AppTheme.getTextStyle(themeData.textTheme.subtitle2,fontWeight: 700),

                        ),
                      ),
                      loading ? Center(child: Stack(
                          children: <Widget>[
                            Center(
                              child: Container(
                                width: 50,
                                height: 50,
                                child: new CircularProgressIndicator(),
                              ),
                            ),
                            Center(child: Text("Loading ...",
                                style: TextStyle())
                            ),
                          ],)):Container(
                        margin: EdgeInsets.only(top: MySize.size32!, left: MySize.size16!, right: MySize.size16!),
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
                                      child: Text("Phone Number",
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
                                   controller: _numberController,
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
                                            MdiIcons.phoneOutline,
                                            size: 22,
                                            color: themeData
                                                .colorScheme.onBackground
                                                .withAlpha(200),
                                          ),
                                          isDense: true,
                                          contentPadding: EdgeInsets.all(0),
                                        ),
                                        keyboardType: TextInputType.number,
                                        autofocus: false,
                                      ),

                                    ],
                                  ),
                                ),

                                isExpanded: _dataExpansionPanel[0]),
                            ExpansionPanel(
                                canTapOnHeader: true,
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return Container(
                                      padding: EdgeInsets.all(16),
                                      child: Text("Enter Pin Code ",
                                          style: AppTheme.getTextStyle(
                                              themeData.textTheme.subtitle1,
                                              fontWeight: isExpanded
                                                  ? 600
                                                  : 500)));
                                },
                                body: Container(
                                    padding:
                                        EdgeInsets.only(bottom: MySize.size16!, top: MySize.size8!),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            singleDigitWidget(_otp1Controller,
                                                _otp1FocusNode),
                                            singleDigitWidget(_otp2Controller,
                                                _otp2FocusNode),
                                            singleDigitWidget(_otp3Controller,
                                                _otp3FocusNode),
                                            singleDigitWidget(_otp4Controller,
                                                _otp4FocusNode),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(MySize.size8!)),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: themeData
                                                        .colorScheme.primary
                                                        .withAlpha(24),
                                                    blurRadius: 3,
                                                    offset: Offset(0, 1),
                                                  ),
                                                ],
                                              ),
                                              child: ElevatedButton(
                                                  style: ButtonStyle(
                                                      padding: MaterialStateProperty.all(Spacing.xy(16, 0))
                                                  ),
                                                  onPressed: () {
                                                    //print(connected);
                                                    if(connected==false)
                                                      { _showToast("Please Connect to Wifi or to a Data Service ");
                                                      }
                                                    else{
                                                     String pin = _otp1Controller!.text + _otp2Controller!.text+_otp3Controller!.text+_otp4Controller!.text;
                                                     auth( _numberController!.text,pin);
                                                     print("phone num" + _numberController!.text + "pin" + pin);}
                                                    },
                                                  child: Text("Verify",
                                                      style: AppTheme.getTextStyle(
                                                          themeData.textTheme
                                                              .bodyText2,
                                                          fontWeight:600,
                                                          color: themeData.colorScheme.onPrimary))),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                                isExpanded: _dataExpansionPanel[0])
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ))));
      },
    );
  }
   auth(String? phoneNum,String? pin ) async {
    try {
      var response = await Dio().get(
          "https://ascoprogress.com/progress_api/studentreception.php?auth=" +
              phoneNum!);
      var data = response.data;
      if(data == pin)
      {
        print(data);
        setState((){
        verifying = true;
        authed = true;
          });
       }
      else
        {
          _showToast("Wrong Phone Number or Pin, Please Retry ");
          setState((){
            authed = false;
          });
        }
    }
    catch(e){print(e);return false;}
  }
  Future<void> authresult(String? mobNum)
  async {
    setState(() {
      verifying = false;
    });
    if(authed ==true)
    {
      setState(() {
        loading = true;
      });
      await _getStoragePermission();
      //var db =  new SqliteDB();
      print("authenticated");
      await new SqliteDB().iniData(mobNum,permissionGranted);
    }
    else
    {
    }
  }
  void onSendOTP() {
    if (!isInVerification) {
      FocusScope.of(context).unfocus();
      setState(() {
        isInVerification = false; // use here own logic
        _dataExpansionPanel[1] = true;
      });
    }
  }

  Widget singleDigitWidget(
      TextEditingController? _controller, FocusNode? _focusNode) {
    return Container(
      width: 36,
      height: 48,
      margin: EdgeInsets.symmetric(horizontal: MySize.size4!),
      color: Colors.transparent,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            border: UnderlineInputBorder(
                borderSide: BorderSide(
                    width: 2,
                    color: themeData
                        .inputDecorationTheme.border!.borderSide.color)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    width: 2,
                    color: themeData
                        .inputDecorationTheme.enabledBorder!.borderSide.color)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    width: 2,
                    color: themeData
                        .inputDecorationTheme.focusedBorder!.borderSide.color)),
            helperText: ""),
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
        ],
        keyboardType: TextInputType.number,
      ),
    );
  }
}
