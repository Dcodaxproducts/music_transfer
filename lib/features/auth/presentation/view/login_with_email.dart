import 'package:pixart_app/imports.dart';

import 'login_screen.dart';

class EmailLoginScreen extends StatelessWidget {
  const EmailLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: PrimaryBackButton()),
      body: ListView(
        padding: AppPadding.screenPadding,
        children: [
          Text("Login", style: context.font32.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 8.sp),
          Text(
            "Login with your email to continue",
            style: context.font14.copyWith(color: context.theme.hintColor),
          ),

          SizedBox(height: 24.sp),

          Text("Email", style: context.font14.copyWith(fontWeight: FontWeight.w500)),
          SizedBox(height: 8.sp),
          CustomTextField(
            labelText: "Email",
            hintText: "Enter your email",
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Iconsax.sms,
          ),

          SizedBox(height: 16.sp),
          Text("Password", style: context.font14.copyWith(fontWeight: FontWeight.w500)),
          SizedBox(height: 8.sp),
          CustomTextField(
            labelText: "Password",
            hintText: "Enter your password",
            obscureText: true,
            prefixIcon: Iconsax.lock,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Navigate to sign up screen
              },
              child: Text(
                "Forget Password?",
                style: context.font12.copyWith(decoration: TextDecoration.underline),
              ),
            ),
          ),

          SizedBox(height: 24.sp),
          PrimaryButton(text: 'Login', onPressed: () {}),
          SizedBox(height: 8.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account? ", style: context.font12.copyWith(color: context.theme.hintColor)),
              TextButton(
                onPressed: () {
                  // Navigate to sign up screen
                },
                child: Text("Sign Up", style: context.font12.copyWith(decoration: TextDecoration.underline)),
              ),
            ],
          ),

          Padding(
            padding: AppPadding.vertical(16),
            child: Row(
              spacing: 16.sp,
              children: [
                Expanded(child: Divider()),
                Text("OR", style: context.font12.copyWith(color: context.theme.hintColor)),
                Expanded(child: Divider()),
              ],
            ),
          ),
          SizedBox(height: 8.sp),

          SocialLoginButton(
            label: 'Continue with Google',
            image: Images.google,
            isDark: true,
            onTap: () {
              // Handle Google login
            },
          ),

          SafeArea(child: SizedBox()),
        ],
      ),
    );
  }
}
