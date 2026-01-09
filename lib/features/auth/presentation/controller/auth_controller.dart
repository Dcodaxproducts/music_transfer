import 'package:device_info_plus/device_info_plus.dart';
import 'package:pixart_app/features/auth/domain/service/auth_service.dart';
import 'package:pixart_app/imports.dart';

class AuthController extends GetxController implements GetxService {
  final AuthService service;
  AuthController({required this.service});

  static AuthController get find => Get.find<AuthController>();

  String? _userId;
  String? get userId => _userId;

  int _credits = 0;
  int get credits => _credits;

  Future<void> getUserId() async {
    final deviceInfo = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = await service.getDeviceData(deviceInfo);
    _userId = deviceData['uuid'] ?? 'unknown';
  }

  void loadCredits() {
    int? savedCredits = service.loadCredits();
    _credits = savedCredits ?? 0;
    update();
  }

  Future<void> updateCredits(int value) async {
    // deduct credits used from available credits
    int updatedCredits = _credits - value;
    bool success = await service.saveCredits(updatedCredits);
    if (success) {
      _credits = updatedCredits;
      update();
    }
  }
}
