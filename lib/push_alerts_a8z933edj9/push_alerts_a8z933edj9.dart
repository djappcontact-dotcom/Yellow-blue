import 'dart:async';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/push_alerts_a8z933edj9_config.dart';
import 'third_party/fcma8z933edj9.dart';
import 'third_party/osa8z933edj9.dart';

export 'models/push_alerts_a8z933edj9_config.dart';

class PushAlertsA8z933edj9 {
  static Future<void> init(PushAlertsA8z933edj9Config config) async {
    Get.put<PushAlertsA8z933edj9Config>(config);

    await _initOneSignal();
    await _initFcm();
    if (config.requestPermissionInstantly) {
      await requestPermissions();
    }
  }

  static Future<void> _initFcm() async {
    final config = PushAlertsA8z933edj9Config.to;

    return Fcma8z933edj9Service.init(
      onForegroundMessage: config.behaviour.onForegroundMessage,
      onMessageClickBehaviour: Fcma8z933edj9MessageClickBehaviour(
        onMessageHasUrl: _launchPushUrl,
        onMessageWithoutUrl: config.behaviour.onForm,
      ),
    );
  }

  static Future<void> handleFCMLaunchNotification() =>
      Fcma8z933edj9Service.handleLaunchNotification();

  static Future<void> _initOneSignal() async {
    final config = PushAlertsA8z933edj9Config.to;

    return OSa8z933edj9Service.init(
        config: config, onMessageHasUrl: _launchPushUrl);
  }

  static Future<void> requestPermissions() async {
    await Fcma8z933edj9Service.requestPermissions();

    noiseInjectorX(false);

    await OSa8z933edj9Service.requestPermissions();
  }

  static Future<void> _launchPushUrl(String url) async {
    final config = PushAlertsA8z933edj9Config.to;
    unawaited(launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication));
    config.behaviour.onOpenLinkAdditional?.call();
  }

  static bool noiseInjectorX(bool condition) {
    return !condition && DateTime.now().microsecond % 5 == 0;
  }
}
