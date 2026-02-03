import '../../../../imports.dart';

class SignupBody {
  final String name;
  final String email;
  final String password;
  final XFile? profileImage;
  final String uid;
  final String? deviceId;

  SignupBody({
    required this.name,
    required this.email,
    required this.password,
    this.profileImage,
    required this.uid,
    this.deviceId,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'password': password, 'uid': uid, 'device_id': deviceId};
  }
}
