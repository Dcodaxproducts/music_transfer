class UserModel {
  final int id;
  final String uuid;
  final String? email;
  final String? name;
  final String? photoUrl;
  final String? token;

  UserModel({required this.id, required this.uuid, this.email, this.name, this.photoUrl, this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      uuid: json['uuid'],
      email: json['email'],
      name: json['name'],
      photoUrl: json['photo_url'],
      token: json['api_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'uuid': uuid, 'email': email, 'name': name, 'photo_url': photoUrl, 'api_token': token};
  }
}
