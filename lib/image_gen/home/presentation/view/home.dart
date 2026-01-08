import 'package:pixart_app/imports.dart';
import '../../../history/presentation/controller/history_controller.dart';
import '../../../history/presentation/view/hisory_view.dart';
import '../../data/model/image_generation.dart';
import '../widgets/prompt_widget.dart';

class HomeScreen extends StatelessWidget {
  final Function()? onRegenerate;
  const HomeScreen({super.key, this.onRegenerate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GetBuilder<HistoryController>(
            builder: (historyController) {
              final List<ImageGenerationResult> promptHistory = historyController.promptHistory;
              return HistoryView(promptHistory: promptHistory);
            },
          ),
        ),
        PromptInputWidget(),
      ],
    );
  }
}
