import 'package:get/get.dart';
import '../../data/repository/review_repo.dart';
import '../../data/repository/review_repo_interface.dart';
import '../../presentation/controller/review_controller.dart';
import '../service/review_service.dart';
import '../service/review_service_interface.dart';

class ReviewBinding extends Bindings {
  @override
  void dependencies() {
    // repo
    ReviewRepoInterface reviewRepoInterface = ReviewRepo(apiClient: Get.find(), prefs: Get.find());
    Get.lazyPut(() => reviewRepoInterface, fenix: true);

    // service
    ReviewServiceInterface reviewServiceInterface = ReviewService(reviewRepo: Get.find());
    Get.lazyPut(() => reviewServiceInterface, fenix: true);

    // controller
    Get.lazyPut(() => ReviewController(reviewService: Get.find()));
  }
}
