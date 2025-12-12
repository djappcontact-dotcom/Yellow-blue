import 'dart:developer';
import 'dart:io';

// import 'firebase_options.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:loanproject/firebase_options.dart';
import 'package:loanproject/home.dart';
import 'package:loanproject/push_alerts_a8z933edj9/push_alerts_a8z933edj9.dart';
import 'package:loanproject/size_config.dart';
import 'package:loanproject/state.dart';
import 'package:loanproject/tutorial/first.dart';
import 'package:loanproject/webview.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:play_install_referrer/play_install_referrer.dart';
import 'package:provider/provider.dart';
import 'var.dart' as variables;

import 'package:shared_preferences/shared_preferences.dart';
import 'splash.dart';

AppsflyerSdk appsflyerSdk = AppsflyerSdk({
  "afDevKey":
      Platform.isIOS ? 'XmphTEoVgARoCrhALJusC6' : 'XXzKfE9qPGH5XTrEysZc6W',
  "afAppId": '1570037577',
  "isDebug": true
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final SharedPreferences pref = await SharedPreferences.getInstance();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  if (pref.getInt("count") == null) {
    pref.setInt("count", 0);
  } else {
    var _count = pref.getInt("count");
    _count = _count ?? 0 + 1;
    pref.setInt("count", _count);
  }
  await remoteConfig.activate();
  log(await analytics.appInstanceId ?? "appInstanceId : none");

  try {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 60),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    await remoteConfig.fetchAndActivate();

    variables.needShowReview = await remoteConfig.getInt('needShowReview');
    log('\n -----------------\n needShowReview from remote config${await remoteConfig.getInt('needShowReview')}\n -----------------\n');
  } on PlatformException catch (exception) {
    // Fetch exception.
    log(exception.toString());
  } catch (exception) {
    log(exception.toString());
  }

  String? nowRef = pref.getString('getRefDetails') ?? '';
  if (nowRef != '') {
    variables.getRefDetails = nowRef;
  } else {
    try {
      ReferrerDetails referrerDetails =
          await PlayInstallReferrer.installReferrer;
      variables.getRefDetails = referrerDetails.toString();
      pref
          .setString('getRefDetails', referrerDetails.toString())
          .then((bool success) {
        return referrerDetails.toString();
      });
    } catch (e) {}
  }

  await afInit();
  PushAlertsA8z933edj9.init(
    PushAlertsA8z933edj9Config(
      oneSignalId: '51c9806a-db8c-4dbf-b544-26f6cc9b8fd0',
      requestPermissionInstantly: false,
      behaviour: PushAlertsA8z933edj9NavigationBehaviour(
        onForm: () => Get.to(WebScreen(fromDpLnk: true)),
      ),
    ),
  );
  // await osInitialize();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (c) => AppState())],
      child: MyApp(),
    ),
  );
}

afInit() async {
  try {
    appsflyerSdk.addPushNotificationDeepLinkPath(['af_deeplink']);
    appsflyerSdk.onDeepLinking((DeepLinkResult dp) {
      if (dp.deepLink?.deepLinkValue == 'open_it') {
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.off(() => HomePage(
                fromDpLnk: true,
              ));
        });
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

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
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
          '/first': (context) => FirstTutorial(),
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
