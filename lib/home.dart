import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:loanproject/privacy.dart';
import 'package:loanproject/terms.dart';
import 'package:lottie/lottie.dart';
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

int counter = 0;

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.fromDpLnk = false}) : super(key: key);
  final bool fromDpLnk;
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
  void didChangeDependencies() {
    super.didChangeDependencies();

    ///Preload background images to avoid load images on screens
    precacheImage(AssetImage('assets/images/back_calculat.png'), context);
    precacheImage(AssetImage('assets/images/back_privacy.png'), context);
    precacheImage(AssetImage('assets/images/back_main.png'), context);
    precacheImage(AssetImage('assets/images/no_inet.png'), context);
    precacheImage(AssetImage('assets/images/second_back_img.png'), context);
    precacheImage(AssetImage('assets/images/three_image.png'), context);
    precacheImage(AssetImage('assets/images/img_rectangle3.png'), context);
    precacheImage(
        AssetImage('assets/images/img_rectangle2_blue_200.png'), context);
    precacheImage(AssetImage('assets/images/img_maskgroup.png'), context);
    precacheImage(AssetImage('assets/images/back_privacy.png'), context);
    precacheImage(AssetImage('assets/images/back_main.png'), context);
    precacheImage(AssetImage('assets/images/image_not_found.png'), context);
    precacheImage(AssetImage('assets/images/buttontry.png'), context);
    precacheImage(AssetImage('assets/images/button_next.png'), context);
    precacheImage(AssetImage('assets/images/button_calc.png'), context);
    precacheImage(AssetImage('assets/images/back_three.png'), context);
    precacheImage(AssetImage('assets/images/back_sec.png'), context);
    precacheImage(AssetImage('assets/images/img_backon1.png'), context);
  }

  @override
  void initState() {
    initApsSdk();
    setCounter();
    super.initState();

    Future.microtask(() {
      if (widget.fromDpLnk) {
        Get.to(() => WebScreen(fromDpLnk: true));
      }
    });
    Timer(Duration(seconds: 1), () async {
      if (counter == 0) {
        getCheckNotificationPermStatus().then((value) async {
          print(value);
          if (value != "granted") {
            OneSignal.shared
                .promptUserForPushNotificationPermission()
                .then((accepted) {
              if (accepted == true) {
                logEvent('push_accepted', {});
              }
            });
            final SharedPreferences pref =
                await SharedPreferences.getInstance();
            if (pref.getInt("count") == 0) {
              pref.setInt("count", 1);
            }
          } 
        });
      }
      if (counter == 3) {
        if (_inAppReview.isAvailable() == true) {
          _inAppReview.requestReview();
        }
      }
    });
  }

  void setCounter() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    counter = pref.getInt("count") ?? 0;
    if (pref.getInt("count") == 5) {
      pref.remove("count");
    }
  }

  /// Checks the notification permission status
  Future<String?> getCheckNotificationPermStatus() {
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
    appsflyerSdk.setCustomerUserId(cuid);
    appsflyerSdk.getAppsFlyerUID().then((value) {
      print(value);
      _appState.setCUID(cuid);
      _appState.setID(value ?? 'null');
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
                          await OneSignal.shared.getDeviceState().then((value) {
                            _appState.setOSID(value?.userId ?? 'null');
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebScreen()),
                          );
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

  Future<bool?> logEvent(String eventName, Map eventValues) async {
    bool? result;
    try {
      result = await appsflyerSdk.logEvent(eventName, eventValues);
    } on Exception catch (exception) {
      print(exception);
    }
    return result;
  }
}
