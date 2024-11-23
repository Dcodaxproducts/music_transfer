import 'package:http/http.dart';

abstract class ReviewRepoInterface {
  // save review
  Future<Response?> saveReview(Map<String, dynamic> body);

  // set reviewed
  Future<bool> setReviewed();

  // is reviewed
  bool isReviewed();
}
