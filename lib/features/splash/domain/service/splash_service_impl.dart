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
}
