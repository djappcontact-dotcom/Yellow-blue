import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loanproject/state.dart';
import 'package:loanproject/tutorial/first.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final int delayedAmount = 500;

  AppsflyerSdk appsflyerSdk = AppsflyerSdk({
    "afDevKey":
        Platform.isIOS ? 'XmphTEoVgARoCrhALJusC6' : 'XXzKfE9qPGH5XTrEysZc6W',
    "afAppId": '1570037577',
    "isDebug": true
  });
  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  String cuid = "";

  @override
  void initState() {
    super.initState();
    final _appState = Provider.of<AppState>(context, listen: false);


      OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

      OneSignal.shared.setAppId("51c9806a-db8c-4dbf-b544-26f6cc9b8fd0");

      _appState.setOSID("70621a8c-7e46-46b9-88fd-1411a45982a3");

      OneSignal.shared.setNotificationOpenedHandler((notification) {
        _appState.setDarkMode(true);
        Map userId = {'CUID': _appState.cuid};
        logEvent('GetLoan', userId);
        Navigator.pushReplacementNamed(context, '/home');
        Timer(Duration(milliseconds: 10),
            () async => await Navigator.pushReplacementNamed(context, '/web'));
      });

      Timer(Duration(seconds: 3), () {
        if (mounted) {
          if (_appState.darkMode == false) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return FirstTutorial();
            }));
          }
        }
      });
  }

  Future<bool> logEvent(String eventName, Map eventValues) async {
    bool result;
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
