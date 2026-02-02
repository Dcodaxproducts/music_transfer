import 'package:pixart_app/features/auth/data/model/user_model.dart';
import 'package:pixart_app/features/auth/domain/service/auth_service.dart';
import 'package:pixart_app/features/history/presentation/controller/history_controller.dart';
import 'package:pixart_app/features/profile/presentation/controller/profile_controller.dart';
import 'package:pixart_app/imports.dart';
import '../../data/model/signup_body.dart';
import '../../data/model/social_login_model.dart';

class AuthController extends GetxController implements GetxService {
  final AuthService service;
  AuthController({required this.service});

  static AuthController get find => Get.find<AuthController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  bool get isLoggedIn => _user?.email != null;

  UserModel? _user;
  UserModel? get user => _user;

  int get credits => _user?.credits ?? 0;

  Future<void> initialize() async {
    _user = service.getUser();
    update();

    // If no user is logged in, perform guest login
    if (_user == null) {
      await guestLogin();
    } else {
      await ProfileController.find.updateProfile();
    }
  }

  Future<void> guestLogin() async {
    try {
      isLoading = true;
      UserModel? guestUser = await service.guestLogin();
      if (guestUser != null) {
        _user = guestUser;
      }
    } catch (e) {
      debugPrint('Unable to login as guest: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<(UserModel?, bool)> login(String email, String password) async {
    try {
      isLoading = true;
      (UserModel?, bool) response = await service.login(email, password);
      if (response.$1 != null) {
        _user = response.$1;
      }
      isLoading = false;
      return response;
    } catch (e) {
      showToast('Unable to login: $e');
      return (null, false);
    } finally {
      isLoading = false;
    }
  }

  Future<bool> signup(SignupBody signupBody) async {
    try {
      isLoading = true;
      return await service.signup(signupBody);
    } catch (e) {
      showToast('Unable to signup: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<bool> socialLogin(SocialLoginModel socialLoginModel) async {
    try {
      isLoading = true;
      UserModel? loggedInUser = await service.socialLogin(socialLoginModel);
      if (loggedInUser != null) {
        _user = loggedInUser;
        update();
      }
      return loggedInUser != null;
    } catch (e) {
      showToast('Unable to login with social account: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    try {
      isLoading = true;
      final UserModel? verifiedUser = await service.verifyOtp(email, otp);
      if (verifiedUser != null) {
        _user = verifiedUser;
        return true;
      }
      return false;
    } catch (e) {
      showToast('OTP verification failed: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<bool> forgetPassword(String email) async {
    try {
      isLoading = true;
      return await service.forgetPassword(email);
    } catch (e) {
      showToast('OTP verification failed: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<void> logout() async {
    try {
      showLoading();
      bool success = await service.logout();
      if (success) {
        _user = null;
        HistoryController.find.clearHistory();
        await guestLogin();
      }
    } catch (e) {
      showToast('Unable to logout: $e');
    } finally {
      dismiss();
    }
  }

  Future<bool> saveUser(UserModel user) async {
    _user = user;
    update();
    return await service.saveUser(user);
  }
}
