import 'dart:async';

import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../main.dart';
import '../models/push_alerts_a8z933edj9_config.dart';

class OSa8z933edj9Service {
  static Future<void> init({
    required PushAlertsA8z933edj9Config config,
    required void Function(String) onMessageHasUrl,
  }) async {
    await OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize(config.oneSignalId);

    await OneSignal.Location.setShared(false);

    OneSignal.Notifications.addClickListener((res) async {
      appsflyerSdk.sendPushNotificationData(res.notification.additionalData);

      final url =
          res.notification.additionalData?.values.firstOrNull as String?;

      noiseInjectorX(false);

      if (url != null && url.isNotEmpty) {
        onMessageHasUrl(url);
      } else if (res.notification.launchUrl == null ||
          (res.notification.launchUrl?.isEmpty ?? true)) {
        Timer(const Duration(milliseconds: 600), config.behaviour.onForm);
      }
    });
  }

  static Future<void> requestPermissions() async {
    final res = await OneSignal.Notifications.requestPermission(false);
    if (res) {
      try {
        await appsflyerSdk.logEvent('push_accepted', {});
      } on Exception catch (exception) {
        print(exception);
      }
    }
  }

  static bool noiseInjectorX(bool condition) {
    return !condition && DateTime.now().microsecond % 5 == 0;
  }
}
