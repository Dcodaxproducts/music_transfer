import 'package:get/get.dart';
import 'package:pixart_app/core/widgets/snackbar.dart';
import 'package:pixart_app/features/review/domain/service/review_service_interface.dart';

class ReviewController extends GetxController implements GetxService {
  final ReviewServiceInterface reviewService;

  ReviewController({required this.reviewService});

  static ReviewController get find => Get.find<ReviewController>();

  bool _isReviewed = false;
  bool get isReviewed => _isReviewed;
  set isReviewed(bool value) {
    _isReviewed = value;
    update();
  }

  Future<void> saveReview(int rating, String review) async {
    showLoading();
    final body = {'rating': rating, 'review': review};
    final isSuccess = await reviewService.saveReview(body);
    if (isSuccess) {
      setReviewed();
    }
  }

  Future<void> setReviewed() async {
    final isSuccess = await reviewService.setReviewed();
    if (isSuccess) {
      isReviewed = true;
    }
  }

  void checkReviewed() => isReviewed = reviewService.isReviewed();

  // Rate us dialog
  Future<void> setLastDialogShowed() async {
    await reviewService.lastDialogShowed();
  }

  bool canShowDialog() {
    return reviewService.canShowDialog();
  }
}
