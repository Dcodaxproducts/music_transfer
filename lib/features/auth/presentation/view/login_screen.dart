import 'package:flutter/gestures.dart';
import 'package:pixart_app/imports.dart';
import '../../../../core/widgets/image_grid_scaffold.dart';

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

          SocialLoginButton(
            label: 'Continue with Google',
            image: Images.google,
            isDark: true,
            onTap: () {
              // Handle Google login
            },
          ),

          SizedBox(height: 12.sp),

          SocialLoginButton(
            label: 'Continue with Email',
            icon: Iconsax.sms,
            onTap: () {
              // Handle Facebook login
            },
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
