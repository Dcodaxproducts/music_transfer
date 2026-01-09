import 'package:device_info_plus/device_info_plus.dart';
import '../../../../imports.dart';
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
}
