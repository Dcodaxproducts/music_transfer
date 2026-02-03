abstract class SplashService {
  Future<bool> saveFirstTime();
  bool getFirstTime();

  Future<Map<String, dynamic>> getDeviceData();
}
