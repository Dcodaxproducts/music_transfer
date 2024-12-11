import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/controller/background_remover_controller.dart';
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
              padding: pagePadding,
              children: [
                // Featured Tool Banner
                InkWell(
                  onTap: () => launchScreen(UpscaleImageScreen(tool: con.tools.first)),
                  child: Container(
                    height: 200.sp,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: borderRadius,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(con.tools.first.image),
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // shadow,
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: borderRadius,
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
                          padding: pagePadding,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      con.tools.first.title,
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: textColordark,
                                          ),
                                    ),
                                    SizedBox(height: 8.sp),
                                    Text(
                                      con.tools.first.description,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: textColordark,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 16.sp),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 16.sp),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32.sp),
                                  gradient: secondaryGradient,
                                ),
                                child: Text(
                                  'try_now'.tr.toUpperCase(),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
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
                SizedBox(height: 32.sp),
                ToolsGridWidget(tools: con.tools)
              ],
            );
    });
  }
}
