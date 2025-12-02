import 'dart:async';
import 'package:pixart_app/core/widgets/loading.dart';
import 'package:pixart_app/imports.dart';
import '../../../../../../features/dashboard/presentation/controller/dashboard_controller.dart';
import '../../../../prompt_setting/presentation/controller/settings_controller.dart';
import '../../../data/model/inspiration.dart';

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
                    borderRadius: AppRadius.circular16,
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: AppRadius.circular16,
                        child: Image.network(widget.inspiration.image, fit: BoxFit.cover),
                      ),

                      // close button
                      Positioned(
                        top: 10.sp,
                        right: 10.sp,
                        child: InkWell(
                          onTap: pop,
                          child: Container(
                            padding: EdgeInsets.all(5.sp),
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                            child: Icon(Icons.close, size: 20.sp, color: Colors.black),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(bottom: AppRadius.circular16.bottomLeft),
                          ),
                          child: InkWell(
                            onTap: () {
                              final settings = SettingsController.find;
                              pop();
                              DashboardController.find.selectedIndex = 0;
                              settings.configModel = settings.configModel.copyWith(
                                seed: widget.inspiration.seed,
                              );
                              settings.promptController.text = widget.inspiration.prompt;
                              settings.seedController.text = widget.inspiration.seed.toString();
                            },
                            borderRadius: BorderRadius.vertical(bottom: AppRadius.circular16.bottomLeft),
                            child: Container(
                              padding: AppPadding.padding16,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor.withOpacity(0.6),
                                borderRadius: BorderRadius.vertical(bottom: AppRadius.circular16.bottomLeft),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'try_now'.tr,
                                      style: context.font14.copyWith(fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(width: 8.sp),
                                  Icon(Iconsax.arrow_right_3, color: Colors.white, size: 20.sp),
                                ],
                              ),
                            ),
                          ),
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
              decoration: BoxDecoration(color: context.theme.cardColor, borderRadius: AppRadius.circular16),
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
    image.image
        .resolve(const ImageConfiguration())
        .addListener(
          ImageStreamListener((ImageInfo info, bool _) {
            completer.complete(Size(info.image.width.toDouble(), info.image.height.toDouble()));
          }),
        );
    return completer.future;
  }
}
