import 'package:flutter/gestures.dart';
import 'package:pixart_app/features/auth/presentation/view/email_login.dart';
import 'package:pixart_app/imports.dart';
import '../../../../core/widgets/image_grid_scaffold.dart';
import '../widgets/social_login_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageGridScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Image.asset(Images.logo, width: 36.sp, height: 36.sp, color: context.font14.color),
          ),

          SizedBox(height: 12.sp),

          // Welcome text
          Text('Welcome to', style: context.font14.copyWith(color: context.theme.hintColor)),

          SizedBox(height: 4.sp),

          // App name
          Text(AppConstants.appName, style: context.font32.copyWith(fontWeight: FontWeight.w600)),

          SizedBox(height: 24.sp),

          SocialLoginWidget(),

          SizedBox(height: 12.sp),

          SocialLoginButton(
            label: 'Continue with Email',
            icon: Iconsax.sms_copy,
            onTap: () => launchScreen(EmailLoginScreen()),
          ),

          SizedBox(height: 12.sp),

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: context.font12.copyWith(color: context.theme.hintColor),
              children: [
                const TextSpan(text: 'By proceeding, you agree to our '),
                TextSpan(
                  text: 'Terms of Use',
                  style: TextStyle(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
          ),
          SafeArea(child: SizedBox()),
        ],
      ),
    );
  }
}
