import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/core/widgets/gradient_widget.dart';
import 'package:matrix_ai/modules/upscale/image_upscale/presentation/controller/image_upscale_controller.dart';
import 'package:matrix_ai/core/utils/style.dart';
import '../../../../modules/bg_removal/background_remover/presentation/controller/background_remover_controller.dart';
import '../../data/model/tools.dart';
import '../controller/tools_controller.dart';
import '../../../../core/helper/navigation.dart';
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
                padding: paddingDefault,
                itemCount: con.tools.length,
                separatorBuilder: (context, index) => SizedBox(height: spacingDefault),
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
      borderRadius: borderRadiusDefault,
      child: Container(
        height: 230.sp,
        decoration: BoxDecoration(borderRadius: borderRadiusDefault),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(borderRadius: borderRadiusDefault, child: tool.animation),
            Align(
              alignment: Alignment.bottomCenter,
              child: GlassmorphicWidget(
                borderRadius: BorderRadius.vertical(bottom: borderRadiusDefault.bottomLeft),
                child: Container(
                  padding: EdgeInsets.all(spacingMedium),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor.withOpacity(0.6),
                    borderRadius: BorderRadius.vertical(bottom: borderRadiusDefault.bottomLeft),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              tool.name.tr,
                              style: bodyMedium(context).copyWith(fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: spacingSmall),
                            Text(tool.description.tr, style: bodySmall(context)),
                          ],
                        ),
                      ),
                      SizedBox(width: spacingSmall),
                      Icon(Icons.arrow_forward, color: Colors.white, size: 20.sp),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
