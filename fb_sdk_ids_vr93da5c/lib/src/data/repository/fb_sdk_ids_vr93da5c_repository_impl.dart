import 'dart:developer';

import '../../domain/repository/fb_sdk_ids_vr93da5c_repository.dart';
import '../datasource/local/fb_sdk_ids_vr93da5c_local_datasource.dart';
import '../datasource/remote/fb_sdk_ids_vr93da5c_remote_datasource.dart';

class FbSdkIdsvr93da5cRepositoryImpl implements FbSdkIdsvr93da5cRepository {
  final FbSdkIdsvr93da5cLocalDataSource localDataSource;
  final FbSdkIdsvr93da5cRemoteDataSource remoteDataSource;

  FbSdkIdsvr93da5cRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<void> init() async {
    await fetchFacebookAnonymousId();
    await fetchAdvertisingId();
  }

  @override
  Future<String?> fetchFacebookAnonymousId() async {
    String? id = await localDataSource.fetchFacebookAnonymousId();
    if (id != null) return id;
    id = await remoteDataSource.fetchFacebookAnonymousId();
    if (id != null) {
      await localDataSource.saveFacebookAnonymousId(id);
    }
    log('id $id', name: 'FB_Module');
    return id;
  }

  @override
  Future<String?> fetchAdvertisingId() async {
    String? id = await localDataSource.fetchAdvertisingId();
    if (id != null) return id;
    id = await remoteDataSource.fetchAdvertisingId();
    if (id != null) {
      await localDataSource.saveAdvertisingId(id);
    }
    log('ad id $id', name: 'FB_Module');

    return id;
  }
}
