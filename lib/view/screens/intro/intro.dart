import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/utils/images.dart';
import '../../base/bottom_button.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  int _currentIndex = 0;
  final List<String> _images = [Images.intro_1, Images.intro_2, Images.intro_3];
  final List<String> _titles = [
    'onboarding_title1',
    'onboarding_title2',
    'onboarding_title3'
  ];
  final List<String> _subtitles = [
    'onboarding_subtitle1',
    'onboarding_subtitle2',
    'onboarding_subtitle3'
  ];

  Widget Function(Widget, Animation<double>) slideTransitionBuilder =
      (child, animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  };
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        if (_currentIndex > 0) {
          setState(() {
            _currentIndex--;
          });
        }
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Image.asset(
                _images[_currentIndex],
                key: ValueKey(_images[_currentIndex]),
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.sp),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.0),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 50.sp, width: double.infinity),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: slideTransitionBuilder,
                      child: Text(
                        _titles[_currentIndex].tr,
                        key: ValueKey(_titles[_currentIndex]),
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 8.sp),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: slideTransitionBuilder,
                      child: Text(
                        _subtitles[_currentIndex].tr,
                        key: ValueKey(_subtitles[_currentIndex]),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    SizedBox(height: 30.sp),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomButton(
          text: 'Continue',
          onPressed: _continue,
        ),
      ),
    );
  }

  _continue() {
    if (_currentIndex < _images.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // launchScreen(child)
    }
  }
}
