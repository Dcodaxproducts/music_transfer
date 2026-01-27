import 'package:pixart_app/features/auth/data/model/signup_body.dart';
import 'package:pixart_app/features/auth/data/model/user_model.dart';
import '../../data/model/social_login_model.dart';

abstract class AuthService {
  /* Credits Management */
  Future<bool> saveCredits(int credits);
  int? loadCredits();

  Future<UserModel?> login(String email, String password);
  Future<UserModel?> socialLogin(SocialLoginModel socialLoginModel);
  Future<UserModel?> guestLogin(String uuid);
  Future<UserModel?> signup(SignupBody signupBody);
  Future<bool> saveToken(String token);
  String? getToken();
}
