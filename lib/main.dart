import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:loanproject/size_config.dart';
import 'package:loanproject/state.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'splash.dart';

bool _checkNotification = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


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

  // Future.wait([
  //   precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/svg/logo.svg'), null),
  //   precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/svg/1_white.svg'), null),
  //   precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/svg/2_white.svg'), null),
  //   precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/svg/3_white.svg'), null),
  //   precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/svg/1_black.svg'), null),
  //   precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/svg/2_black.svg'), null),
  //   precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/svg/3_black.svg'), null),
  //   precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/svg/next_white.svg'), null),
  //   precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/svg/next_black.svg'), null),
  //   precachePicture(ExactAssetPicture(SvgPicture.svgStringDecoder, 'assets/svg/home.svg'), null),
  // ]);
  final state = AppState();


  runApp(MultiProvider(providers: [ChangeNotifierProvider<AppState>.value(value: state)], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: LayoutBuilder(builder: (context, constraints) {
            return OrientationBuilder(builder: (context, orientation) {
              SizeConfig().init(constraints, orientation);


              return SplashScreen();
            });
          }),
          theme:
          Theme.of(context).copyWith(appBarTheme: Theme.of(context).appBarTheme.copyWith(brightness: Brightness.dark)),
        ));
  }
}
