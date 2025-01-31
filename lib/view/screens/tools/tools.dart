import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/controller/background_remover_controller.dart';
import 'package:matrix_ai/controller/image_upscale_controller.dart';
import 'package:matrix_ai/utils/colors.dart';
import 'package:matrix_ai/utils/style.dart';
import '../../../controller/tools_controller.dart';
import '../../../helper/navigation.dart';
import '../upscale_image/upscale_image.dart';
import 'widgets/tools_grid.dart';

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
    return GetBuilder<ToolsController>(builder: (con) {
      return con.loading
          ? Center(
              child: SizedBox(width: 27.sp, height: 27.sp, child: const CircularProgressIndicator.adaptive()),
            )
          : ListView(
              padding: paddingDefault,
              children: [
                // Featured Tool Banner
                InkWell(
                  onTap: () => launchScreen(UpscaleImageScreen(tool: con.tools.last)),
                  child: Container(
                    height: 200.sp,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: borderRadiusDefault,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(con.tools.last.image),
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // shadow,
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: borderRadiusDefault,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: paddingDefault,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      con.tools.first.name,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: textColorDark,
                                          ),
                                    ),
                                    SizedBox(height: spacingSmall),
                                    Text(
                                      con.tools.first.description,
                                      style: bodyMedium(context).copyWith(
                                        color: textColorDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: spacingDefault),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: spacingDefault),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(spacingExtraLarge),
                                  gradient: secondaryGradient,
                                ),
                                child: Text(
                                  'try_now'.tr.toUpperCase(),
                                  style: labelLarge(context).copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: spacingExtraLarge),
                ToolsGridWidget(tools: con.tools),
              ],
            );
    });
  }
}
