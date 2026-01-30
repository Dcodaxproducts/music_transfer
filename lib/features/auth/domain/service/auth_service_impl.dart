import 'dart:convert';
import 'package:pixart_app/core/api/api_client_impl.dart';
import 'package:pixart_app/features/paywall/presentation/controller/subscription_controller.dart';
import '../../../../imports.dart';
import '../../data/model/signup_body.dart';
import '../../data/model/social_login_model.dart';
import '../../data/model/user_model.dart';
import '../../data/repository/auth_repo.dart';
import 'auth_service.dart';

class AuthServiceImpl implements AuthService {
  final AuthRepo repo;
  AuthServiceImpl({required this.repo});

  /* Auth Methods */
  @override
  Future<bool> signup(SignupBody signupBody) async {
    MultipartBody? profileImage;
    if (signupBody.profileImage != null) {
      profileImage = MultipartBody('profile_image', signupBody.profileImage!);
    }
    final Response? response = await repo.signup(signupBody.toJson(), profileImage);
    if (response != null && response.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Future<(UserModel?, bool)> login(String email, String password) async {
    final Map<String, dynamic> body = {'email': email, 'password': password};
    final Response? response = await repo.login(body);

    if (response != null && response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final bool isVerified = data['is_verified'];
      final UserModel user = UserModel.fromJson(data['data']);
      await saveUser(user);
      return (user, isVerified);
    }
    return (null, false);
  }

  @override
  Future<UserModel?> socialLogin(SocialLoginModel socialLoginModel) async {
    final Map<String, dynamic> body = socialLoginModel.toJson();
    final Response? response = await repo.socialLogin(body);
    if (response != null && response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body)['data'];
      final UserModel user = UserModel.fromJson(data);
      await saveUser(user);
      return user;
    }
    return null;
  }

  @override
  Future<UserModel?> guestLogin() async {
    final Map<String, dynamic> body = {'uid': Uuid().v4()};
    final Response? response = await repo.guestLogin(body);
    if (response != null && response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body)['data'];
      final UserModel user = UserModel.fromJson(data);
      await saveUser(user);
      return user;
    }
    return null;
  }

  @override
  Future<UserModel?> verifyOtp(String email, String otp) async {
    final Map<String, dynamic> body = {'email': email, 'otp': otp};
    final Response? response = await repo.verifyOtp(body);
    if (response != null && response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body)['data'];
      final UserModel user = UserModel.fromJson(data);
      await saveUser(user);
      return user;
    }
    return null;
  }

  @override
  Future<bool> logout() async {
    await repo.logout();
    await Future.wait([repo.deleteUser(), Purchases.logOut()]);
    return true;
  }

  @override
  Future<bool> forgetPassword(String email) async {
    final Map<String, dynamic> body = {'email': email};
    final Response? response = await repo.forgetPasswrod(body);
    if (response != null && response.statusCode == 200) {
      return true;
    }
    return false;
  }

  // user management
  @override
  Future<bool> saveUser(UserModel user) async {
    if (user.token != null) {
      await repo.updateHeader(user.token!);
    }
    await SubscriptionController.find.login(user);
    return await repo.saveUser(user.toJson());
  }

  @override
  UserModel? getUser() {
    final String? userString = repo.getUser();
    if (userString != null) {
      final Map<String, dynamic> userMap = jsonDecode(userString);
      return UserModel.fromJson(userMap);
    }
    return null;
  }
}
