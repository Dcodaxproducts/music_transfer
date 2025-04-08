import '../../../../prompt_setting/presentation/controller/settings_controller.dart';
import '../../../../home/data/model/models_lab_response.dart';
import '../../../../home/domain/helper/image_generation_helper.dart';
import '../../../../../imports.dart';
import '../../../../home/presentation/view/home.dart';

class RegenerateButton extends StatelessWidget {
  final ImageGenerationResult response;
  const RegenerateButton({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Padding(
        padding: EdgeInsets.only(top: spacingExtraLarge, bottom: spacingDefault),
        child: SizedBox(
          width: double.infinity,
          child: PrimaryButton(
            gradient: true,
            text: 'recreate'.tr,
            icon: Icon(Iconsax.magicpen, size: 18.sp, color: Colors.white),
            textColor: Colors.white,
            onPressed: () {
              SettingsController.find.promptController.text = response.meta.prompt;
              Get.bottomSheet(
                Container(
                  margin: EdgeInsets.only(top: 200.sp),
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(spacingDefault),
                    ),
                  ),
                  child: HomeScreen(
                    onRegenerate: () => ImageGenerationHelper.handleTap(_handleImageGeneration),
                  ),
                ),
                isScrollControlled: true,
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _handleImageGeneration(String text) async {
    await ImageGenerationHelper.handleImageGeneration(text, generateImage: _generateImage);
  }

  void _generateImage(String text, {bool showAds = true}) {
    ImageGenerationHelper.generateImage(text, showAds: showAds, seed: response.meta.seed);
  }
}
