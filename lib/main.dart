import 'dart:developer';
import 'dart:io';

import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:loanproject/home.dart';
import 'package:loanproject/size_config.dart';
import 'package:loanproject/state.dart';
import 'package:loanproject/webview.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences pref = await SharedPreferences.getInstance();

  final state = AppState();

  if (pref.getInt("count") == null) {
    pref.setInt("count", 0);
  } else {
    var _count = pref.getInt("count");
    _count = _count ?? 0 + 1;
    pref.setInt("count", _count);
  }

  runApp(
    MultiProvider(
        providers: [ChangeNotifierProvider<AppState>.value(value: state)],
        child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppsflyerSdk appsflyerSdk = AppsflyerSdk({
    "afDevKey":
        Platform.isIOS ? 'XmphTEoVgARoCrhALJusC6' : 'XXzKfE9qPGH5XTrEysZc6W',
    "afAppId": '1570037577',
    "isDebug": true
  });
  @override
  Future<void> initState() async {
    super.initState();
  }

  init() async {
    await afInit();
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setAppId("51c9806a-db8c-4dbf-b544-26f6cc9b8fd0");
    await OneSignal.shared.setLaunchURLsInApp(true);

    OneSignal.shared.setNotificationOpenedHandler((res) async {
      await afInit();
      appsflyerSdk.sendPushNotificationData(res.notification.additionalData);
      await OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
      await OneSignal.shared.setAppId('51c9806a-db8c-4dbf-b544-26f6cc9b8fd0');
      await OneSignal.shared.setLaunchURLsInApp(true);
    });
  }

  afInit() async {
    try {
      appsflyerSdk.addPushNotificationDeepLinkPath(['af_deeplink']);
      appsflyerSdk.onDeepLinking((DeepLinkResult dp) {
        switch (dp.status) {
          case Status.FOUND:
            obNavSkip = true;
            print(dp.deepLink?.toString());
            print("deep link value: ${dp.deepLink?.deepLinkValue}");
            if (dp.deepLink?.deepLinkValue == 'open_it') {
              Future.delayed(const Duration(milliseconds: 500), () {
                Get.off(() => HomePage(
                      fromDpLnk: true,
                    ));
              });
            }
            break;
          case Status.NOT_FOUND:
            print("deep link not found");
            break;
          case Status.ERROR:
            print("deep link error: ${dp.error}");
            break;
          case Status.PARSE_ERROR:
            print("deep link status parsing error");
            break;
        }
      });

      await appsflyerSdk.initSdk(
          registerConversionDataCallback: true,
          registerOnAppOpenAttributionCallback: true,
          registerOnDeepLinkingCallback: true);
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
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

    return OverlaySupport(
      child: GetMaterialApp(
        navigatorKey: NavigationService.navigatorKey,
        routes: {
          '/web': (context) => WebScreen(),
          '/home': (context) => HomePage(),
        },
        debugShowCheckedModeBanner: false,
        home: LayoutBuilder(builder: (context, constraints) {
          return OrientationBuilder(builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);

            return SplashScreen();
          });
        }),
        theme: Theme.of(context).copyWith(
            appBarTheme: Theme.of(context)
                .appBarTheme
                .copyWith(systemOverlayStyle: SystemUiOverlayStyle.light)),
      ),
    );
  }
}
