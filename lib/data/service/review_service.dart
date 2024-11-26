import 'dart:convert';
import 'package:matrix_ai/data/repository/review_repo_interface.dart';
import 'review_service_interface.dart';

class ReviewService implements ReviewServiceInterface {
  final ReviewRepoInterface reviewRepo;
  ReviewService({required this.reviewRepo});

  @override
  Future<bool> saveReview(Map<String, dynamic> reviewData) async {
    final response = await reviewRepo.saveReview(reviewData);
    if (response != null) {
      final data = jsonDecode(response.body);
      return data['status'] == 1;
    }
    return false;
  }

  @override
  Future<bool> setReviewed() async {
    return await reviewRepo.setReviewed();
  }

  @override
  bool isReviewed() {
    return reviewRepo.isReviewed();
  }

  @override
  Future<void> lastDialogShowed() async {
    await reviewRepo.setLastDialogShowed();
  }

  @override
  bool canShowDialog() {
    final lastDialogShowed = reviewRepo.getLastDialogShowed();
    if (lastDialogShowed != null) {
      final last = DateTime.parse(lastDialogShowed);
      final now = DateTime.now();
      final difference = now.difference(last).inDays;
      if (difference >= 2) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }
}
