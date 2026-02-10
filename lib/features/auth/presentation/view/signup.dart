import 'package:pixart_app/features/auth/presentation/view/otp_verification.dart';
import 'package:pixart_app/features/splash/presentation/controller/splash_controller.dart';
import 'package:pixart_app/imports.dart';
import '../../data/model/signup_body.dart';
import '../controller/auth_controller.dart';
import 'email_login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // value notifiers
  final ValueNotifier<XFile?> _profileImage = ValueNotifier<XFile?>(null);
  final ValueNotifier<bool> _obscurePassword = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _obscureConfirmPassword = ValueNotifier<bool>(true);

  // Focus nodes
  final FocusScopeNode _emailFocusNode = FocusScopeNode();
  final FocusScopeNode _passwordFocusNode = FocusScopeNode();
  final FocusScopeNode _confirmPasswordFocusNode = FocusScopeNode();

  void _pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _profileImage.value = image;
    }
  }

  @override
  dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _profileImage.dispose();
    _obscurePassword.dispose();
    _obscureConfirmPassword.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
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
                    Text("create_account".tr, style: context.font28.copyWith(fontWeight: FontWeight.w600)),
                    SizedBox(height: 8.sp),
                    Text(
                      "provide_details_create_account".tr,
                      style: context.font14.copyWith(color: context.theme.hintColor),
                    ),

                    SizedBox(height: 24.sp),

                    ValueListenableBuilder<XFile?>(
                      valueListenable: _profileImage,
                      builder: (context, value, child) {
                        return Center(
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: _pickProfileImage,
                                child: CircleAvatar(
                                  radius: 60.sp,
                                  backgroundColor: context.theme.dividerColor,
                                  backgroundImage: value != null ? FileImage(File(value.path)) : null,
                                  child: value == null ? child : null,
                                ),
                              ),
                              if (value != null)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: _pickProfileImage,
                                    child: CircleAvatar(
                                      radius: 18.sp,
                                      backgroundColor: context.theme.primaryColor,
                                      child: Icon(Iconsax.edit_2, size: 16.sp, color: Colors.white),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                      child: Icon(Iconsax.camera, size: 24.sp, color: context.theme.hintColor),
                    ),

                    SizedBox(height: 24.sp),
                    Text("name".tr, style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                    SizedBox(height: 8.sp),
                    CustomTextField(
                      hintText: "enter_your_name".tr,
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Iconsax.user_copy,
                      controller: _nameController,
                      autofillHints: const [AutofillHints.name],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "please_enter_your_name".tr;
                        }
                        return null;
                      },
                      onSubmitted: (_) {
                        _emailFocusNode.requestFocus();
                      },
                    ),
                    SizedBox(height: 16.sp),
                    Text("email".tr, style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                    SizedBox(height: 8.sp),
                    CustomTextField(
                      hintText: "enter_your_email".tr,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Iconsax.sms_copy,
                      controller: _emailController,
                      focusNode: _emailFocusNode,
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
                          textInputAction: TextInputAction.next,
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
                          hintText: "enter_your_password_again".tr,
                          obscureText: obscureText,
                          prefixIcon: Iconsax.lock_copy,
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocusNode,
                          textInputAction: TextInputAction.done,
                          autofillHints: const [AutofillHints.password],
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

                    SizedBox(height: 24.sp),
                    PrimaryButton(
                      text: controller.isLoading ? "signing_up".tr : "sign_up".tr,
                      onPressed: _signup,
                      isLoading: controller.isLoading,
                    ),
                    SizedBox(height: 8.sp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "already_have_account".tr,
                          style: context.font12.copyWith(color: context.theme.hintColor),
                        ),
                        TextButton(
                          onPressed: () => launchScreen(const EmailLoginScreen(), replace: true),
                          child: Text(
                            "login".tr,
                            style: context.font12.copyWith(decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),

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

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      final String email = _emailController.text.trim();
      SignupBody signupBody = SignupBody(
        name: _nameController.text.trim(),
        email: email,
        password: _passwordController.text,
        profileImage: _profileImage.value,
        uid: SplashController.find.deviceId ?? AuthController.find.user?.uid ?? const Uuid().v4(),
      );
      AuthController.find.signup(signupBody).then((success) {
        if (success) {
          launchScreen(OtpVerificationScreen(email: email));
        }
      });
    }
  }
}
