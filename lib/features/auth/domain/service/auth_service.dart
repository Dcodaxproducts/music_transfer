import 'package:device_info_plus/device_info_plus.dart';

abstract class AuthService {
  Future<Map<String, dynamic>> getDeviceData(DeviceInfoPlugin deviceInfo);

  /* Credits Management */
  Future<bool> saveCredits(int credits);
  int? loadCredits();
}
