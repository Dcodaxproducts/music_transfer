import 'package:pixart_app/modules/bg_remover/presentation/view/bg_remover_history.dart';
import 'package:pixart_app/modules/image_upscale/presentation/controller/image_upscale_controller.dart';
import 'package:pixart_app/modules/image_upscale/presentation/view/upscale_history.dart';
import '../../../../imports.dart';
import '../../../../modules/bg_remover/presentation/controller/background_remover_controller.dart';
import '../controller/tools_controller.dart';
import '../widgets/tools_grid.dart';

class ToolScreen extends StatefulWidget {
  const ToolScreen({super.key});

  @override
  State<ToolScreen> createState() => _ToolScreenState();
}

class _ToolScreenState extends State<ToolScreen> {
  @override
  void initState() {
    BgRemoverController.find.getHistoryFromPrefs();
    ImageUpscaleController.find.getHistoryFromPrefs();
    ToolsController.find.getTools();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: AppPadding.screenPadding,
      children: [
        ToolsGrid(),
        UpscaleHistoryList(),
        BgRemoverHistoryList(),
        SafeArea(child: SizedBox(height: 60.sp)),
      ],
    );
  }
}
