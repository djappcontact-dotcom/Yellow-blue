import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsEvents {
  static const notificationForeground = 'notification_foreground_yb';
  static const pushPermissionPrompt = 'push_permission_prompt_yb';
  static const pushPermissionGranted = 'push_permission_granted_yb';
  static const pushPermissionDenied = 'push_permission_denied_yb';
  static const appOpenedViaPush = 'app_opened_via_push_yb';
  static const formWebViewOpened = 'form_webview_opened_yb';
  static const formWebViewLoaded = 'form_webview_loaded_yb';
  static const reviewPromptShown = 'review_prompt_shown_yb';
  static const reviewCommentSubmitted = 'review_comment_submitted_yb';

  static Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) => FirebaseAnalytics.instance.logEvent(name: name, parameters: parameters);

  static Future<void> logScreenView(String screenName) =>
      FirebaseAnalytics.instance.logScreenView(screenName: screenName);
}
