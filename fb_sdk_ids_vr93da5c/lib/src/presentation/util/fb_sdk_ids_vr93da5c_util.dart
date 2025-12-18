import 'package:get/get.dart';

import '../../domain/repository/fb_sdk_ids_vr93da5c_repository.dart';

class FbSdkIdsvr93da5cUtil {
  static FbSdkIdsvr93da5cUtil get to => Get.find();
  final FbSdkIdsvr93da5cRepository repository;

  FbSdkIdsvr93da5cUtil({required this.repository});

  Future<String?> getFacebookAnonymousId() =>
      repository.fetchFacebookAnonymousId();

  Future<String?> getAdvertisingId() => repository.fetchAdvertisingId();
}
