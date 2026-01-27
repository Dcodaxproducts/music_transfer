import 'package:pixart_app/features/auth/data/model/user_model.dart';
import 'package:pixart_app/features/auth/domain/service/auth_service.dart';
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

  bool get isLoggedIn => service.getToken() != null;

  UserModel? _user;
  UserModel? get user => _user;

  String? _deviceId;
  String? get deviceId => _deviceId;

  int _credits = 0;
  int get credits => _credits;

  Future<void> initialize() async {
    if (!isLoggedIn) {
      await guestLogin();
    }
  }

  Future<void> guestLogin() async {
    try {
      isLoading = true;
      final Uuid uuid = Uuid();
      String generatedUuid = uuid.v4();
      UserModel? guestUser = await service.guestLogin(generatedUuid);
      if (guestUser != null) {
        _user = guestUser;
      }
    } catch (e) {
      debugPrint('Unable to login as guest: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading = true;
      UserModel? loggedInUser = await service.login(email, password);
      if (loggedInUser != null) {
        _user = loggedInUser;
      }
      isLoading = false;
    } catch (e) {
      showToast('Unable to login: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> signup(SignupBody signupBody) async {
    try {
      UserModel? registeredUser = await service.signup(signupBody);
      if (registeredUser != null) {
        _user = registeredUser;
      }
    } catch (e) {
      showToast('Unable to signup: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<void> socialLogin(SocialLoginModel socialLoginModel) async {
    // UserModel? loggedInUser = await service.socialLogin(socialLoginModel, _deviceId ?? 'unknown');
    // if (loggedInUser != null) {
    //   _user = loggedInUser;
    //   update();
    // }
  }

  void loadCredits() {
    int? savedCredits = service.loadCredits();
    _credits = savedCredits ?? 0;
    update();
  }

  Future<void> updateCredits(int value) async {
    // deduct credits used from available credits
    int updatedCredits = _credits - value;
    if (updatedCredits.isNegative) {
      updatedCredits = 0;
    }
    bool success = await service.saveCredits(updatedCredits);
    if (success) {
      _credits = updatedCredits;
      update();
    }
  }
}
