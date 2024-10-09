class FeedbackModel {
  String name;
  String email;
  String feedback;
  DateTime createdAt;

  FeedbackModel(
      {required this.name,
      required this.email,
      required this.feedback,
      required this.createdAt});

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      name: json['name'],
      email: json['email'],
      feedback: json['feedback'],
      createdAt: json['createdAt'].toDate(),
    );
  }
}
