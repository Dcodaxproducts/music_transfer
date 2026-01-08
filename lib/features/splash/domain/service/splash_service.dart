import 'package:device_info_plus/device_info_plus.dart';

abstract class SplashService {
  Future<bool> saveFirstTime();
  bool getFirstTime();
  Future<Map<String, dynamic>> getDeviceData(DeviceInfoPlugin deviceInfo);
}
