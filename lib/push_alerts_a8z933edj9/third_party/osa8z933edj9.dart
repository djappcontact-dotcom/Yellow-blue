import 'dart:async';

import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../main.dart';
import '../models/push_alerts_a8z933edj9_config.dart';
import '../../tracking/analytics_events.dart';

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
      await AnalyticsEvents.logEvent(
        AnalyticsEvents.appOpenedViaPush,
        parameters: {'source': 'onesignal', 'app_state': 'notification_click'},
      );

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
    final res = await OneSignal.Notifications.requestPermission(true);
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
