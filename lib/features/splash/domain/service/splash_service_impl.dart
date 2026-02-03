import '../../../../imports.dart';
import '../../data/repository/splash_repo.dart';
import 'splash_service.dart';

class SplashServiceImpl implements SplashService {
  final SettingsRepo settingsRepo;
  SplashServiceImpl({required this.settingsRepo});

  @override
  Future<bool> saveFirstTime() {
    return settingsRepo.saveFirstTime();
  }

  @override
  bool getFirstTime() {
    return settingsRepo.getFirstTime();
  }

  /* Device Info */
  @override
  Future<Map<String, dynamic>> getDeviceData() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
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
}
