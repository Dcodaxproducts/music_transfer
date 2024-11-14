import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
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
    "Analyzing prompt",
    "Creating you idea",
    "Generating Image",
  ];

  final List<String> _subheading = [
    "It may take a while. Please don't close your app.",
    "Awaiting Your Imaginations",
    "Patience, Masterpiece Loading",
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    if (widget.facefix) {
      _messages = [
        "Analyzing image",
        "Fixing Face",
      ];
    }
    if (widget.upscale) {
      _messages = [
        "Analyzing image",
        "Upscaling Image",
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
            LottieBuilder.asset(
              Images.animation,
              height: 200.sp,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${_messages[_currentIndex]} ",
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
                  ? _subheading[0]
                  : _subheading[_currentIndex],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
