import 'package:pixart_app/core/widgets/primary_image_grid.dart';
import 'package:pixart_app/features/ads/presentation/controller/ads_controller.dart';
import 'package:pixart_app/image_gen/history/presentation/controller/history_controller.dart';
import 'package:pixart_app/image_gen/home/data/model/image_generation.dart';
import 'package:pixart_app/image_gen/home/presentation/controller/image_generation_controller.dart';
import '../../../../imports.dart';
import '../widgets/empty_history.dart';
import '../widgets/history_card.dart';
import '../widgets/loading_card.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: PrimaryBackButton(), title: Text('history'.tr)),
      body: GetBuilder<HistoryController>(
        builder: (controller) {
          final List<ImageGenerationResult> promptHistory = controller.promptHistory;
          return GetBuilder<ImageGenController>(
            builder: (imageGen) {
              return promptHistory.isEmpty && imageGen.loading.isEmpty
                  ? EmptyHistory()
                  : PrimaryImageGrid(
                      itemCount: promptHistory.length + imageGen.loading.length,
                      itemBuilder: (context, index) {
                        if (index < imageGen.loading.length) {
                          return const LoadingCard();
                        }
                        return HistoryCard(response: promptHistory[index - imageGen.loading.length]);
                      },
                    );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(child: AdsController.find.buildHistoryScreenAd()),
    );
  }
}
