import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:matrix_ai/controller/settings_controller.dart';
import 'package:matrix_ai/helper/navigation.dart';
import '../../base/bottom_button.dart';
import '../../base/gradient_widget.dart';
import '../dashboard/dashboard.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsController.find.initSharedData();
    return Scaffold(
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
                    ?.copyWith(fontWeight: FontWeight.bold, height: 1.4),
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
                  activeColor: Theme.of(context).textTheme.bodySmall?.color,
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                    vertical: -4,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
      bottomNavigationBar:
          //  Padding(
          //   padding: pagePadding,
          //   child: PrimaryButton(
          //     text: 'Agree & Continue',
          //     onPressed: () {
          //       launchScreen(const DashboardScreen());
          //     },
          //   ),
          // ),
          BottomButton(
        text: 'Agree & Continue',
        onPressed: () {
          launchScreen(const DashboardScreen(), pushAndRemove: true);
        },
      ),
    );
  }
}
