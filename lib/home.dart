import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:loanproject/privacy.dart';
import 'package:loanproject/terms.dart';
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

import 'calculat.dart';

Map appsFlyerOptions = {
  "afDevKey":
      Platform.isIOS ? 'XmphTEoVgARoCrhALJusC6' : 'XXzKfE9qPGH5XTrEysZc6W',
  "afAppId": '1570037577',
  "isDebug": true
};

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppsflyerSdk appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  Random _rnd = Random();
  bool firstCheck = false;

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  String cuid = "";

  final InAppReview _inAppReview = InAppReview.instance;

  Future<void> _requestReview() => _inAppReview.requestReview();

  @override
  void initState() {
    initApsSdk();
    super.initState();
    final _appState = Provider.of<AppState>(context, listen: false);
    Timer(Duration(seconds: 1), () {
      if (Platform.isIOS) {
        getCheckNotificationPermStatus().then((value) {
          print(value);
          if (value != "granted") {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => yourFunction(context));
          } else {
            OneSignal.shared.setNotificationOpenedHandler((notification) {
              Map userId = {'CUID': _appState.cuid};
              logEvent('GetLoan', userId);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WebScreen()),
              );
              print('GNIDA open from click from HOME');
            });
          }
        });
      } else {
        //OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

        // OneSignal.shared
        //     .init("51c9806a-db8c-4dbf-b544-26f6cc9b8fd0");
        //  OneSignal.shared
        //     .setAppId("51c9806a-db8c-4dbf-b544-26f6cc9b8fd0");

        OneSignal.shared.setNotificationOpenedHandler((notification) {
          Map userId = {'CUID': _appState.cuid};
          logEvent('GetLoan', userId);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WebScreen()),
          );
          print('GNIDA open from click from HOME');
        });
      }

      _appState.checkCountOpen().then((value) {
        if (value == 4) {
          _requestReview();
          _appState.removeCountOpen();
        } else {
          _appState.setCountOpen();
        }
      });
    });
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(height);
    double bottomPadding = 50.0;
    double bottomPaddingBlock = 10.0;

    // if(Platform.isAndroid && height > 670 && height <= 700){
    //   bottomPadding = 25.0;
    //   bottomPaddingBlock = 70.0;
    // }
    if (height <= 670) {
      ///SE 2
      bottomPadding = 25.0;
      bottomPaddingBlock = 70.0;
    } else if (height <= 900 && height >= 895) {
      ///XS Max & XR & 11 & 11 Pro Max
      bottomPadding = 90.0;
      bottomPaddingBlock = 150.0;
    } else if (height <= 1000 && height >= 900) {
      ///12 pro max
      bottomPadding = 90.0;
      bottomPaddingBlock = 150.0;
      //else if (height <= 739 && height >= 730) {
    } else if (height <= 739 && height >= 710) {
      /// 7 Plus
      bottomPadding = 35.0;
      bottomPaddingBlock = 90.0;
      //else if (height <= 812 && height >= 750) {
    } else if (height <= 812 && height >= 750) {
      ///X iphone & 11 Pro
      bottomPadding = 70.0;
      bottomPaddingBlock = 120.0;
    } else if (height <= 845 && height >= 840) {
      ///12 iphone & 12 Pro
      bottomPadding = 70.0;
      bottomPaddingBlock = 120.0;
    }

    double sizeImage = 0.95;
    double sizeBox = 50;
    double sizeTextMain = 1.8;
    double sizeTextBottom = 4.5;
    double topPad = 220.0;

    if (height <= 670) {
      ///SE 2
      sizeImage = 1;
      sizeBox = 10;
      sizeTextMain = 2.3;
      sizeTextBottom = 4.5;
      topPad = 240.0;
    } else if (height <= 900 && height >= 895) {
      ///XS Max & XR & 11 & 11 Pro Max

    } else if (height <= 1000 && height >= 900) {
      ///12 pro max

    } else if (height <= 739 && height >= 710) {
      /// 7 Plus
      sizeImage = 0.75;
      sizeBox = 10;
      sizeTextMain = 2.3;
      sizeTextBottom = 4;
    } else if (height <= 812 && height >= 750) {
      ///X iphone & 11 Pro
      sizeBox = 20;
    } else if (height <= 845 && height >= 840) {
      ///12 iphone & 12 Pro

    }

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(0.0), // here the desired height
            child: AppBar(
              backgroundColor: Colors.black, // Status bar color
            )),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/back_main.png'),
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
                        children: <Widget>[
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
                              //Center Row contents horizontally,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: 150,
                                    width: 120,
                                    child: Lottie.asset(
                                        'assets/images/arrow.json')),
                                SizedBox(
                                    height: 150,
                                    width: 120,
                                    child: Lottie.asset(
                                        'assets/images/arrow.json')),
                                SizedBox(
                                    height: 150,
                                    width: 120,
                                    child: Lottie.asset(
                                        'assets/images/arrow.json'))
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
                                  print(
                                      "Encountered an error sending tags: $error");
                                });

                                // var status = await OneSignal.shared
                                //     .getPermissionSubscriptionState();
                                //
                                // var playerId =
                                //     status.subscriptionStatus.userId;

                                  //
                                  _appState.setOSID(
                                      "70621a8c-7e46-46b9-88fd-1411a45982a3");
                                  // print(playerId);
                                  //_appState.setOSID(playerId);
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
                                      right: 15.0,
                                      bottom: 0.0,
                                      top: 10.0,
                                      left: 15.0),
                                  child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 0, right: 0),
                                      child: SizedBox(
                                          width: double.infinity,
                                          // <-- match_parent
                                          child: Image.asset(
                                              'assets/images/button_next.png'))),
                                ))
                          ])),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                        padding: EdgeInsets.only(
                          right: width * 0.05,
                          top: height * 0.04,
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
                              child: SvgPicture.asset(
                                  "assets/images/img_menu.svg"),
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
                              child: SvgPicture.asset(
                                  "assets/images/img_lock.svg"),
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
                ]))) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }

  Future<bool> logEvent(String eventName, Map eventValues) async {
    bool result;
    try {
      result = await appsflyerSdk.logEvent(eventName, eventValues);
    } on Exception catch (e) {}
    print("Result logEvent: $result");
  }

  yourFunction(BuildContext context) {
    return Dialogs.materialDialog(
      customView: Stack(children: <Widget>[
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

                                  // OneSignal.shared.setLogLevel(
                                  //     OSLogLevel.verbose, OSLogLevel.none);
                                  // await OneSignal.shared.init(
                                  //     "51c9806a-db8c-4dbf-b544-26f6cc9b8fd0").then((value) async{
                                  //   var status = await OneSignal.shared
                                  //       .getPermissionSubscriptionState();
                                  //
                                  //   var playerId =
                                  //       status.subscriptionStatus.userId;
                                  //
                                  //   print('GNIDA --->');
                                  //   print(playerId);
                                  // });

                                  // Timer(Duration(seconds: 1), () async {
                                  //   var status = await OneSignal.shared
                                  //       .getPermissionSubscriptionState();
                                  //
                                  //   var playerId =
                                  //       status.subscriptionStatus.userId;
                                  //
                                  //   print('GNIDA --->');
                                  //   print(playerId);
                                  //
                                  //   var status2 = await OneSignal.shared
                                  //       .getPermissionSubscriptionState();
                                  //
                                  //   var playerId2 =
                                  //       status2.subscriptionStatus.userId;
                                  //
                                  //   print('GNIDA --->');
                                  //   print(playerId2);
                                  //
                                  //   var status3 = await OneSignal.shared
                                  //       .getPermissionSubscriptionState();
                                  //
                                  //   var playerId3 =
                                  //       status3.subscriptionStatus.userId;
                                  //
                                  //   print('GNIDA --->');
                                  //   print(playerId3);
                                  // });

                                  OneSignal.shared
                                      .sendTag("SpOfferYes", "SpOfferYes")
                                      .then((response) {
                                    print(
                                        "Successfully sent tags with response: $response");
                                  }).catchError((error) {
                                    print(
                                        "Encountered an error sending tags: $error");
                                  });
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(0.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
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
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
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
                                  Map userId = {'open': 'open'};
                                  logEvent('SpOfferYes', userId);

                                  // OneSignal.shared.setLogLevel(
                                  //     OSLogLevel.verbose, OSLogLevel.none);
                                  // await OneSignal.shared.init(
                                  //     "51c9806a-db8c-4dbf-b544-26f6cc9b8fd0").then((value) async{
                                  //   var status = await OneSignal.shared
                                  //       .getPermissionSubscriptionState();
                                  //
                                  //   var playerId =
                                  //       status.subscriptionStatus.userId;
                                  //
                                  //
                                  //   print(playerId);
                                  // });

                                  // Timer(Duration(seconds: 1), () async {
                                  //   var status = await OneSignal.shared
                                  //       .getPermissionSubscriptionState();
                                  //
                                  //   var playerId =
                                  //       status.subscriptionStatus.userId;
                                  //
                                  //   print('GNIDA --->');
                                  //   print(playerId);
                                  //
                                  //   var status2 = await OneSignal.shared
                                  //       .getPermissionSubscriptionState();
                                  //
                                  //   var playerId2 =
                                  //       status2.subscriptionStatus.userId;
                                  //
                                  //   print('GNIDA --->');
                                  //   print(playerId2);
                                  //
                                  //   var status3 = await OneSignal.shared
                                  //       .getPermissionSubscriptionState();
                                  //
                                  //   var playerId3 =
                                  //       status3.subscriptionStatus.userId;
                                  //
                                  //   print('GNIDA --->');
                                  //   print(playerId3);
                                  // });

                                  OneSignal.shared
                                      .sendTag("SpOfferYes", "SpOfferYes")
                                      .then((response) {
                                    print(
                                        "Successfully sent tags with response: $response");
                                  }).catchError((error) {
                                    print(
                                        "Encountered an error sending tags: $error");
                                  });
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
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
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
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
            )),
        Align(
            alignment: Alignment.topCenter,
            child: Container(
                // padding: EdgeInsets.only(top: 15),
                child: SvgPicture.asset(
              'assets/images/CheckCircle.svg',
              fit: BoxFit.contain,
            ))),
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
