import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../utils/images.dart';

showPromptLoading({bool upscale = false, bool facefix = false}) =>
    SmartDialog.show(
      maskColor: Colors.black.withOpacity(0.9),
      backType: SmartBackType.block,
      builder: (context) => PromptLoading(
        facefix: facefix,
        upscale: upscale,
      ),
    );

class PromptLoading extends StatefulWidget {
  final bool upscale, facefix;
  const PromptLoading(
      {required this.facefix, required this.upscale, super.key});

  @override
  State<PromptLoading> createState() => _PromptLoadingState();
}

class _PromptLoadingState extends State<PromptLoading> {
  List<String> _messages = [
    "analyzing_prompt",
    "creating_your_idea".tr,
    "generating_image",
  ];

  final List<String> _subheading = [
    "it_may_take_a_while_please_dont_close_your_app",
    "awaiting_your_imagination",
    "patience_masterpiece_loading",
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    if (widget.facefix) {
      _messages = [
        "analyzing_image",
        "fixing_face",
      ];
    }
    if (widget.upscale) {
      _messages = [
        "analyzing_image",
        "upscaling_image",
      ];
    }
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_currentIndex < _messages.length - 1) {
        setState(() {
          _currentIndex++;
        });
      } else {
        timer.cancel(); // Stop the timer when all messages are displayed
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                LottieBuilder.asset(
                  Images.animation_2,
                  height: 200.sp,
                  fit: BoxFit.cover,
                ),
                LottieBuilder.asset(
                  Images.animation_1,
                  height: 200.sp,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${_messages[_currentIndex].tr} ",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 14.sp,
                  child: DefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
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
            const SizedBox(height: 16),
            Text(
              widget.upscale || widget.facefix
                  ? _subheading[0].tr
                  : _subheading[_currentIndex].tr,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
