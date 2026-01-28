class SocialLoginModel {
  final String uid;
  final String? name;
  final String email;
  final String medium;
  final String? profilePicture;

  SocialLoginModel({
    required this.uid,
    this.name,
    required this.email,
    required this.medium,
    this.profilePicture,
  });

  Map<String, dynamic> toJson() {
    return {
      'guest_uid': uid,
      'name': name,
      'email': email,
      'medium': medium,
      'profile_image': profilePicture,
    };
  }
}
