import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pixart_app/features/auth/presentation/controller/auth_controller.dart';
import 'package:pixart_app/features/dashboard/presentation/view/dashboard.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../../imports.dart';
import '../../../splash/presentation/controller/splash_controller.dart';
import '../../data/model/social_login_model.dart';

class SocialLoginWidget extends StatelessWidget {
  const SocialLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SocialLoginButton(
              label: "continue_with_google".tr,
              image: Images.google,
              isDark: GetPlatform.isAndroid,
              onTap: _googleLogin,
              isLoading: controller.googleLoading,
            ),
            Visibility(
              visible: GetPlatform.isIOS,
              child: Padding(
                padding: EdgeInsets.only(top: 12.sp),
                child: SocialLoginButton(
                  label: "continue_with_apple".tr,
                  icon: Iconsax.apple,
                  isDark: true,
                  onTap: _appleLogin,
                  isLoading: controller.appleLoading,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _googleLogin() async {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    try {
      showLoading();
      await googleSignIn.initialize();
      await googleSignIn.signOut();
      GoogleSignInAccount googleAccount = (await googleSignIn.authenticate(scopeHint: ['email', 'profile']));

      // Create social login model
      final SocialLoginModel socialLoginModel = SocialLoginModel(
        uid: SplashController.find.deviceId ?? AuthController.find.user?.uid ?? Uuid().v4(),
        name: googleAccount.displayName,
        email: googleAccount.email,
        medium: 'google',
        profilePicture: googleAccount.photoUrl,
      );

      // Call social login in AuthController
      AuthController.find.socialLogin(socialLoginModel).then((success) {
        if (success) {
          launchScreen(DashboardScreen(), pushAndRemove: true);
        }
      });
    } catch (er) {
      debugPrint('access token error is : $er');
    } finally {
      dismiss();
    }
  }

  Future<void> _appleLogin() async {
    try {
      showLoading();
      // Ensure any existing sign-in is cleared
      await FirebaseAuth.instance.signOut();
      final AuthorizationCredentialAppleID appleUser = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );

      final oAuthProvider = OAuthProvider('apple.com');
      final firebaseCredential = oAuthProvider.credential(
        idToken: appleUser.identityToken,
        accessToken: appleUser.authorizationCode,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(firebaseCredential);
      User user = userCredential.user!;

      // Retrieving user details
      // Note: Firebase may not always provide the email and displayName directly.
      // Email and displayName are only provided the first time the user signs in with Apple.
      String email = user.email ?? '';
      String? name = user.displayName;

      // Create social login model
      final SocialLoginModel socialLoginModel = SocialLoginModel(
        uid: SplashController.find.deviceId ?? AuthController.find.user?.uid ?? Uuid().v4(),
        name: name,
        email: email,
        medium: 'apple',
        profilePicture: user.photoURL,
      );
      // Call social login in AuthController
      AuthController.find.socialLogin(socialLoginModel).then((success) {
        if (success) {
          launchScreen(DashboardScreen(), pushAndRemove: true);
        }
      });
    } catch (e) {
      debugPrint('Apple Sign-In error: $e');
    } finally {
      dismiss();
    }
  }
}
