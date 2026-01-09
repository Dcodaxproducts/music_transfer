import '../../../../imports.dart';
import '../../data/repository/auth_repo.dart';
import '../../data/repository/auth_repo_impl.dart';
import '../../presentation/controller/auth_controller.dart';
import '../service/auth_service.dart';
import '../service/auth_service_impl.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    Get.lazyPut<AuthRepo>(() => AuthRepoImpl(client: Get.find(), prefs: Get.find()));
    // service
    Get.lazyPut<AuthService>(() => AuthServiceImpl(repo: Get.find()));
    // controller
    Get.lazyPut<AuthController>(() => AuthController(service: Get.find()));

    
  }
}
