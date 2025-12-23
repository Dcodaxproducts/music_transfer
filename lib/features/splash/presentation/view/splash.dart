import 'dart:async';
import 'package:pixart_app/imports.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ValueNotifier<int> _currentTextIndex = ValueNotifier<int>(0);
  late Timer _timer;

  final List<String> _loadingTexts = [
    'getting_started',
    "loading_assets",
    "initializing_ai_models",
    "almost_there",
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_currentTextIndex.value < _loadingTexts.length - 1) {
        _currentTextIndex.value++;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _currentTextIndex.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppPadding.padding16,
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50.sp),
                  Image.asset(Images.logo, width: 150.sp, height: 150.sp),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 18.sp,
                  height: 18.sp,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.font16.color!,
                    ),
                  ),
                ),
                SizedBox(width: 12.sp),
                ValueListenableBuilder(
                  valueListenable: _currentTextIndex,
                  builder: (BuildContext context, int value, Widget? child) {
                    return Text(
                      _loadingTexts[_currentTextIndex.value].tr,
                      style: context.font14.copyWith(color: hintColorDark),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 32.sp),
          ],
        ),
      ),
    );
  }
}
