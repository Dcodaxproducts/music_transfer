class UserModel {
  final int id;
  final String uid;
  final String? name;
  final String? email;
  final String? photoUrl;
  final String? token;

  UserModel({required this.id, required this.uid, this.name, this.email, this.photoUrl, this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      photoUrl: json['profile_image'],
      token: json['api_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "uid": uid,
      "email": email,
      "name": name,
      "profile_image": photoUrl,
      "api_token": token,
    };
  }

  @override
  String toString() {
    return 'UserModel{"id": $id, "uid": "$uid", "name": "$name", "email": "$email", "photoUrl": "$photoUrl", "token": "$token"}';
  }
}
