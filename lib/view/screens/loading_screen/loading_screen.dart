import 'dart:async';
import 'package:matrix_ai/controller/image_generation_controller.dart';
import 'package:matrix_ai/imports.dart';
import 'package:particles_fly/particles_fly.dart';
import 'package:shimmer/shimmer.dart';
import 'src/loading_manager.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _showCloseButton = false;
  Timer? _closeButtonTimer;

  @override
  void initState() {
    super.initState();
    // Timer for showing the close button after 15 seconds
    _closeButtonTimer = Timer(const Duration(seconds: 15), () {
      setState(() {
        _showCloseButton = true;
      });
    });
  }

  @override
  void dispose() {
    _closeButtonTimer?.cancel();
    super.dispose();
  }

  void _cancelApiCall() {
    ImageGenerationController.find.cancelRequest();
    LoadingManager.dismiss();
  }

  Widget _buildStepIndicator(int index) {
    return Obx(() {
      final bool isCompleted = index < LoadingManager().currentStep.value;
      final bool isCurrent =
          index == LoadingManager().currentStep.value && index < LoadingManager().loadingTexts.length;

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
              LoadingManager().loadingTexts[index].tr,
              style: bodyMedium(context).copyWith(
                color: isCurrent || isCompleted
                    ? bodyLarge(context).color
                    : bodyLarge(context).color?.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildCompletedStep() {
    return Padding(
      padding: EdgeInsets.only(top: spacingDefault),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.tick_circle, color: Colors.green, size: 18.sp),
          SizedBox(width: spacingSmall),
          Text(
            'Completed'.tr, // Localized string for completion
            style: bodyMedium(context).copyWith(color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorStep() {
    return Padding(
      padding: EdgeInsets.only(top: spacingDefault),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.warning_2, color: Colors.red, size: 18.sp),
          SizedBox(width: spacingSmall),
          Text(
            'Error'.tr, // Localized string for error
            style: bodyMedium(context).copyWith(color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildQueuedStep() {
    return Padding(
      padding: EdgeInsets.only(top: spacingDefault),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.tick_circle, color: Colors.orange, size: 18.sp),
          SizedBox(width: spacingSmall),
          Text(
            'In Queue'.tr, // Localized string for completion
            style: bodyMedium(context).copyWith(color: Colors.orange, fontWeight: FontWeight.bold),
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
              Obx(() {
                return TweenAnimationBuilder(
                  tween: Tween(begin: 0.0, end: LoadingManager().progress.value / 100),
                  duration: const Duration(milliseconds: 500), // Duration for smooth animation
                  builder: (_, double value, __) {
                    return Column(
                      children: [
                        SizedBox(
                          width: 65.sp,
                          height: 65.sp,
                          child: CircularProgressIndicator(
                            value: value,
                            strokeWidth: 8,
                            valueColor: AlwaysStoppedAnimation<Color>(bodyLarge(context).color!),
                            backgroundColor: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        SizedBox(height: spacingDefault),
                        Text(
                          '${(value * 100).toInt()}%', // Show the percentage as it animates
                          style: titleSmall(context).copyWith(fontWeight: FontWeight.bold),
                        )
                      ],
                    );
                  },
                );
              }),
              SizedBox(height: 100.sp),
              // Display the steps with the completion/error state
              for (var i = 0; i < LoadingManager().loadingTexts.length; i++) _buildStepIndicator(i),
              Obx(() {
                if (LoadingManager().isCompleted.value) {
                  return _buildCompletedStep();
                } else if (LoadingManager().isError.value) {
                  return _buildErrorStep();
                } else if (LoadingManager().isQueued.value) {
                  return _buildQueuedStep();
                }
                return const SizedBox.shrink(); // No extra UI if still loading
              }),
            ],
          ),
        ],
      ),
    );
  }
}
