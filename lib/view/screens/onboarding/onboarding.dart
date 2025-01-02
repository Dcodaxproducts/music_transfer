import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/controller/settings_controller.dart';
import 'package:matrix_ai/main.dart';
import 'package:matrix_ai/utils/colors.dart';
import 'package:matrix_ai/utils/style.dart';
import 'widgets/progress_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  OnboardingScreenState createState() => OnboardingScreenState();
}

class OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _images = [
    'assets/images/intro_1.png',
    'assets/images/intro_2.png',
    'assets/images/intro_3.png',
  ];
  final List<String> _titles = [
    "onboarding_title1",
    "onboarding_title2",
    "onboarding_title3",
  ];
  final List<String> _subtitles = [
    "onboarding_subtitle1",
    "onboarding_subtitle2",
    "onboarding_subtitle3",
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentPage == 0,
      onPopInvokedWithResult: (value, result) {
        if (_currentPage > 0) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColorDark,
        body: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _images.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return ParallaxCard(
                    imagePath: _images[index],
                    title: _titles[index],
                    subtitle: _subtitles[index],
                  );
                },
              ),
            ),
            Padding(
              padding: paddingDefault,
              child: Column(
                children: [
                  Row(
                    children: List.generate(
                      _images.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4.sp),
                        width: (_currentPage == index ? 20 : 8).sp,
                        height: (_currentPage == index ? 8 : 8).sp,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? Colors.white : Colors.white.withOpacity(0.5),
                          borderRadius: borderRadiusSmall,
                          gradient: _currentPage == index ? secondaryGradient : null,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.sp),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _saveFirstTime,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
                        ),
                        child: Text(
                          "skip".tr,
                          style: bodyLarge(context).copyWith(color: Colors.white),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_currentPage < _images.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _saveFirstTime();
                          }
                        },
                        child: ProgressButton(percentage: 0.34 * (_currentPage + 1).toDouble()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SafeArea(child: SizedBox())
          ],
        ),
      ),
    );
  }

  _saveFirstTime() {
    SettingsController.find.saveFirstTime();
    RestartWidget.restartApp(context);
  }
}

class ParallaxCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const ParallaxCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Image.asset(imagePath, width: double.infinity, fit: BoxFit.fitWidth)),
        SizedBox(height: spacingDefault),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: spacingDefault),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.tr.toUpperCase(),
                style: displaySmall(context).copyWith(color: Colors.white),
              ),
              SizedBox(height: spacingSmall),
              Text(
                subtitle.tr,
                style: bodyLarge(context).copyWith(color: Colors.white),
              ),
            ],
          ),
        )
      ],
    );
  }
}
