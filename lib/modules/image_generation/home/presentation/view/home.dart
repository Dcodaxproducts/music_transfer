import 'package:pixart_app/core/widgets/gradient_widget.dart';
import 'package:pixart_app/imports.dart';
import 'package:pixart_app/modules/image_generation/models/presentation/controller/models_controller.dart';
import 'package:pixart_app/modules/image_generation/prompt_setting/presentation/controller/settings_controller.dart';
import 'package:pixart_app/modules/image_generation/home/presentation/view/widgets/models_view.dart';
import '../../domain/helper/image_generation_helper.dart';
import 'widgets/free_generations.dart';
import 'widgets/history_view.dart';
import 'widgets/prompt_options.dart';
import 'widgets/prompt_widget.dart';

class HomeScreen extends StatelessWidget {
  final Function()? onRegenerate;
  const HomeScreen({super.key, this.onRegenerate});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (con) {
        return RefreshIndicator.adaptive(
          onRefresh: ModelsController.find.getModels,
          child: ListView(
            padding: AppPadding.padding16.copyWith(top: 4.sp),
            children: [
              PromptWidget(con: con),
              const ModelsView(),
              const PromptSettingsWidget(),
              Padding(
                padding: EdgeInsets.only(top: 24.sp),
                child: GradientButton(
                  text: (onRegenerate != null ? 'recreate' : 'create').tr,
                  icon: GradientWidget(
                    child: Icon(Iconsax.magicpen, size: 18.sp, color: Colors.white),
                  ),
                  onPressed: onRegenerate ?? () => ImageGenerationHelper.handleTap(_handleImageGeneration),
                ),
              ),
              const FreeGenerationLeftWidget(),
              if (onRegenerate == null) ...[const HistoryView(), SizedBox(height: 80.sp)],
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleImageGeneration(String text) async {
    await ImageGenerationHelper.handleImageGeneration(text, generateImage: _generateImage);
  }

  void _generateImage(String text, {bool showAds = true}) {
    ImageGenerationHelper.generateImage(text, showAds: showAds);
  }
}
