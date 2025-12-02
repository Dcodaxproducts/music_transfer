import 'package:pixart_app/modules/upscale/image_upscale/presentation/controller/image_upscale_controller.dart';
import '../../../../imports.dart';
import '../../../../modules/bg_removal/background_remover/presentation/controller/background_remover_controller.dart';
import '../../data/model/tools.dart';
import '../controller/tools_controller.dart';
import '../../../../modules/upscale/image_upscale/presentation/view/upscale_image.dart';

class ToolScreen extends StatefulWidget {
  const ToolScreen({super.key});

  @override
  State<ToolScreen> createState() => _ToolScreenState();
}

class _ToolScreenState extends State<ToolScreen> {
  @override
  void initState() {
    BackgroundRemoverController.find.getHistoryFromPrefs();
    ImageUpscaleController.find.getHistoryFromPrefs();
    ToolsController.find.getTools();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ToolsController>(
      builder: (con) {
        return con.loading
            ? Center(
                child: SizedBox(
                  width: 27.sp,
                  height: 27.sp,
                  child: const CircularProgressIndicator.adaptive(),
                ),
              )
            : ListView.separated(
                padding: AppPadding.padding16,
                itemCount: con.tools.length,
                separatorBuilder: (context, index) => SizedBox(height: 16.sp),
                itemBuilder: (context, index) {
                  final tool = con.tools[index];
                  return ToolCard(tool: tool);
                },
              );
      },
    );
  }
}

class ToolCard extends StatelessWidget {
  final ToolModel tool;
  const ToolCard({super.key, required this.tool});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchScreen(UpscaleImageScreen(tool: tool)),
      borderRadius: AppRadius.circular16,
      child: Container(
        height: 230.sp,
        decoration: BoxDecoration(borderRadius: AppRadius.circular16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(borderRadius: AppRadius.circular16, child: tool.animation),
            Align(
              alignment: Alignment.bottomCenter,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(bottom: AppRadius.circular16.bottomLeft),
                ),
                child: Container(
                  padding: EdgeInsets.all(12.sp),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.6),
                    borderRadius: BorderRadius.vertical(bottom: AppRadius.circular16.bottomLeft),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(tool.name.tr, style: context.font14.copyWith(fontWeight: FontWeight.w600)),
                            SizedBox(height: 8.sp),
                            Text(tool.description.tr, style: context.font12),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.sp),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20.sp),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
