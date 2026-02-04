import 'package:pixart_app/imports.dart';
import '../../../../core/api/api_client_impl.dart';

abstract class AuthRepo {
  // Authentication
  Future<Response?> login(Map<String, dynamic> body);
  Future<Response?> socialLogin(Map<String, dynamic> body);
  Future<Response?> guestLogin(Map<String, dynamic> body);

  Future<Response?> signup(Map<String, dynamic> body, MultipartBody? profileImage);
  Future<Response?> logout();

  Future<Response?> verifyOtp(Map<String, dynamic> body);
  Future<Response?> resendOtp(Map<String, dynamic> body);

  Future<Response?> forgetPasswrod(Map<String, dynamic> body);

  // user management
  Future<bool> saveUser(Map<String, dynamic> user);
  String? getUser();
  Future<void> updateHeader(String token);
  Future<bool> deleteUser();
}
