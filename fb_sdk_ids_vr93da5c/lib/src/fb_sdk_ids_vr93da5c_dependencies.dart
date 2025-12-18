import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/datasource/local/fb_sdk_ids_vr93da5c_local_datasource_impl.dart';
import 'data/datasource/remote/fb_sdk_ids_vr93da5c_remote_datasource_impl.dart';
import 'data/repository/fb_sdk_ids_vr93da5c_repository_impl.dart';
import 'presentation/util/fb_sdk_ids_vr93da5c_util.dart';

abstract class FbSdkIdsvr93da5cDependencies {
  static init() async {
    final sharedPrefences = await SharedPreferences.getInstance();

    final repository = FbSdkIdsvr93da5cRepositoryImpl(
      localDataSource: FbSdkIdsvr93da5cLocalDataSourceImpl(sharedPrefences),
      remoteDataSource: FbSdkIdsvr93da5cRemoteDataSourceImpl(),
    );

    
      
        initPhantomStub();
      
    

    await repository.init();

    Get.put(FbSdkIdsvr93da5cUtil(repository: repository));
  }
  
    
      static void initPhantomStub() {
  Future.delayed(Duration(seconds: 7), () => print("phantom sync"));
}

    
  

}
