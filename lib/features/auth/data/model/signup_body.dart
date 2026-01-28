import '../../../../imports.dart';

class SignupBody {
  final String name;
  final String email;
  final String password;
  final XFile? profileImage;
  final String uid;

  SignupBody({
    required this.name,
    required this.email,
    required this.password,
    this.profileImage,
    required this.uid,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'password': password, 'uid': uid};
  }
}
