import 'package:google_sign_in/google_sign_in.dart';
import 'package:pixart_app/features/auth/presentation/controller/auth_controller.dart';
import 'package:pixart_app/features/dashboard/presentation/view/dashboard.dart';
import '../../../../imports.dart';
import '../../data/model/social_login_model.dart';

class SocialLoginWidget extends StatelessWidget {
  const SocialLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) {
        return SocialLoginButton(
          label: "continue_with_google".tr,
          image: Images.google,
          isDark: true,
          onTap: _googleLogin,
          isLoading: controller.isLoading,
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
        uid: AuthController.find.user?.uid ?? Uuid().v4(),
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
}
