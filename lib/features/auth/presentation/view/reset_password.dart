import 'package:pixart_app/features/dashboard/presentation/view/dashboard.dart';
import 'package:pixart_app/features/profile/presentation/controller/profile_controller.dart';
import 'package:pixart_app/imports.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _obscureConfirmPassword = ValueNotifier<bool>(true);
  final FocusScopeNode _confirmPasswordFocusNode = FocusScopeNode();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _obscurePassword.dispose();
    _obscureConfirmPassword.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
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
                  Text("reset_password".tr, style: context.font28.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8.sp),
                  Text(
                    "create_new_password".tr,
                    style: context.font14.copyWith(color: context.theme.hintColor),
                  ),

                  SizedBox(height: 32.sp),

                  // Lock icon illustration
                  Center(
                    child: Container(
                      width: 100.sp,
                      height: 100.sp,
                      decoration: BoxDecoration(
                        color: context.theme.primaryColor.withAlpha(25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Iconsax.lock_copy, size: 48.sp, color: context.theme.primaryColor),
                    ),
                  ),

                  SizedBox(height: 32.sp),

                  Text("new_password".tr, style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                  SizedBox(height: 8.sp),
                  ValueListenableBuilder<bool>(
                    valueListenable: _obscurePassword,
                    builder: (context, obscureText, child) {
                      return CustomTextField(
                        hintText: "enter_new_password".tr,
                        obscureText: obscureText,
                        prefixIcon: Iconsax.lock_copy,
                        controller: _passwordController,
                        textInputAction: TextInputAction.next,
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
                        onSubmitted: (_) {
                          _confirmPasswordFocusNode.requestFocus();
                        },
                      );
                    },
                  ),

                  SizedBox(height: 16.sp),

                  Text("confirm_password".tr, style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                  SizedBox(height: 8.sp),
                  ValueListenableBuilder<bool>(
                    valueListenable: _obscureConfirmPassword,
                    builder: (context, obscureText, child) {
                      return CustomTextField(
                        hintText: "confirm_your_new_password".tr,
                        obscureText: obscureText,
                        prefixIcon: Iconsax.lock_copy,
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocusNode,
                        textInputAction: TextInputAction.done,
                        suffixIcon: IconButton(
                          icon: Icon(obscureText ? Iconsax.eye_copy : Iconsax.eye_slash_copy),
                          onPressed: () {
                            _obscureConfirmPassword.value = !_obscureConfirmPassword.value;
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "please_confirm_your_password".tr;
                          }
                          if (value != _passwordController.text) {
                            return "passwords_do_not_match".tr;
                          }
                          return null;
                        },
                      );
                    },
                  ),

                  SizedBox(height: 32.sp),

                  PrimaryButton(
                    text: controller.isLoading ? "resetting_password".tr : "reset_password".tr,
                    onPressed: _resetPassword,
                    isLoading: controller.isLoading,
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

  void _resetPassword() {
    if (_formKey.currentState!.validate()) {
      ProfileController.find.updateProfile(password: _passwordController.text).then((success) {
        if (success) {
          showToast("password_reset_successfully".tr);
          launchScreen(const DashboardScreen(), pushAndRemove: true);
        }
      });
    }
  }
}
