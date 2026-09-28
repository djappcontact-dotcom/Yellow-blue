import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:loanproject/tracking/app_tracking.dart';

void main() {
  test('app_data is unpadded Base64URL JSON with extinfo as strings', () {
    final encoded = AppTracking.encode({
      'anon_id': 'meta-anonymous-id',
      'madid': '123e4567-e89b-12d3-a456-426614174000',
      'advertiser_tracking_enabled': true,
      'application_tracking_enabled': true,
      'extinfo': List<String>.filled(16, '')..[0] = 'a2',
      'install_referrer': 'utm_source=google-play&utm_medium=organic',
    });

    final padding = '=' * ((4 - encoded.length % 4) % 4);
    final decoded =
        jsonDecode(utf8.decode(base64Url.decode('$encoded$padding')))
            as Map<String, dynamic>;

    expect(encoded, isNot(contains('=')));
    expect(decoded['anon_id'], 'meta-anonymous-id');
    expect(decoded['madid'], '123e4567-e89b-12d3-a456-426614174000');
    expect(decoded['extinfo'], isA<List<dynamic>>());
    expect(decoded['extinfo'], hasLength(16));
    expect(decoded['extinfo'].every((value) => value is String), isTrue);
  });
}
