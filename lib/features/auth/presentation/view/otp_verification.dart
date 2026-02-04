import 'dart:async';
import 'package:pixart_app/features/auth/presentation/controller/auth_controller.dart';
import 'package:pixart_app/features/dashboard/presentation/view/dashboard.dart';
import 'package:pixart_app/imports.dart';

import 'reset_password.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final bool isPasswordReset;

  const OtpVerificationScreen({super.key, required this.email, this.isPasswordReset = false});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  final ValueNotifier<int> _resendTimer = ValueNotifier<int>(60);
  final ValueNotifier<bool> _canResend = ValueNotifier<bool>(false);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _resendTimer.dispose();
    _canResend.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _canResend.value = false;
    _resendTimer.value = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer.value > 0) {
        _resendTimer.value--;
      } else {
        _canResend.value = true;
        timer.cancel();
      }
    });
  }

  void _onOtpDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    // Auto-verify when all digits are entered
    if (_getOtp().length == 4) {
      _verifyOtp();
    }
  }

  String _getOtp() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  void _resendOtp() {
    if (_canResend.value) {
      AuthController.find.resendOtp(widget.email).then((success) {
        if (success) {
          showToast("otp_resent_successfully".tr);
        }
      });
      _startResendTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (controller) {
        return AbsorbPointer(
          absorbing: controller.isLoading,
          child: Scaffold(
            appBar: AppBar(leading: PrimaryBackButton()),
            body: ListView(
              padding: AppPadding.screenPadding,
              children: [
                Text("verify_your_email".tr, style: context.font28.copyWith(fontWeight: FontWeight.w600)),
                SizedBox(height: 8.sp),
                Text(
                  "We've sent a 4-digit verification code to",
                  style: context.font14.copyWith(color: context.theme.hintColor),
                ),
                SizedBox(height: 4.sp),
                Text(widget.email, style: context.font14.copyWith(fontWeight: FontWeight.w600)),

                SizedBox(height: 32.sp),

                // OTP Input Fields
                Row(
                  spacing: 12.sp,
                  children: List.generate(4, (index) {
                    return Expanded(
                      child: SizedBox(
                        height: 60.sp,
                        child: TextFormField(
                          controller: _otpControllers[index],
                          focusNode: _focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: context.font20.copyWith(fontWeight: FontWeight.w600),
                          onTapOutside: (_) => FocusScope.of(context).unfocus(),
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.sp),
                              borderSide: BorderSide(color: context.theme.dividerColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.sp),
                              borderSide: BorderSide(color: context.theme.dividerColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.sp),
                              borderSide: BorderSide(color: context.theme.primaryColor, width: 2),
                            ),
                            filled: true,
                            fillColor: context.theme.cardColor,
                          ),
                          onChanged: (value) => _onOtpDigitChanged(index, value),
                        ),
                      ),
                    );
                  }),
                ),

                SizedBox(height: 32.sp),

                // Resend Timer
                ValueListenableBuilder<int>(
                  valueListenable: _resendTimer,
                  builder: (context, seconds, child) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: _canResend,
                      builder: (context, canResend, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "didnt_receive_code".tr,
                              style: context.font12.copyWith(color: context.theme.hintColor),
                            ),
                            if (canResend)
                              TextButton(
                                onPressed: _resendOtp,
                                child: Text(
                                  "resend".tr,
                                  style: context.font12.copyWith(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            else
                              Text(
                                "resend_in_seconds".trParams({"seconds": "$seconds"}),
                                style: context.font12.copyWith(color: context.theme.hintColor),
                              ),
                          ],
                        );
                      },
                    );
                  },
                ),

                SizedBox(height: 24.sp),

                PrimaryButton(
                  text: controller.isLoading ? "verifying".tr : "verify".tr,
                  isLoading: controller.isLoading,
                  onPressed: _verifyOtp,
                ),

                SafeArea(child: SizedBox()),
              ],
            ),
          ),
        );
      },
    );
  }

  void _verifyOtp() {
    final String otp = _getOtp();
    if (otp.length == 4) {
      AuthController.find.verifyOtp(widget.email, otp).then((success) {
        if (success) {
          if (widget.isPasswordReset) {
            launchScreen(ResetPasswordScreen());
          } else {
            launchScreen(DashboardScreen(), pushAndRemove: true);
          }
        }
      });
    }
  }
}
