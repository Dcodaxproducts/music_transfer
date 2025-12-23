import 'package:pixart_app/modules/image_upscale/data/model/upscale_result.dart';
import 'package:pixart_app/modules/image_upscale/presentation/controller/image_upscale_controller.dart';
import '../../../../../imports.dart';

class DeleteUpscaleSheet extends StatelessWidget {
  final UpscaleResult result;
  final bool closeScreen;
  const DeleteUpscaleSheet({super.key, required this.result, this.closeScreen = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.bottomSheetTheme.backgroundColor,
        borderRadius: AppRadius.top(16),
      ),
      child: Stack(
        children: [
          Positioned(right: 16.sp, top: 16.sp, child: PrimaryCloseButton()),
          Padding(
            padding: AppPadding.padding16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Transform.rotate(
                        angle: -0.05, // Small tilt angle in radians (~3 degrees)
                        child: Container(
                          padding: AppPadding.padding4,
                          decoration: BoxDecoration(
                            color: context.theme.canvasColor,
                            borderRadius: AppRadius.circular16,
                          ),
                          child: ClipRRect(
                            borderRadius: AppRadius.circular12,
                            child: CachedNetworkImage(
                              imageUrl: result.image,
                              width: 70.sp,
                              height: 100.sp,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  Center(child: Icon(Iconsax.image, size: 30.sp)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // delete icon,
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: AppPadding.padding4,
                        decoration: BoxDecoration(
                          color: context.theme.bottomSheetTheme.backgroundColor,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          padding: AppPadding.padding8,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: errorColor),
                          child: Icon(Iconsax.trash, size: 16.sp, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.sp),
                Text(
                  'delete_prompt'.tr,
                  style: context.font20.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12.sp),
                Text('delete_prompt_message'.tr, style: context.font14, textAlign: TextAlign.center),

                SizedBox(height: 32.sp),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: 'Delete',
                    color: errorColor,
                    onPressed: () {
                      ImageUpscaleController.find.removeFromHistory(result);
                      Get.back(); // Close the bottom sheet
                      if (closeScreen) Get.back(); // Go back to the previous screen
                    },
                  ),
                ),
                SizedBox(height: 12.sp),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(text: 'Cancel', color: context.theme.canvasColor, onPressed: Get.back),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
