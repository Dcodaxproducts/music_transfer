import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/view/base/common/loading.dart';
import 'package:matrix_ai/utils/images.dart';
import '../../../utils/app_constants.dart';
import '../../../utils/style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: paddingDefault,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Images.logo, width: 100.sp, height: 100.sp),
                  SizedBox(height: 150.sp),
                  // pixart Title
                  Text(
                    AppConstants.APP_NAME,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 10.sp),
                  // pixart Subtitle
                  Text(
                    'the_best_ai_image_generator'.tr,
                    style:
                        Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).hintColor),
                  ),
                  SizedBox(height: 50.sp),
                ],
              ),
            ),
            const AnimatedProgressBar(duration: Duration(seconds: 5)),
            SizedBox(height: 10.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'getting_started'.tr,
                  style: bodyMedium(context).copyWith(color: Theme.of(context).hintColor),
                ),
                SizedBox(
                  width: 14.sp,
                  child: DefaultTextStyle(
                    style:
                        Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).hintColor),
                    child: AnimatedTextKit(
                      pause: const Duration(milliseconds: 500),
                      repeatForever: true,
                      animatedTexts: [
                        TyperAnimatedText(
                          '...',
                          speed: const Duration(milliseconds: 500),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: spacingExtraLarge),
          ],
        ),
      ),
    );
  }
}
