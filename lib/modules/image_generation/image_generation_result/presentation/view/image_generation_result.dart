import 'package:matrix_ai/modules/image_generation/home/data/model/models_lab_response.dart';
import 'package:matrix_ai/imports.dart';
import 'package:matrix_ai/modules/image_generation/image_generation_result/presentation/controller/image_generation_result_controller.dart';
import 'package:matrix_ai/modules/image_generation/image_generation_result/presentation/view/widgets/model_info_widget.dart';
import 'package:matrix_ai/modules/image_generation/image_generation_result/presentation/view/widgets/regenerate.dart';
import '../../../../../core/widgets/glassmorphic_image.dart';
import '../../../../../features/ads/presentation/controller/ads_controller.dart';
import 'widgets/prompt_image.dart';
import 'widgets/prompt_option.dart';

class ImageGenerationResultScreen extends StatelessWidget {
  final ImageGenerationResult result;
  final bool favorites;
  const ImageGenerationResultScreen({super.key, required this.result, this.favorites = false});

  @override
  Widget build(BuildContext context) {
    ImageGenerationResultController.find.imageGenerationResult = result;
    return GetBuilder<ImageGenerationResultController>(builder: (controller) {
      ImageGenerationResult response = controller.imageGenerationResult ?? result;
      return GlassmorphicImage(
        url: result.output.first,
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        PromptImageWidget(response: response),
                        Padding(
                          padding: paddingDefault,
                          child: Column(
                            children: [
                              ModelInfoWidget(response: response),
                              const PromptOptionWidget(),
                              RegenerateButton(response: response),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  AdsController.find.buildModelScreenAd(),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
