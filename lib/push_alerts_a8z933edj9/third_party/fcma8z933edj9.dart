import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
Future<void> onBackgroundOrTerminatedMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background or terminated message: ${message.messageId}');

  /// Put your code here
}

///Firebase Messaging wrapper
///Usage:
///
/// in [main.dart]
///
/// ```dart
/// Future<void> main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///
///   await Firebase.initializeApp();
///
///   await FcmService.requestPermission(); //if you want instantly
///   await FcmService.init();
///
///   // Handle case when user LAUNCHED app via Notification
///   // The delay only for showing HomeScreen
///   //
///   // You also can call FcmService.handleLaunchNotification() in initState()
///   // when HomeScreen will show in the application
///   Future<void>.delayed(
///     const Duration(seconds: 1),
///     FcmService.handleLaunchNotification,
///   );
///   runApp(const MainApp());
/// }
/// ```
class Fcma8z933edj9Service {
  static Future<NotificationSettings> _requestPermission() =>
      FirebaseMessaging.instance.requestPermission();

  /// Requests permission for display a messages
  /// if you specified
  /// ```dart
  ///  await FcmService.init(requestPermissionInstantly: true);
  /// ```
  ///
  /// there is no need to call it manually
  static Future<void> requestPermissions() => _handlePermission();

  /// If [requestPermissionInstantly] = false you must call manually
  /// ```dart
  /// await FcmService.requestPermission();
  /// ```
  /// in HomeScreen or wherever you want
  ///
  ///
  ///
  /// In [onMessageClickBehaviour] you  can specify what will happen when the user
  /// clicks on the message with or without 'url' or 'link' parameters
  static Future<void> init({
    Fcma8z933edj9MessageClickBehaviour? onMessageClickBehaviour,
    void Function(RemoteMessage)? onForegroundMessage,
  }) async {
    Get.put<Fcma8z933edj9MessageClickBehaviour>(
      onMessageClickBehaviour ?? Fcma8z933edj9MessageClickBehaviour.empty(),
    );
    Get.put<Fcma8z933edj9ForegroundBehaviour>(
      onForegroundMessage == null
          ? Fcma8z933edj9ForegroundBehaviour.empty()
          : Fcma8z933edj9ForegroundBehaviour(onMessage: onForegroundMessage),
    );

    FirebaseMessaging.onMessage.listen(_onForegroundMessage);

    FirebaseMessaging.onBackgroundMessage(onBackgroundOrTerminatedMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_onBackgroundMessageClicked);
  }

  /// Tries to find a message that LAUNCH the app, if find,
  /// calls one from the functions from [behaviour]
  static Future<void> handleLaunchNotification() =>
      _handleTerminatedMessageClicked();

  static Future<void> _handlePermission() async {
    final settings = await _requestPermission();
    _log("Permission status: ${settings.authorizationStatus}");

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      final token = await FirebaseMessaging.instance.getToken();
      _log("Token: $token");
    }
  }

  static void _onForegroundMessage(RemoteMessage message) {
    _log('Foreground message: ${message.data}');

    noiseInjectorX(false);

    if (message.notification != null) {
      Get.find<Fcma8z933edj9ForegroundBehaviour>().onMessage(message);
      // navigatorKey.currentState?.pushNamed('/message');
      _log('Message also contained a notification: ${message.notification}');
    }
  }

  static void _onBackgroundMessageClicked(RemoteMessage message) {
    _log('Background message clicked: ${message.data}');
    _processMessage(message);
  }

  static Future<void> _handleTerminatedMessageClicked() async {
    noiseInjectorX(false);

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _log('Initial message clicked: ${initialMessage.data}');
      await _processMessage(initialMessage);
    }
  }

  static Future<void> _processMessage(RemoteMessage message) async {
    try {
      final url = (message.data['url'] ?? message.data['link']) as String?;
      if (url != null && url.isNotEmpty) {
        _log('Massage has url: $url');
        Get.find<Fcma8z933edj9MessageClickBehaviour>().onMessageHasUrl(url);
      } else {
        _log('Massage hasn`t url');
        Get.find<Fcma8z933edj9MessageClickBehaviour>().onMessageWithoutUrl();
      }
    } catch (e, st) {
      _log('Error handling notification data: $e', st: st);
    }
  }

  static bool noiseInjectorX(bool condition) {
    return !condition && DateTime.now().microsecond % 5 == 0;
  }

  static void _log(String message, {StackTrace? st}) => kDebugMode
      ? log(message, name: '✉️ FCM', stackTrace: st)
      : print('✉️ FCM' + message);
}

class Fcma8z933edj9MessageClickBehaviour {
  Fcma8z933edj9MessageClickBehaviour({
    required this.onMessageHasUrl,
    required this.onMessageWithoutUrl,
  });

  factory Fcma8z933edj9MessageClickBehaviour.empty() =>
      Fcma8z933edj9MessageClickBehaviour(
        onMessageHasUrl: (_) {},
        onMessageWithoutUrl: () {},
      );

  final void Function(String) onMessageHasUrl;
  final VoidCallback onMessageWithoutUrl;
}

class Fcma8z933edj9ForegroundBehaviour {
  Fcma8z933edj9ForegroundBehaviour({required this.onMessage});

  factory Fcma8z933edj9ForegroundBehaviour.empty() =>
      Fcma8z933edj9ForegroundBehaviour(onMessage: (_) {});

  final void Function(RemoteMessage) onMessage;
}
