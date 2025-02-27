import 'package:flutter/gestures.dart';
import 'package:matrix_ai/features/settings/presentation/controller/settings_controller.dart';
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
          padding: EdgeInsets.symmetric(horizontal: spacingDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 150.h),
              Text('Get ready to', style: displaySmall(context)),
              SizedBox(height: spacingExtraSmall),
              GradientWidget(
                child: Text(
                  'turn your\nimagination',
                  style: displaySmall(context).copyWith(height: 1.4, color: Colors.white),
                ),
              ),
              SizedBox(height: spacingExtraSmall),
              Text(
                'into art: Your\ncreative\njourney begins\nnow!',
                style: displaySmall(context).copyWith(height: 1.4),
              ),
              const Spacer(),
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(spacingExtraLarge),
                    onTap: () {
                      setState(() {
                        _radioSelected = !_radioSelected;
                      });
                    },
                    child: LanguageRadioButton(selected: _radioSelected),
                  ),
                  SizedBox(width: spacingMedium),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: bodySmall(context),
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
                                launchUrlString(AppConstants.TERMS_AND_CONDITIONS);
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
                                launchUrlString(AppConstants.PRIVACY_POLICY);
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

  _saveFirstTime() {
    SettingsController.find.saveFirstTime();
  }
}
