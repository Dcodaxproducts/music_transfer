import 'package:flutter/gestures.dart';
import 'package:pixart_app/image_gen/prompt_setting/presentation/controller/settings_controller.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../imports.dart';
import 'widgets/bottom_button.dart';
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
              Text('Get ready to', style: context.font30),
              SizedBox(height: 4.sp),
              GradientWidget(
                child: Text(
                  'turn your\nimagination',
                  style: context.font30.copyWith(
                    height: 1.4,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 4.sp),
              Text(
                'into art: Your\ncreative\njourney begins\nnow!',
                style: context.font30.copyWith(height: 1.4),
              ),
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
                          const TextSpan(text: 'I agree to the '),
                          TextSpan(
                            text: 'Terms of use',
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launchUrlString(
                                  AppConstants.termsAndConditions,
                                );
                              },
                          ),
                          const TextSpan(
                            text: ' and acknowledged I have read the ',
                          ),
                          TextSpan(
                            text: 'Privacy Policy.',
                            style: const TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                launchUrlString(AppConstants.privacyPolicy);
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
          text: 'Agree & Continue',
          onPressed: _radioSelected ? _saveFirstTime : null,
        ),
      ),
    );
  }

  void _saveFirstTime() {
    SettingsController.find.saveFirstTime();
  }
}
