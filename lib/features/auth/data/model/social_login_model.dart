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
}
