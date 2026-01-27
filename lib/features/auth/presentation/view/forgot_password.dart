import 'package:pixart_app/imports.dart';
import 'otp_verification.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: PrimaryBackButton()),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: AppPadding.screenPadding,
          children: [
            Text("Forgot Password?", style: context.font28.copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: 8.sp),
            Text(
              "Don't worry! Enter your email address and we'll send you a verification code to reset your password.",
              style: context.font14.copyWith(color: context.theme.hintColor),
            ),

            SizedBox(height: 32.sp),

            // Email icon illustration
            Center(
              child: Container(
                width: 100.sp,
                height: 100.sp,
                decoration: BoxDecoration(
                  color: context.theme.primaryColor.withAlpha(25),
                  shape: BoxShape.circle,
                ),
                child: Icon(Iconsax.sms_copy, size: 48.sp, color: context.theme.primaryColor),
              ),
            ),

            SizedBox(height: 32.sp),

            Text("Email", style: context.font14.copyWith(fontWeight: FontWeight.w500)),
            SizedBox(height: 8.sp),
            CustomTextField(
              hintText: "Enter your email",
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              prefixIcon: Iconsax.sms_copy,
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!GetUtils.isEmail(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),

            SizedBox(height: 32.sp),

            PrimaryButton(text: 'Send Code', onPressed: _sendResetCode),

            SizedBox(height: 16.sp),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Back to Login",
                style: context.font14.copyWith(
                  decoration: TextDecoration.underline,
                  color: context.theme.hintColor,
                ),
              ),
            ),

            SafeArea(child: SizedBox()),
          ],
        ),
      ),
    );
  }

  void _sendResetCode() {
    if (_formKey.currentState!.validate()) {
      // Navigate to OTP verification screen
      launchScreen(OtpVerificationScreen(email: _emailController.text.trim(), isPasswordReset: true));
    }
  }
}
