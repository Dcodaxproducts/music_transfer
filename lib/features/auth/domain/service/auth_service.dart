import 'package:device_info_plus/device_info_plus.dart';
import 'package:pixart_app/features/auth/data/model/signup_body.dart';
import 'package:pixart_app/features/auth/data/model/user_model.dart';

abstract class AuthService {
  Future<Map<String, dynamic>> getDeviceData(DeviceInfoPlugin deviceInfo);

  /* Credits Management */
  Future<bool> saveCredits(int credits);
  int? loadCredits();

  Future<UserModel?> signup(SignupBody signupBody);
  Future<UserModel?> login(String email, String password, String deviceId);
}
