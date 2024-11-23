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
}
