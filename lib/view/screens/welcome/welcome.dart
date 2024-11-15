import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matrix_ai/view/screens/onboarding/onboarding.dart';
import '../../base/bottom_button.dart';
import '../../base/gradient_widget.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _agreed = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _agreed
          ? const OnboardingScreen()
          : Scaffold(
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 150.h),
                    Text(
                      'Get ready to',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 3.sp),
                    GradientWidget(
                      child: Text(
                        'turn your\nimagination',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(
                                fontWeight: FontWeight.bold, height: 1.4),
                      ),
                    ),
                    SizedBox(height: 3.sp),
                    Text(
                      'into art: Your\ncreative\njourney begins\nnow!',
                      style: Theme.of(context)
                          .textTheme
                          .displayLarge
                          ?.copyWith(fontWeight: FontWeight.bold, height: 1.4),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Radio(
                          value: true,
                          groupValue: true,
                          onChanged: (value) {},
                          activeColor:
                              Theme.of(context).textTheme.bodySmall?.color,
                          visualDensity: const VisualDensity(
                            horizontal: -4,
                            vertical: -4,
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        SizedBox(width: 10.sp),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodySmall,
                              children: const [
                                TextSpan(
                                  text: 'I agree to the ',
                                ),
                                TextSpan(
                                  text: 'Terms of use',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.blue,
                                  ),
                                ),
                                TextSpan(
                                  text: ' and acknowledged I have read the ',
                                ),
                                TextSpan(
                                  text: 'Privacy Policy.',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.blue,
                                  ),
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
                onPressed: () {
                  setState(() {
                    _agreed = true;
                  });
                },
              ),
            ),
    );
  }
}
