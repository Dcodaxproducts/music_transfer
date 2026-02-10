import 'package:pixart_app/features/auth/data/model/user_model.dart';
import 'package:pixart_app/features/auth/presentation/view/signup.dart';
import 'package:pixart_app/features/dashboard/presentation/view/dashboard.dart';
import 'package:pixart_app/imports.dart';
import '../controller/auth_controller.dart';
import '../widgets/social_login_widget.dart';
import 'forgot_password.dart';
import 'otp_verification.dart';

class EmailLoginScreen extends StatefulWidget {
  const EmailLoginScreen({super.key});

  @override
  State<EmailLoginScreen> createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // value notifiers
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);

  // Focus nodes
  final FocusScopeNode _passwordFocusNode = FocusScopeNode();

  @override
  dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _obscurePassword.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: const PrimaryBackButton()),
      body: GetBuilder<AuthController>(
        builder: (controller) {
          return AbsorbPointer(
            absorbing: controller.isLoading,
            child: AutofillGroup(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: AppPadding.screenPadding,
                  children: [
                    Text("welcome".tr, style: context.font28.copyWith(fontWeight: FontWeight.w600)),
                    SizedBox(height: 8.sp),
                    Text(
                      "sign_in_to_continue".tr,
                      style: context.font14.copyWith(color: context.theme.hintColor),
                    ),

                    SizedBox(height: 24.sp),

                    Text("email".tr, style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                    SizedBox(height: 8.sp),
                    CustomTextField(
                      hintText: "enter_your_email".tr,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Iconsax.sms_copy,
                      controller: _emailController,
                      autofillHints: const [AutofillHints.email],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please_enter_your_email".tr;
                        }
                        if (!GetUtils.isEmail(value)) {
                          return "please_enter_valid_email".tr;
                        }
                        return null;
                      },
                      onSubmitted: (_) {
                        _passwordFocusNode.requestFocus();
                      },
                    ),

                    SizedBox(height: 16.sp),
                    Text("password".tr, style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                    SizedBox(height: 8.sp),
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscurePassword,
                      builder: (context, obscureText, child) {
                        return CustomTextField(
                          hintText: "enter_your_password".tr,
                          obscureText: obscureText,
                          prefixIcon: Iconsax.lock_copy,
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
                          suffixIcon: IconButton(
                            icon: Icon(obscureText ? Iconsax.eye_copy : Iconsax.eye_slash_copy),
                            onPressed: () {
                              _obscurePassword.value = !_obscurePassword.value;
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "please_enter_your_password".tr;
                            }
                            if (value.length < 6) {
                              return "password_min_6_chars".tr;
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => launchScreen(const ForgotPasswordScreen()),
                        child: Text(
                          "forgot_password".tr,
                          style: context.font12.copyWith(decoration: TextDecoration.underline),
                        ),
                      ),
                    ),

                    SizedBox(height: 24.sp),
                    PrimaryButton(
                      text: controller.isLoading ? "logging_in".tr : "login".tr,
                      onPressed: _login,
                      isLoading: controller.isLoading,
                    ),
                    SizedBox(height: 8.sp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "dont_have_account".tr,
                          style: context.font12.copyWith(color: context.theme.hintColor),
                        ),
                        TextButton(
                          onPressed: () => launchScreen(const SignupScreen(), replace: true),
                          child: Text(
                            "sign_up".tr,
                            style: context.font12.copyWith(decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: AppPadding.vertical(16),
                      child: Row(
                        spacing: 16.sp,
                        children: [
                          const Expanded(child: Divider()),
                          Text("or".tr, style: context.font12.copyWith(color: context.theme.hintColor)),
                          const Expanded(child: Divider()),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.sp),

                    const SocialLoginWidget(),

                    const SafeArea(child: SizedBox()),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      AuthController.find.login(email, password).then((response) {
        final UserModel? user = response.$1;
        final bool isOtpVerified = response.$2;
        if (!isOtpVerified && user != null) {
          launchScreen(OtpVerificationScreen(email: email));
        } else if (user != null) {
          launchScreen(const DashboardScreen(), pushAndRemove: true);
        }
      });
    }
  }
}
