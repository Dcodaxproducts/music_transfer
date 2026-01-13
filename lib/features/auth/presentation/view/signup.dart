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
      appBar: AppBar(leading: PrimaryBackButton()),
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
                    Text("Create Account", style: context.font28.copyWith(fontWeight: FontWeight.w600)),
                    SizedBox(height: 8.sp),
                    Text(
                      "Provide your details to create a new account.",
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
                    Text("Name", style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                    SizedBox(height: 8.sp),
                    CustomTextField(
                      hintText: "Enter your name",
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Iconsax.user,
                      controller: _nameController,
                      autofillHints: [AutofillHints.name],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      onSubmitted: (_) {
                        _emailFocusNode.requestFocus();
                      },
                    ),
                    SizedBox(height: 16.sp),
                    Text("Email", style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                    SizedBox(height: 8.sp),
                    CustomTextField(
                      hintText: "Enter your email",
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Iconsax.sms,
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      autofillHints: [AutofillHints.email],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onSubmitted: (_) {
                        _passwordFocusNode.requestFocus();
                      },
                    ),

                    SizedBox(height: 16.sp),
                    Text("Password", style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                    SizedBox(height: 8.sp),
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscurePassword,
                      builder: (context, obscureText, child) {
                        return CustomTextField(
                          hintText: "Enter your password",
                          obscureText: obscureText,
                          prefixIcon: Iconsax.lock,
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          textInputAction: TextInputAction.next,
                          autofillHints: [AutofillHints.password],
                          suffixIcon: IconButton(
                            icon: Icon(obscureText ? Iconsax.eye : Iconsax.eye_slash),
                            onPressed: () {
                              _obscurePassword.value = !_obscurePassword.value;
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
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
                    Text("Confirm Password", style: context.font14.copyWith(fontWeight: FontWeight.w500)),
                    SizedBox(height: 8.sp),
                    ValueListenableBuilder<bool>(
                      valueListenable: _obscureConfirmPassword,
                      builder: (context, obscureText, child) {
                        return CustomTextField(
                          hintText: "Enter your password again",
                          obscureText: obscureText,
                          prefixIcon: Iconsax.lock,
                          controller: _confirmPasswordController,
                          focusNode: _confirmPasswordFocusNode,
                          textInputAction: TextInputAction.done,
                          autofillHints: [AutofillHints.password],
                          suffixIcon: IconButton(
                            icon: Icon(obscureText ? Iconsax.eye : Iconsax.eye_slash),
                            onPressed: () {
                              _obscureConfirmPassword.value = !_obscureConfirmPassword.value;
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        );
                      },
                    ),

                    SizedBox(height: 24.sp),
                    PrimaryButton(text: 'Sign Up', onPressed: _signup),
                    SizedBox(height: 8.sp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: context.font12.copyWith(color: context.theme.hintColor),
                        ),
                        TextButton(
                          onPressed: () => launchScreen(const EmailLoginScreen(), replace: true),
                          child: Text(
                            "Login",
                            style: context.font12.copyWith(decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),

                    SafeArea(child: SizedBox()),
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
      SignupBody signupBody = SignupBody(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        deviceId: AuthController.find.deviceId ?? 'unknown',
        profileImage: _profileImage.value,
      );
      AuthController.find.service.signup(signupBody).then((success) {});
    }
  }
}
