// import 'package:matrix_ai/common/snackbar.dart';
// import 'package:matrix_ai/data/model/response/feedback.dart';
// import 'package:matrix_ai/data/repository/feedback_repo.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';

// class FeedbackController extends GetxController implements GetxService {
//   final FeedbackRepo feedbackRepo;
//   FeedbackController({required this.feedbackRepo});

//   // instance
//   static FeedbackController get find => Get.find<FeedbackController>();

//   final List<FeedbackModel> _feedbacks = [];
//   DocumentSnapshot? _lastDocument;
//   bool _hasMoreData = true;
//   bool _isLoading = true;

//   List<FeedbackModel> get feedbacks => _feedbacks;
//   bool get isLoading => _isLoading;

//   final int perPage = 15;

//   set loading(bool value) {
//     _isLoading = value;
//     update();
//   }

//   submitFeedback(String name, String email, String feedback) async {
//     showLoading();
//     await feedbackRepo.submitFeedback(name, email, feedback);
//     dismiss();
//     showToast('feedback_submitted'.tr, success: true);
//   }

//   Future<void> getFeedbacks({bool reload = false}) async {
//     if (reload) {
//       _feedbacks.clear();
//       _lastDocument = null; // Reset for reload
//       _hasMoreData = true; // Reset flag
//     }

//     if (!_hasMoreData) return; // Don't fetch if no more data

//     loading = true;
//     final snapshot = await feedbackRepo.getFeedbacks(
//       perPage,
//       startAfter: _lastDocument,
//     );

//     if (snapshot.docs.isNotEmpty) {
//       _lastDocument = snapshot.docs.last; // Save the last document
//       for (var feedback in snapshot.docs) {
//         _feedbacks.add(FeedbackModel.fromJson(feedback.data()));
//       }
//     } else {
//       _hasMoreData = false; // No more data available
//     }

//     loading = false;
//   }
// }
