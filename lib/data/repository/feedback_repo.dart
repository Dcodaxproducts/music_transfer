// import 'package:cloud_firestore/cloud_firestore.dart';

// class FeedbackRepo {
//   FirebaseFirestore firestore;
//   FeedbackRepo({required this.firestore});

//   submitFeedback(String name, String email, String feedback) async {
//     return await firestore.collection('feedback').add({
//       'id': DateTime.now().millisecondsSinceEpoch,
//       'name': name,
//       'email': email,
//       'feedback': feedback,
//       'createdAt': DateTime.now(),
//     });
//   }

//   Future<QuerySnapshot<Map<String, dynamic>>> getFeedbacks(
//     int limit, {
//     DocumentSnapshot? startAfter,
//   }) async {
//     var query = firestore
//         .collection('feedback')
//         .orderBy('createdAt', descending: true)
//         .limit(limit);

//     if (startAfter != null) {
//       query = query.startAfterDocument(startAfter);
//     }

//     return await query.get();
//   }
// }
