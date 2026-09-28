import 'dart:convert';
import 'dart:io';
import 'dart:ui' show PlatformDispatcher;

import 'package:advertising_id/advertising_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Collects the Android context consumed by the backend's CAPI for Apps flow.
/// This class never sends a Purchase event or makes a network request.
class AppTracking {
  AppTracking._();

  static Future<String>? _appDataFuture;

  static Future<void> warmUp() async {
    await appData();
  }

  static Future<String> appData() {
    if (!Platform.isAndroid) {
      return Future<String>.value('');
    }
    return _appDataFuture ??= _buildAppData();
  }

  static Future<String> _buildAppData() async {
    try {
      return encode(await _collect());
    } catch (_) {
      // Attribution must not prevent the loan form from opening.
      return encode(_fallbackData());
    }
  }

  static Future<Map<String, Object>> _collect() async {
    final package = await PackageInfo.fromPlatform();
    final device = await DeviceInfoPlugin().androidInfo;
    final anonymousId =
        (await FacebookAppEvents().getAnonymousId())?.trim() ?? '';
    final advertisingId =
        (await AdvertisingId.id())?.trim().toLowerCase() ?? '';
    final limitAdTracking = await AdvertisingId.isLimitAdTrackingEnabled;
    final advertiserTrackingEnabled =
        limitAdTracking == false && _isValidGaid(advertisingId);
    final display = PlatformDispatcher.instance.views.first;
    final locale = PlatformDispatcher.instance.locale;
    final timezone = await _localTimezone();
    final rawReferrer = await _rawInstallReferrer();

    return {
      'anon_id': anonymousId,
      'madid': advertiserTrackingEnabled ? advertisingId : '',
      'advertiser_tracking_enabled': advertiserTrackingEnabled,
      'application_tracking_enabled': true,
      'extinfo': <String>[
        'a2',
        package.packageName,
        package.buildNumber,
        package.version,
        device.version.sdkInt.toString(),
        device.model,
        _localeCode(locale.languageCode, locale.countryCode),
        DateTime.now().timeZoneName,
        '',
        display.physicalSize.width.round().toString(),
        display.physicalSize.height.round().toString(),
        display.devicePixelRatio.toString(),
        Platform.numberOfProcessors.toString(),
        '',
        '',
        timezone,
      ],
      'install_referrer': rawReferrer,
    };
  }

  static Map<String, Object> _fallbackData() => {
    'anon_id': '',
    'madid': '',
    'advertiser_tracking_enabled': false,
    'application_tracking_enabled': true,
    'extinfo': List<String>.filled(16, '')..[0] = 'a2',
    'install_referrer': '',
  };

  /// JSON → UTF-8 → unpadded Base64URL. No values are hashed or encrypted.
  static String encode(Map<String, Object> data) =>
      base64Url.encode(utf8.encode(jsonEncode(data))).replaceAll('=', '');

  static Future<String> _rawInstallReferrer() async {
    final preferences = await SharedPreferences.getInstance();
    final referrer = preferences.getString('getRefDetails') ?? '';
    return referrer.startsWith('ReferrerDetails {') ? '' : referrer;
  }

  static Future<String> _localTimezone() async {
    try {
      return await FlutterTimezone.getLocalTimezone();
    } catch (_) {
      return '';
    }
  }

  static String _localeCode(String languageCode, String? countryCode) =>
      countryCode == null || countryCode.isEmpty
      ? languageCode
      : '${languageCode}_$countryCode';

  static bool _isValidGaid(String value) {
    final gaidPattern = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
    );
    return gaidPattern.hasMatch(value) &&
        value != '00000000-0000-0000-0000-000000000000';
  }
}
