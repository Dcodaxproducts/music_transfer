class SocialLoginModel {
  final String? name;
  final String email;
  final String uniqueId;
  final String medium;
  final String? profilePicture;

  SocialLoginModel({
    this.name,
    required this.email,
    required this.uniqueId,
    required this.medium,
    this.profilePicture,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'unique_id': uniqueId,
      'medium': medium,
      'profile_picture': profilePicture,
    };
  }
}
