import 'package:pixart_app/core/widgets/primary_image_grid.dart';
import 'package:pixart_app/features/home/data/model/image_generation.dart';
import 'package:pixart_app/features/home/presentation/controller/image_generation_controller.dart';
import '../../../../imports.dart';
import '../widgets/empty_history.dart';
import '../widgets/history_card.dart';
import '../widgets/loading_card.dart';

class GenerationsView extends StatelessWidget {
  final List<ImageGenerationResult> generations;
  const GenerationsView({super.key, required this.generations});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImageGenController>(
      builder: (imageGen) {
        return generations.isEmpty && imageGen.loading.isEmpty
            ? EmptyHistory()
            : PrimaryImageGrid(
                childAspectRatio: 1.1,
                itemCount: generations.length + imageGen.loading.length,
                itemBuilder: (context, index) {
                  if (index < imageGen.loading.length) {
                    return const LoadingCard();
                  }
                  return HistoryCard(response: generations[index - imageGen.loading.length]);
                },
              );
      },
    );
  }
}
