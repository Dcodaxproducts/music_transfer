import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:matrix_ai/imports.dart';
import 'package:matrix_ai/view/base/common/loading.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorDark,
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
                    style: displayMedium(context).copyWith(fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  SizedBox(height: spacingSmall),
                  // pixart Subtitle
                  Text(
                    'the_best_ai_image_generator'.tr,
                    style: bodyMedium(context).copyWith(color: hintColorDark),
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
                  style: bodyMedium(context).copyWith(color: hintColorDark),
                ),
                SizedBox(
                  width: 14.sp,
                  child: DefaultTextStyle(
                    style: bodyMedium(context).copyWith(color: hintColorDark),
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
