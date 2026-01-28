import 'package:pixart_app/features/auth/data/model/signup_body.dart';
import 'package:pixart_app/features/auth/data/model/user_model.dart';
import '../../data/model/social_login_model.dart';

abstract class AuthService {
  Future<(UserModel?, bool)> login(String email, String password);
  Future<UserModel?> socialLogin(SocialLoginModel socialLoginModel);
  Future<UserModel?> guestLogin();
  Future<bool> signup(SignupBody signupBody);
  Future<UserModel?> verifyOtp(String email, String otp);
  Future<bool> logout();
  Future<bool> forgetPassword(String email);

  // user management
  Future<bool> saveUser(UserModel user);
  UserModel? getUser();
}
