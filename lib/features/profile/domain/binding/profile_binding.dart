import '../../../../imports.dart';
import '../../data/repository/profile_repo.dart';
import '../../data/repository/profile_repo_impl.dart';
import '../../presentation/controller/profile_controller.dart';
import '../service/profile_service.dart';
import '../service/profile_service_impl.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    Get.lazyPut<ProfileRepo>(() => ProfileRepoImpl(client: Get.find(), prefs: Get.find()));
    // service
    Get.lazyPut<ProfileService>(() => ProfileServiceImpl(repo: Get.find()));
    // controller
    Get.lazyPut<ProfileController>(() => ProfileController(service: Get.find()));
  }
}
