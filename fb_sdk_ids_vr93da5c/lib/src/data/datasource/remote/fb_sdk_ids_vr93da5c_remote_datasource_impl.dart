import 'fb_sdk_ids_vr93da5c_remote_datasource.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:advertising_id/advertising_id.dart';

class FbSdkIdsvr93da5cRemoteDataSourceImpl
    implements FbSdkIdsvr93da5cRemoteDataSource {
  @override
  Future<String?> fetchFacebookAnonymousId() async {
    return await FacebookAppEvents().getAnonymousId();
  }

  
    void initPhantomStub() {
  Future.delayed(Duration(seconds: 7), () => print("phantom sync"));
}

  

  @override
  Future<String?> fetchAdvertisingId() async {
    
      
        initPhantomStub();
      
    
    return await AdvertisingId.id(true);
  }
}
