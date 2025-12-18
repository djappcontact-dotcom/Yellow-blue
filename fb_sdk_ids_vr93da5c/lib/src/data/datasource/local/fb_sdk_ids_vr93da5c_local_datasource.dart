abstract class FbSdkIdsvr93da5cLocalDataSource {
  Future<String?> fetchFacebookAnonymousId();
  Future<String?> fetchAdvertisingId();
  Future<void> saveFacebookAnonymousId(String id);
  Future<void> saveAdvertisingId(String id);
} 