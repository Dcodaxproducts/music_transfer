import 'package:google_sign_in/google_sign_in.dart';
import 'package:pixart_app/features/auth/presentation/controller/auth_controller.dart';

import '../../../../imports.dart';
import '../../data/model/social_login_model.dart';

class SocialLoginWidget extends StatelessWidget {
  const SocialLoginWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SocialLoginButton(
      label: 'Continue with Google',
      image: Images.google,
      isDark: true,
      onTap: _googleLogin,
    );
  }

  Future<void> _googleLogin() async {
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;
    try {
      showLoading();
      await googleSignIn.initialize();
      await googleSignIn.signOut();
      GoogleSignInAccount googleAccount = (await googleSignIn.authenticate(scopeHint: ['email', 'profile']));

      // Call social login in AuthController
      AuthController.find.socialLogin(
        SocialLoginModel(
          name: googleAccount.displayName,
          email: googleAccount.email,
          uniqueId: googleAccount.id,
          medium: 'google',
        ),
      );
    } catch (er) {
      debugPrint('access token error is : $er');
    } finally {
      dismiss();
    }
  }
}

class SocialLoginButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final String? image;
  final VoidCallback onTap;
  final bool isDark;
  const SocialLoginButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.image,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color? backgroundColor = isDark ? context.font14.color : context.theme.cardColor;
    final Color? textColor = isDark ? context.theme.scaffoldBackgroundColor : context.font14.color;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(minimumSize: Size(400.sp, 60.sp), backgroundColor: backgroundColor),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (image != null) Image.asset(image!, width: 24.sp, height: 24.sp),
          if (icon != null) Icon(icon, size: 24.sp, color: textColor),
          Text(label, style: context.font14.copyWith(color: textColor)),
          SizedBox(width: 16.sp),
        ],
      ),
    );
  }
}
