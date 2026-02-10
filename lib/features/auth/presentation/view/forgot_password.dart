import 'package:pixart_app/features/auth/presentation/controller/auth_controller.dart';
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
    return GetBuilder<AuthController>(
      builder: (controller) {
        return AbsorbPointer(
          absorbing: controller.isLoading,
          child: Scaffold(
            appBar: AppBar(leading: const PrimaryBackButton()),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: AppPadding.screenPadding,
                children: [
                  Text("forgot_password".tr, style: context.font28.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8.sp),
                  Text(
                    "enter_email_reset_link".tr,
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

                  Text("email".tr, style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                  SizedBox(height: 8.sp),
                  CustomTextField(
                    hintText: "enter_your_email".tr,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    prefixIcon: Iconsax.sms_copy,
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please_enter_your_email".tr;
                      }
                      if (!GetUtils.isEmail(value)) {
                        return "please_enter_valid_email".tr;
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 32.sp),

                  PrimaryButton(
                    text: controller.isLoading ? "sending_email".tr : "send_reset_link".tr,
                    onPressed: _sendResetCode,
                    isLoading: controller.isLoading,
                  ),

                  SizedBox(height: 16.sp),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "back_to_login".tr,
                      style: context.font14.copyWith(
                        decoration: TextDecoration.underline,
                        color: context.theme.hintColor,
                      ),
                    ),
                  ),

                  const SafeArea(child: SizedBox()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _sendResetCode() {
    if (_formKey.currentState!.validate()) {
      AuthController.find.forgetPassword(_emailController.text.trim()).then((success) {
        if (success) {
          // Navigate to OTP verification screen
          launchScreen(OtpVerificationScreen(email: _emailController.text.trim(), isPasswordReset: true));
        }
      });
    }
  }
}
