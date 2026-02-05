import 'package:flutter/gestures.dart';
import 'package:pixart_app/features/splash/presentation/controller/splash_controller.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../imports.dart';
import '../widgets/bottom_button.dart';
import '../../../../core/widgets/gradient_widget.dart';
import '../../../language/presentation/view/language.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _radioSelected = true;
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 150.h),
              Text("get_ready_to".tr, style: context.font30),
              SizedBox(height: 4.sp),
              GradientWidget(
                child: Text(
                  "turn_your_imagination".tr,
                  style: context.font30.copyWith(height: 1.4, color: Colors.white),
                ),
              ),
              SizedBox(height: 4.sp),
              Text("into_art_creative_journey".tr, style: context.font30.copyWith(height: 1.4)),
              const Spacer(),
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(32.sp),
                    onTap: () {
                      setState(() {
                        _radioSelected = !_radioSelected;
                      });
                    },
                    child: LanguageRadioButton(selected: _radioSelected),
                  ),
                  SizedBox(width: 12.sp),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: context.font12,
                        children: [
                          TextSpan(text: "i_agree_to_the".tr),
                          TextSpan(
                            text: "terms_of_use".tr,
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launchUrlString(AppConstants.terms);
                              },
                          ),
                          TextSpan(text: "and_acknowledged_read".tr),
                          TextSpan(
                            text: "privacy_policy_text".tr,
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launchUrlString(AppConstants.privacy);
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.sp),
            ],
          ),
        ),
        bottomNavigationBar: BottomButton(
          text: "agree_and_continue".tr,
          onPressed: _radioSelected ? _saveFirstTime : null,
        ),
      ),
    );
  }

  void _saveFirstTime() {
    SplashController.find.saveFirstTime();
  }
}
