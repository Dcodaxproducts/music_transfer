import 'package:pixart_app/imports.dart';
import 'package:pixart_app/image_generation/prompt_setting/presentation/controller/settings_controller.dart';
import '../../../history/presentation/controller/history_controller.dart';
import '../../../history/presentation/widgets/hisory_list.dart';
import '../../data/model/image_generation.dart';
import '../widgets/prompt_widget.dart';

class HomeScreen extends StatelessWidget {
  final Function()? onRegenerate;
  const HomeScreen({super.key, this.onRegenerate});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
      builder: (con) {
        return Column(
          children: [
            Expanded(
              child: GetBuilder<HistoryController>(
                builder: (historyController) {
                  final List<ImageGenerationResult> promptHistory = historyController.promptHistory;
                  return HistoryList(promptHistory: promptHistory);
                },
              ),
            ),
            PromptInputWidget(con: con),
          ],
        );
      },
    );
  }
}
