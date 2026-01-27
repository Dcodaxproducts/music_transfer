import '../../../../imports.dart';

class SignupBody {
  final String name;
  final String email;
  final String password;
  final XFile? profileImage;

  SignupBody({required this.name, required this.email, required this.password, this.profileImage});

  Map<String, dynamic> toJson() {
    return {'name': name, 'email': email, 'password': password};
  }
}
