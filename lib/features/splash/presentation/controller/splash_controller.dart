import 'package:package_info_plus/package_info_plus.dart';
import '../../../../imports.dart';
import '../../domain/service/splash_service.dart';

class SplashController extends GetxController implements GetxService {
  final SplashService service;
  SplashController({required this.service});

  static SplashController get find => Get.find<SplashController>();

  bool _isFirstTime = true;
  bool get isFirstTime => _isFirstTime;

  PackageInfo? _packageInfo;
  PackageInfo? get packageInfo => _packageInfo;

  String? _deviceId;
  String? get deviceId => _deviceId;

  Future<void> initialize() async {
    _isFirstTime = service.getFirstTime();
    await Future.wait([getPackageInfo(), getDeviceId()]);
    update();
  }

  Future<void> getPackageInfo() async {
    _packageInfo = await PackageInfo.fromPlatform();
    update();
  }

  Future<String> getDeviceId() async {
    Map<String, dynamic> deviceData = await service.getDeviceData();
    _deviceId = deviceData['uuid'];
    update();
    return _deviceId ?? 'unknown';
  }

  Future<void> saveFirstTime() async {
    _isFirstTime = false;
    update();
    await service.saveFirstTime();
  }
}
