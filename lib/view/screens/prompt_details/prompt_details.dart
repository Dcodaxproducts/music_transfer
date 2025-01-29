import 'package:matrix_ai/controller/image_generation_controller.dart';
import 'package:matrix_ai/data/model/response/models_lab_response.dart';
import 'package:matrix_ai/imports.dart';
import 'package:matrix_ai/view/screens/prompt_details/widgets/regenerate.dart';
import '../../../controller/ads_controller.dart';
import '../../../controller/history_controller.dart';
import 'widgets/model_info_widget.dart';
import 'widgets/prompt_image.dart';
import 'widgets/prompt_option.dart';

class PromptDetailScreen extends StatelessWidget {
  final PromptResponse response;
  final bool favorites;
  const PromptDetailScreen({super.key, required this.response, this.favorites = false});

  @override
  Widget build(BuildContext context) {
    final historyController = HistoryController.find;

    // Fetch filtered history and calculate initial index
    final history = historyController.getFilteredHistory(favorites: favorites);

    // Get initial index
    final initialIndex = historyController.getInitialIndex(response, favorites: favorites);

    // Create page controller
    final pageController = PageController(initialPage: initialIndex);

    return Scaffold(
      body: PageView.builder(
        controller: pageController,
        itemCount: history.length,
        itemBuilder: (context, index) {
          final currentResponse = history[index];
          ImageGenerationController.find.promptResponse = currentResponse;
          return GetBuilder<ImageGenerationController>(
            builder: (controller) {
              final result = controller.promptResponse;
              return Visibility(
                visible: result != null,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          PromptImageWidget(response: currentResponse),
                          Padding(
                            padding: paddingDefault,
                            child: Column(
                              children: [
                                ModelInfoWidget(response: currentResponse),
                                const PromptOptionWidget(),
                                RegenerateButton(response: currentResponse),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    AdsController.find.showModelScreenAd(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
