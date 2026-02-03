import 'package:flutter/gestures.dart';
import 'package:pixart_app/features/auth/presentation/view/email_login.dart';
import 'package:pixart_app/imports.dart';
import 'package:url_launcher/url_launcher_string.dart';
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
          Text("welcome_to".tr, style: context.font14.copyWith(color: context.theme.hintColor)),

          SizedBox(height: 4.sp),

          // App name
          Text(AppConstants.appName, style: context.font32.copyWith(fontWeight: FontWeight.w600)),

          SizedBox(height: 24.sp),

          SocialLoginWidget(),

          SizedBox(height: 12.sp),

          SocialLoginButton(
            label: "continue_with_email".tr,
            icon: Iconsax.sms_copy,
            onTap: () => launchScreen(EmailLoginScreen()),
          ),

          SizedBox(height: 12.sp),

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: context.font12.copyWith(color: context.theme.hintColor),
              children: [
                TextSpan(text: "by_proceeding_agree".tr),
                TextSpan(
                  text: "terms_of_use".tr,
                  style: TextStyle(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () => launchUrlString(AppConstants.privacy),
                ),
                TextSpan(text: "and".tr),
                TextSpan(
                  text: 'privacy_policy'.tr,
                  style: TextStyle(decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()..onTap = () => launchUrlString(AppConstants.terms),
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
