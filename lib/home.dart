import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:loanproject/privacy.dart';
import 'package:loanproject/terms.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:loanproject/size_config.dart';
import 'package:loanproject/state.dart';
import 'package:loanproject/webview.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:notification_permissions/notification_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'calculat.dart';

int counter;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppsflyerSdk appsflyerSdk = AppsflyerSdk({
    "afDevKey":
        Platform.isIOS ? 'XmphTEoVgARoCrhALJusC6' : 'XXzKfE9qPGH5XTrEysZc6W',
    "afAppId": '1570037577',
    "isDebug": true
  });
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  Random _rnd = Random();
  bool firstCheck = false;

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  String cuid = "";

  final InAppReview _inAppReview = InAppReview.instance;

  @override
  void initState() {
    initApsSdk();
    setCounter();
    super.initState();
    final _appState = Provider.of<AppState>(context, listen: false);

    Timer(Duration(seconds: 1), () async {
      if (counter == 0) {
        getCheckNotificationPermStatus().then((value) async {
          print(value);
          if (value != "granted") {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => yourFunction(context));
            final SharedPreferences pref =
                await SharedPreferences.getInstance();
            if (pref.getInt("count") == 0) {
              pref.setInt("count", 1);
            }
          } else {
            OneSignal.shared.setNotificationOpenedHandler((notification) {
              Map userId = {'CUID': _appState.cuid};
              logEvent('GetLoan', userId);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => WebScreen()));
            });
          }
        });
      }
      if (counter == 3) {
        if (_inAppReview.isAvailable() == true) {
          _inAppReview.requestReview();
        }
      }
    });
    OneSignal.shared.setNotificationOpenedHandler((notification) {
              Map userId = {'CUID': _appState.cuid};
              logEvent('GetLoan', userId);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => WebScreen()));
            });
  }

  void setCounter() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    counter = pref.getInt("count");
    if (pref.getInt("count") == 5) {
      pref.remove("count");
    }
  }

  /// Checks the notification permission status
  Future<String> getCheckNotificationPermStatus() {
    var permGranted = "granted";
    var permDenied = "denied";
    var permUnknown = "unknown";
    var permProvisional = "provisional";

    return NotificationPermissions.getNotificationPermissionStatus()
        .then((status) {
      switch (status) {
        case PermissionStatus.denied:
          return permDenied;
        case PermissionStatus.granted:
          return permGranted;
        case PermissionStatus.unknown:
          return permUnknown;
        case PermissionStatus.provisional:
          return permProvisional;
        default:
          return null;
      }
    });
  }

  void initApsSdk() async {
    final _appState = Provider.of<AppState>(context, listen: false);
    cuid = getRandomString(15);
    appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true);
    appsflyerSdk.setCustomerUserId(cuid);
    appsflyerSdk.getAppsFlyerUID().then((value) {
      print(value);
      _appState.setCUID(cuid);
      _appState.setID(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final _appState = Provider.of<AppState>(context, listen: false);
    double height = MediaQuery.of(context).size.height;

    double sizeBox = 50;
    double sizeTextBottom = 4.5;
    double topPad = 220.0;

    if (height <= 670) {
      ///SE 2
      sizeBox = 10;
      sizeTextBottom = 4.5;
      topPad = 240.0;
    } else if (height <= 739 && height >= 710) {
      /// 7 Plus
      sizeBox = 10;
      sizeTextBottom = 4;
    } else if (height <= 812 && height >= 750) {
      ///X iphone & 11 Pro
      sizeBox = 20;
    }

    ImageProvider background = AssetImage('assets/images/back_main.png');

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: AppBar(
          backgroundColor: Colors.black,
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: background,
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(left: 0.0, right: 0.0, bottom: 10, top: 20.0),
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Padding(
                padding: EdgeInsets.only(top: topPad),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: sizeBox,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.0),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                  width: 1.0,
                                  color: Color(0xFFF1FF50),
                                ),
                                bottom: BorderSide(
                                  width: 1.0,
                                  color: Color(0xFFF1FF50),
                                ),
                              ),
                            ),
                            child: Text(
                              "APPLY FOR\nA LOAN",
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                color: Color(0xFF1D1D1D),
                                fontFamily: "Phonk",
                                fontSize: SizeConfig.heightMultiplier *
                                    sizeTextBottom,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 150,
                                width: 120,
                                child:
                                    Lottie.asset('assets/images/arrow.json')),
                            SizedBox(
                                height: 150,
                                width: 120,
                                child:
                                    Lottie.asset('assets/images/arrow.json')),
                            SizedBox(
                                height: 150,
                                width: 120,
                                child: Lottie.asset('assets/images/arrow.json'))
                          ]),
                      InkWell(
                        onTap: () async {
                          Map userId = {'CUID': _appState.cuid};
                          logEvent('GetLoan', userId);
                          OneSignal.shared
                              .sendTag("GetLoan", "GetLoan")
                              .then((response) {
                            print(
                                "Successfully sent tags with response: $response");
                          }).catchError((error) {
                            print("Encountered an error sending tags: $error");
                          });
                          _appState
                              .setOSID("70621a8c-7e46-46b9-88fd-1411a45982a3");

                          Timer(Duration(seconds: 1), () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WebScreen()),
                            );
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              right: 15.0, bottom: 0.0, top: 10.0, left: 15.0),
                          child: Padding(
                              padding: EdgeInsets.only(left: 0, right: 0),
                              child: SizedBox(
                                  width: double.infinity,
                                  // <-- match_parent
                                  child: Image.asset(
                                      'assets/images/button_next.png'))),
                        ),
                      ),
                    ]),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                    padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.05,
                      top: MediaQuery.of(context).size.height * 0.04,
                    ),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PrivacyPage()),
                            );
                          },
                          child: SvgPicture.asset("assets/images/img_menu.svg"),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TermsPage()),
                            );
                          },
                          child: SvgPicture.asset("assets/images/img_lock.svg"),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Calculat()),
                            );
                          },
                          child: SvgPicture.asset(
                              "assets/images/img_calculator.svg"),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> logEvent(String eventName, Map eventValues) async {
    bool result;
    try {
      result = await appsflyerSdk.logEvent(eventName, eventValues);
    } on Exception catch (exception) {
      print(exception);
    }
    return result;
  }

  yourFunction(BuildContext context) {
    return Dialogs.materialDialog(
      customView: Stack(children: [
        Container(
          padding: EdgeInsets.only(top: 0, bottom: 40),
          margin: EdgeInsets.only(top: 100),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF434343),
                    Color(0xFF202020),
                  ])),
          child: Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Stack(children: <Widget>[
              Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(
                    'assets/images/confeti.svg',
                  )),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Opacity(
                    opacity: 0,
                    child: Container(
                        padding: EdgeInsets.only(top: 55),
                        child: Text(
                          'Do you want to be aware of exclusive loan offers?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFFAFF00),
                            fontSize: 21.0,
                            fontFamily: 'Poppins-ExtraBold',
                          ),
                        )),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Do you want to be aware of exclusive loan offers?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFAFF00),
                          fontSize: 21.0,
                          fontFamily: 'Poppins-ExtraBold',
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.only(top: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //Center Row contents horizontally,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 50.0,
                            child: ElevatedButton(
                              onPressed: () async {
                                Map userId = {'open': 'open'};
                                logEvent('SpOfferYes', userId);
                                Navigator.of(context).pop();
                                OneSignal.shared
                                    .promptUserForPushNotificationPermission()
                                    .then((accepted) {
                                  if (accepted == true) {
                                    logEvent('push_accepted', userId);
                                    OneSignal.shared
                                        .sendTag("SpOfferYes", "SpOfferYes")
                                        .then((response) {
                                      print(
                                          "Successfully sent tags with response: $response");
                                    }).catchError((error) {
                                      print(
                                          "Encountered an error sending tags: $error");
                                    });
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(0.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFFFAFF00),
                                          Color(0xFF92D2FF),
                                        ]),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: 130.0, minHeight: 150.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "YES",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 21.0,
                                      fontFamily: 'Poppins-Bold',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 50.0,
                            child: ElevatedButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                OneSignal.shared
                                    .promptUserForPushNotificationPermission()
                                    .then((accepted) {
                                  if (accepted == true) {
                                    Map userId = {'open': 'open'};
                                    logEvent('push_accepted', userId);
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                              ),
                              child: Ink(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: [
                                          Color(0xFFFAFF00),
                                          Color(0xFF92D2FF),
                                        ]),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Container(
                                  constraints: BoxConstraints(
                                      maxWidth: 130.0, minHeight: 150.0),
                                  alignment: Alignment.center,
                                  child: Text(
                                    "NO",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 21.0,
                                      fontFamily: 'Poppins-Bold',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ],
              )
            ]),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            // padding: EdgeInsets.only(top: 15),
            child: SvgPicture.asset(
              'assets/images/CheckCircle.svg',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ]),
      actions: [],
      // msg:
      // '',
      // title: 'Do you want to be aware of exclusive loan offers',
      color: Colors.transparent,

      context: context,
    );
  }
}
