import 'package:matrix_ai/imports.dart';
import 'package:matrix_ai/features/models/presentation/controller/models_controller.dart';
import 'package:matrix_ai/features/settings/presentation/controller/settings_controller.dart';
import 'package:matrix_ai/features/subscription/presentation/controller/subscription_controller.dart';
import 'package:matrix_ai/features/home/presentation/view/widgets/models_view.dart';
import 'package:matrix_ai/features/loading_screen/presentation/view/src/loading_manager.dart';
import '../controller/generation_controller.dart';
import '../../domain/helper/image_generation_helper.dart';
import 'widgets/history_view.dart';
import 'widgets/prompt_options.dart';
import 'widgets/prompt_widget.dart';

class HomeScreen extends StatefulWidget {
  final Function()? onRegenerate;
  const HomeScreen({super.key, this.onRegenerate});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (con) {
        return RefreshIndicator.adaptive(
          onRefresh: () async {
            ModelsController.find.getModels();
          },
          child: ListView(
            padding: paddingDefault.copyWith(top: spacingExtraSmall),
            children: [
              PromptWidget(con: con),
              const ModelsView(),
              const PromptSettingsWidget(),
              Padding(
                padding: EdgeInsets.only(top: spacingExtraLarge),
                child: PrimaryButton(
                  text: (widget.onRegenerate != null ? 'recreate' : 'create').tr,
                  icon: Icon(Iconsax.magicpen, size: 18.sp, color: context.theme.scaffoldBackgroundColor),
                  color: bodyLarge(context).color,
                  textColor: context.theme.scaffoldBackgroundColor,
                  onPressed:
                      widget.onRegenerate ?? () => ImageGenerationHelper.handleTap(_handleImageGeneration),
                ),
              ),
              const FreeGenerationLeftWidget(),
              if (widget.onRegenerate == null) ...[
                const HistoryView(),
                SizedBox(height: 80.sp),
              ]
            ],
          ),
        );
      },
    );
  }

  void testNormalCase() {
    LoadingManager.show();
    Future.delayed(const Duration(seconds: 2), () {
      LoadingManager.updateProgress(1);
      Future.delayed(const Duration(seconds: 2), () {
        LoadingManager.updateProgress(2);
        Future.delayed(const Duration(seconds: 2), () {
          LoadingManager.updateProgress(3);
          Future.delayed(const Duration(seconds: 2), () {
            LoadingManager.dismiss(); // Simulate completion of the process
          });
        });
      });
    });
  }

  void testCompleteCase() {
    LoadingManager.show();
    Future.delayed(const Duration(seconds: 2), () {
      LoadingManager.updateProgress(1);
      Future.delayed(const Duration(seconds: 2), () {
        LoadingManager.updateProgress(2);
        Future.delayed(const Duration(seconds: 2), () {
          LoadingManager.updateProgress(3);
          Future.delayed(const Duration(seconds: 1), () {
            LoadingManager.complete(); // Trigger complete method
          });
        });
      });
    });
  }

  void testErrorCase() {
    LoadingManager.show();
    Future.delayed(const Duration(seconds: 2), () {
      LoadingManager.updateProgress(1);
      Future.delayed(const Duration(seconds: 2), () {
        LoadingManager.updateProgress(2);
        Future.delayed(const Duration(seconds: 2), () {
          LoadingManager.updateProgress(3);
          Future.delayed(const Duration(seconds: 1), () {
            LoadingManager.error(); // Trigger error method
          });
        });
      });
    });
  }

  Future<void> _handleImageGeneration(String text) async {
    await ImageGenerationHelper.handleImageGeneration(text, generateImage: _generateImage);
  }

  void _generateImage(String text, {bool showAds = true}) {
    ImageGenerationHelper.generateImage(text, showAds: showAds);
  }
}

class FreeGenerationLeftWidget extends StatelessWidget {
  const FreeGenerationLeftWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (settingCon) {
        return GetBuilder<GenerationController>(
          builder: (con) => Visibility(
            visible: settingCon.settingModel.freeGenerations > 0 && !isPro,
            child: Padding(
              padding: EdgeInsets.only(top: spacingSmall),
              child: Center(
                child: Text(
                  "${(settingCon.settingModel.freeGenerations - GenerationController.find.dailyGenerationCount)} ${'free_generations_are_left_for_today'.tr}",
                  style: bodySmall(context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
