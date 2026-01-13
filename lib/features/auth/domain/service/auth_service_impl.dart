import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:pixart_app/core/api/api_client_impl.dart';
import '../../../../imports.dart';
import '../../data/model/signup_body.dart';
import '../../data/model/user_model.dart';
import '../../data/repository/auth_repo.dart';
import 'auth_service.dart';

class AuthServiceImpl implements AuthService {
  final AuthRepo repo;
  AuthServiceImpl({required this.repo});

  /* Device Info */
  @override
  Future<Map<String, dynamic>> getDeviceData(DeviceInfoPlugin deviceInfo) async {
    Map<String, dynamic> deviceData = {};
    if (Platform.isAndroid) {
      deviceData = _getAndroidProperties(await deviceInfo.androidInfo);
    } else if (Platform.isIOS) {
      deviceData = _getiOSProperties(await deviceInfo.iosInfo);
    }
    return deviceData;
  }

  Map<String, dynamic> _getiOSProperties(IosDeviceInfo iosInfo) {
    return {'model_name': iosInfo.modelName, 'uuid': iosInfo.identifierForVendor ?? 'unknown'};
  }

  Map<String, dynamic> _getAndroidProperties(AndroidDeviceInfo androidInfo) {
    return {'model_name': androidInfo.model, 'uuid': androidInfo.id};
  }

  /* Credits Management */
  @override
  Future<bool> saveCredits(int credits) {
    return repo.saveCredits(credits);
  }

  @override
  int? loadCredits() => repo.loadCredits();

  @override
  Future<UserModel?> signup(SignupBody signupBody) async {
    MultipartBody? profileImage;
    if (signupBody.profileImage != null) {
      profileImage = MultipartBody('profile_image', signupBody.profileImage!);
    }
    final Response? response = await repo.signup(signupBody.toJson(), profileImage);
    if (response != null && response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    }
    return null;
  }

  Future<UserModel?> login(String email, String password, String deviceId) async {
    final Map<String, dynamic> body = {'email': email, 'password': password, 'device_id': deviceId};
    final Response? response = await repo.login(body);
    if (response != null && response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    }
    return null;
  }
}
