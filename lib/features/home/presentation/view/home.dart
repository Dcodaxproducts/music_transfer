import 'package:matrix_ai/imports.dart';
import 'package:matrix_ai/features/models/presentation/controller/models_controller.dart';
import 'package:matrix_ai/features/prompt_setting/presentation/controller/settings_controller.dart';
import 'package:matrix_ai/features/home/presentation/view/widgets/models_view.dart';
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
            padding: paddingDefault.copyWith(top: spacingExtraSmall),
            children: [
              PromptWidget(con: con),
              const ModelsView(),
              const PromptSettingsWidget(),
              Padding(
                padding: EdgeInsets.only(top: spacingExtraLarge),
                child: PrimaryButton(
                  text: (onRegenerate != null ? 'recreate' : 'create').tr,
                  icon: Icon(Iconsax.magicpen, size: 18.sp, color: context.theme.scaffoldBackgroundColor),
                  color: bodyLarge(context).color,
                  textColor: context.theme.scaffoldBackgroundColor,
                  onPressed: onRegenerate ?? () => ImageGenerationHelper.handleTap(_handleImageGeneration),
                ),
              ),
              const FreeGenerationLeftWidget(),
              if (onRegenerate == null) ...[
                const HistoryView(),
                SizedBox(height: 80.sp),
              ]
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
