import 'dart:ui';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

class PushAlertsA8z933edj9Config {
  static PushAlertsA8z933edj9Config get to => Get.find();

  final String oneSignalId;
  final bool requestPermissionInstantly;
  final PushAlertsA8z933edj9NavigationBehaviour behaviour;

  const PushAlertsA8z933edj9Config({
    required this.oneSignalId,
    required this.requestPermissionInstantly,
    required this.behaviour,
  });
}

class PushAlertsA8z933edj9NavigationBehaviour {
  final VoidCallback onForm;
  final VoidCallback? onOpenLinkAdditional;
  final void Function(dynamic)? onForegroundMessage;

  const PushAlertsA8z933edj9NavigationBehaviour({
    required this.onForm,
    this.onOpenLinkAdditional,
    this.onForegroundMessage,
  });
}
