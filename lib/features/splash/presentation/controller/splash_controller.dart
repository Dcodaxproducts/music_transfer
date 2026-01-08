import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../imports.dart';
import '../../domain/service/splash_service.dart';

class SplashController extends GetxController implements GetxService {
  final SplashService service;
  SplashController({required this.service});

  static SplashController get find => Get.find<SplashController>();

  Future<void> saveFirstTime() async {
    _isFirstTime = false;
    update();
    await service.saveFirstTime();
  }

  bool _isFirstTime = false;
  bool get isFirstTime => _isFirstTime;

  PackageInfo? _packageInfo;
  PackageInfo? get packageInfo => _packageInfo;

  String? _userId;
  String? get userId => _userId;

  Future<void> getPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
    update();
  }

  Future<void> getUserId() async {
    final deviceInfo = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = await service.getDeviceData(deviceInfo);
    _userId = deviceData['uuid'] ?? 'unknown';
  }
}
