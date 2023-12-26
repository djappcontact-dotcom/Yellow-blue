import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:loanproject/home.dart';
import 'package:loanproject/size_config.dart';
import 'package:loanproject/state.dart';
import 'package:loanproject/webview.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'splash.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences pref = await SharedPreferences.getInstance();
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(
        AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController =
          AndroidServiceWorkerController.instance();

      await serviceWorkerController
          .setServiceWorkerClient(AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          print(request);
          return null;
        },
      ));
    }
  }
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

class MyApp extends StatelessWidget {
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
