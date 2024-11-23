import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/controller/image_generation_controller.dart';
import 'package:matrix_ai/utils/colors.dart';
import '../../../common/loading.dart';

showPromptLoading({bool upscale = false, bool facefix = false}) =>
    SmartDialog.show(
      maskColor: backgroundColorDark,
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
  Timer? _closeButtonTimer;
  bool _showCloseButton = false;

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
    _startTimers();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _closeButtonTimer?.cancel();
    super.dispose();
  }

  void _startTimers() {
    // Timer for updating messages
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_currentIndex < _messages.length - 1) {
        setState(() {
          _currentIndex++;
        });
      } else {
        timer.cancel(); // Stop the timer when all messages are displayed
      }
    });

    // Timer for showing the close button after 15 seconds
    _closeButtonTimer = Timer(const Duration(seconds: 15), () {
      setState(() {
        _showCloseButton = true;
      });
    });
  }

  void _cancelApiCall() {
    ImageGenerationController.find.cancelRequest();
    SmartDialog.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.sp),
      child: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Loading(size: 250),
                SizedBox(height: 10.sp),
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
            // Close button
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 10,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _showCloseButton ? 1 : 0,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.sp),
                    ),
                    visualDensity:
                        const VisualDensity(horizontal: -4, vertical: -3),
                  ),
                  onPressed: _cancelApiCall,
                  child: Text('cancel'.tr),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
