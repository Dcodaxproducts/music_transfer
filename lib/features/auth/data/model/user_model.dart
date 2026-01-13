class UserModel {
  final int id;
  final String deviceId;
  final String? email;
  final String? name;
  final String? photoUrl;

  UserModel({required this.id, required this.deviceId, this.email, this.name, this.photoUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      deviceId: json['device_id'],
      email: json['email'],
      name: json['name'],
      photoUrl: json['photo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'device_id': deviceId, 'email': email, 'name': name, 'photo_url': photoUrl};
  }
}
