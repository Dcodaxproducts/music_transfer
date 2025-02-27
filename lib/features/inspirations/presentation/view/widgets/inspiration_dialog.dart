import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:matrix_ai/core/utils/style.dart';
import 'package:matrix_ai/core/widgets/loading.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../dashboard/presentation/controller/dashboard_controller.dart';
import '../../../../settings/presentation/controller/settings_controller.dart';
import '../../../data/model/inspiration.dart';
import '../../../../../core/helper/navigation.dart';

class InspirationDialog extends StatefulWidget {
  final Inspiration inspiration;
  const InspirationDialog({required this.inspiration, super.key});

  @override
  InspirationDialogState createState() => InspirationDialogState();
}

class InspirationDialogState extends State<InspirationDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  final double _initialHeight = 0.5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: context.width * 0.1),
      child: FutureBuilder(
        future: _getImageSize(widget.inspiration.image),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            final imageSize = snapshot.data as Size;
            _heightAnimation = Tween<double>(
              begin: context.height * _initialHeight,
              end: context.width * (imageSize.height / imageSize.width),
            ).animate(_controller);

            _controller.forward();

            return AnimatedBuilder(
              animation: _heightAnimation,
              builder: (context, child) {
                return Container(
                  height: _heightAnimation.value,
                  decoration: BoxDecoration(
                    color: context.theme.scaffoldBackgroundColor,
                    borderRadius: borderRadiusDefault,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: borderRadiusDefault,
                        child: Image.network(
                          widget.inspiration.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // shadow,
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: borderRadiusDefault,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(1),
                            ],
                          ),
                        ),
                      ),
                      // close button
                      Positioned(
                        top: 10.sp,
                        right: 10.sp,
                        child: InkWell(
                          onTap: pop,
                          child: Container(
                            padding: EdgeInsets.all(5.sp),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(Icons.close, size: 20.sp, color: Colors.black),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: spacingMedium),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SingleChildScrollView(
                              child: Text(
                                widget.inspiration.prompt,
                                textAlign: TextAlign.center,
                                maxLines: 5,
                                style: bodySmall(context).copyWith(color: Colors.white),
                              ),
                            ),
                            SizedBox(height: spacingDefault),
                            SizedBox(
                              height: 50.sp,
                              width: 120.sp,
                              child: PrimaryButton(
                                text: 'try_now'.tr,
                                onPressed: () {
                                  final settings = SettingsController.find;
                                  pop();
                                  DashboardController.find.selectedIndex = 0;
                                  settings.configModel =
                                      settings.configModel.copyWith(seed: widget.inspiration.seed);
                                  settings.promptController.text = widget.inspiration.prompt;
                                  settings.seedController.text = widget.inspiration.seed.toString();
                                },
                              ),
                            ),
                            SizedBox(height: spacingDefault),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Container(
              height: context.height * _initialHeight,
              decoration: BoxDecoration(
                color: context.theme.cardColor,
                borderRadius: borderRadiusDefault,
              ),
              child: const Center(child: Loading()),
            );
          }
        },
      ),
    );
  }

  Future<Size> _getImageSize(String imageUrl) async {
    final Completer<Size> completer = Completer();
    final Image image = Image.network(imageUrl);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(info.image.width.toDouble(), info.image.height.toDouble()));
      }),
    );
    return completer.future;
  }
}
