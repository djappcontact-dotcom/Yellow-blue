import 'dart:async';
import 'dart:math';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loanproject/main.dart';
import 'package:loanproject/state.dart';
import 'package:loanproject/tutorial/first.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';

bool obNavSkip = false;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final int delayedAmount = 500;

  // AppsflyerSdk appsflyerSdk = AppsflyerSdk({
  //   "afDevKey":
  //       Platform.isIOS ? 'XmphTEoVgARoCrhALJusC6' : 'XXzKfE9qPGH5XTrEysZc6W',
  //   "afAppId": '1570037577',
  //   "isDebug": true
  // });
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  String cuid = "";

  @override
  void initState() {
    super.initState();
    final _appState = Provider.of<AppState>(context, listen: false);
    getOSId();
    getFRBId();
    Timer(Duration(seconds: 3), () {
      if (mounted && !obNavSkip) {
        if (_appState.darkMode == false) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FirstTutorial();
          }));
        }
      }
    });
  }

  Future<void> getOSId() async {
    final _appState = Provider.of<AppState>(context, listen: false);
    _appState.setOSID(await OneSignal.User.getOnesignalId() ?? "null");
  }

  Future<void> getFRBId() async {
    final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

    final _appState = Provider.of<AppState>(context, listen: false);
    _appState.setFBUID(await await analytics.appInstanceId  ?? "null");
  }

  Future<bool?> logEvent(String eventName, Map eventValues) async {
    bool? result;
    try {
      result = await appsflyerSdk.logEvent(eventName, eventValues);
    } on Exception catch (exception) {
      print(exception);
    }
    print("Result logEvent: $result");
    return result;
  }

  // void initApsSdk() {
  //   final _appState = Provider.of<AppState>(context, listen: false);
  //   cuid = getRandomString(15);
  //   appsflyerSdk.initSdk(
  //       registerConversionDataCallback: true,
  //       registerOnAppOpenAttributionCallback: true,
  //       registerOnDeepLinkingCallback: true);
  //   appsflyerSdk.setCustomerUserId(cuid);
  //   appsflyerSdk.getAppsFlyerUID().then((value) {
  //     print(value);
  //     _appState.setCUID(cuid);
  //     _appState.setID(value);
  //   });
  // }

  @override
  void didChangeDependencies() {
    precacheImage(new AssetImage('assets/images/img_backon1.png'), context);
    precacheImage(new AssetImage('assets/images/back_sec.png'), context);
    precacheImage(new AssetImage('assets/images/back_three.png'), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash_back.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
