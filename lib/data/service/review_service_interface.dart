abstract class ReviewServiceInterface {
  Future<bool> saveReview(Map<String, dynamic> reviewData);
  Future<bool> setReviewed();
  bool isReviewed();
  Future<void> lastDialogShowed();
  bool canShowDialog();
}
