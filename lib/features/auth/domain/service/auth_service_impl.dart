import 'dart:convert';
import 'package:pixart_app/core/api/api_client_impl.dart';
import '../../../../imports.dart';
import '../../data/model/signup_body.dart';
import '../../data/model/social_login_model.dart';
import '../../data/model/user_model.dart';
import '../../data/repository/auth_repo.dart';
import 'auth_service.dart';

class AuthServiceImpl implements AuthService {
  final AuthRepo repo;
  AuthServiceImpl({required this.repo});

  /* Credits Management */
  @override
  Future<bool> saveCredits(int credits) {
    return repo.saveCredits(credits);
  }

  @override
  int? loadCredits() => repo.loadCredits();

  /* Auth Methods */
  @override
  Future<UserModel?> signup(SignupBody signupBody) async {
    MultipartBody? profileImage;
    if (signupBody.profileImage != null) {
      profileImage = MultipartBody('profile_image', signupBody.profileImage!);
    }
    final Response? response = await repo.signup(signupBody.toJson(), profileImage);
    if (response != null && response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    }
    return null;
  }

  @override
  Future<UserModel?> login(String email, String password) async {
    final Map<String, dynamic> body = {'email': email, 'password': password};
    final Response? response = await repo.login(body);
    if (response != null && response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    }
    return null;
  }

  @override
  Future<UserModel?> socialLogin(SocialLoginModel socialLoginModel) async {
    final Map<String, dynamic> body = socialLoginModel.toJson();
    final Response? response = await repo.socialLogin(body);
    if (response != null && response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    }
    return null;
  }

  @override
  Future<UserModel?> guestLogin(String uuid) async {
    final Map<String, dynamic> body = {'uuid': uuid};
    final Response? response = await repo.guestLogin(body);
    if (response != null && response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    }
    return null;
  }

  @override
  Future<bool> saveToken(String token) => repo.saveToken(token);

  @override
  String? getToken() => repo.getToken();
}
