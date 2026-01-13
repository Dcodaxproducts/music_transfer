import '../../../../imports.dart';

class SignupBody {
  final String name;
  final String email;
  final String password;
  final String deviceId;
  final XFile? profileImage;

  SignupBody({
    required this.name,
    required this.email,
    required this.password,
    required this.deviceId,
    this.profileImage,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'password': password, 'device_id': deviceId};
  }
}
