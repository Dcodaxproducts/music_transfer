import 'dart:async';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:matrix_ai/controller/image_generation_controller.dart';
import 'package:matrix_ai/imports.dart';
import 'package:particles_fly/particles_fly.dart';
import 'package:shimmer/shimmer.dart';

showPromptLoading({bool upscale = false, bool backgroundRemover = false}) => SmartDialog.show(
      maskColor: backgroundColorDark,
      backType: SmartBackType.block,
      builder: (context) => LoadingScreen(upscale: upscale, backgroundRemover: backgroundRemover),
    );

class LoadingScreen extends StatefulWidget {
  final bool upscale, backgroundRemover;
  const LoadingScreen({super.key, this.upscale = false, this.backgroundRemover = false});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final List<String> _imageGeneration = [
    "analyzing_prompt",
    "creating_your_idea",
    "generating_image",
  ];
  final List<String> _backgroundRemover = [
    "uploading_image",
    "analyzing_image",
    "removing_background",
  ];
  final List<String> _imageUpscale = [
    "uploading_image",
    "analyzing_image",
    "upscaling_image",
  ];
  List<String> get _loadingTexts => widget.upscale
      ? _imageUpscale
      : widget.backgroundRemover
          ? _backgroundRemover
          : _imageGeneration;

  static const stepDuration = Duration(seconds: 2); // Duration for each step

  int _currentStep = 0;
  double _progress = 0.0;
  bool _showCloseButton = false;

  Timer? _timer;
  Timer? _stepTimer;
  Timer? _closeButtonTimer;

  @override
  void initState() {
    super.initState();
    _startLoading();
  }

  void _startLoading() {
    // Timer for smooth progress animation
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        if (_progress < (_currentStep + 1) * (100 / _loadingTexts.length)) {
          _progress += 0.75;
        }
      });
    });

    // Timer for step changes
    _stepTimer = Timer.periodic(stepDuration, (timer) {
      setState(() {
        if (_currentStep < _loadingTexts.length - 1) {
          _currentStep++;
        } else {
          _timer?.cancel();
          _stepTimer?.cancel();
        }
      });
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
  void dispose() {
    _timer?.cancel();
    _stepTimer?.cancel();
    _closeButtonTimer?.cancel();
    super.dispose();
  }

  Widget _buildStepIndicator(int index) {
    final bool isCompleted = index < _currentStep;
    final bool isCurrent = index == _currentStep;

    return Padding(
      padding: EdgeInsets.only(top: spacingDefault),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isCompleted) ...[
            Icon(Iconsax.tick_circle, color: bodyLarge(context).color, size: 18.sp),
          ] else if (isCurrent) ...[
            SizedBox(
              width: 18.sp,
              height: 18.sp,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(bodyLarge(context).color!),
              ),
            ),
          ],
          SizedBox(width: spacingSmall),
          Text(
            _loadingTexts[index].tr,
            style: bodyMedium(context).copyWith(
              color: isCurrent || isCompleted
                  ? bodyLarge(context).color
                  : bodyLarge(context).color?.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          ParticlesFly(
            height: Get.height,
            width: Get.width,
            connectDots: true,
            numberOfParticles: 40,
            particleColor: primaryColor.withOpacity(0.1),
            lineColor: secondaryColor.withOpacity(0.1),
            speedOfParticles: 0.2,
            awayRadius: 100.sp,
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
                    borderRadius: BorderRadius.circular(spacingExtraLarge),
                  ),
                  visualDensity: const VisualDensity(horizontal: 1, vertical: -2),
                ),
                onPressed: _cancelApiCall,
                child: Text(
                  'cancel'.tr,
                  style: bodySmall(context).copyWith(color: primaryColor, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                baseColor: primaryColor,
                highlightColor: secondaryColor,
                period: const Duration(seconds: 4),
                child: Text(
                  'Loading',
                  style: displaySmall(context).copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 100.sp),
              TweenAnimationBuilder(
                tween: Tween(begin: 0.0, end: _progress / 100),
                duration: const Duration(milliseconds: 300),
                builder: (_, double value, __) {
                  return SizedBox(
                    width: 65.sp,
                    height: 65.sp,
                    child: CircularProgressIndicator(
                      value: value,
                      strokeWidth: 8,
                      valueColor: AlwaysStoppedAnimation<Color>(bodyLarge(context).color!),
                      backgroundColor: Colors.grey.withOpacity(0.3),
                    ),
                  );
                },
              ),
              SizedBox(height: spacingDefault),
              Text(
                '${_progress.toInt()}%',
                style: titleSmall(context).copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 100.sp),
              for (var i = 0; i < _loadingTexts.length; i++) _buildStepIndicator(i),
            ],
          ),
        ],
      ),
    );
  }
}
