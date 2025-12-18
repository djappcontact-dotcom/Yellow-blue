import 'src/fb_sdk_ids_vr93da5c_dependencies.dart';
import 'src/presentation/util/fb_sdk_ids_vr93da5c_util.dart';

abstract class FbSdkIdsvr93da5c {
  static Future<void> init() => FbSdkIdsvr93da5cDependencies.init();

  static Future<String?> get getFacebookAnonymousId =>
      FbSdkIdsvr93da5cUtil.to.getFacebookAnonymousId();

  static Future<String?> get getAdvertisingId =>
      FbSdkIdsvr93da5cUtil.to.getAdvertisingId();
}
