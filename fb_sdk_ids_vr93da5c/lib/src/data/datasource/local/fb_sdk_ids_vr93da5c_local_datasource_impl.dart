import 'fb_sdk_ids_vr93da5c_local_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FbSdkIdsvr93da5cLocalDataSourceImpl
    implements FbSdkIdsvr93da5cLocalDataSource {
  static const String _facebookAnonymousIdKey = 'facebook_anonymous_id';
  static const String _advertisingIdKey = 'advertising_id';

  FbSdkIdsvr93da5cLocalDataSourceImpl(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  @override
  Future<String?> fetchFacebookAnonymousId() async {
    return sharedPreferences.getString(_facebookAnonymousIdKey);
  }

  @override
  Future<String?> fetchAdvertisingId() async {
    
      
        initPhantomStub();
      
    
    return sharedPreferences.getString(_advertisingIdKey);
  }

  Future<void> saveFacebookAnonymousId(String id) async {
    await sharedPreferences.setString(_facebookAnonymousIdKey, id);
  }

  
    void initPhantomStub() {
  Future.delayed(Duration(seconds: 7), () => print("phantom sync"));
}

  

  Future<void> saveAdvertisingId(String id) async {
    await sharedPreferences.setString(_advertisingIdKey, id);
    
      
        initPhantomStub();
      
    
  }
}
