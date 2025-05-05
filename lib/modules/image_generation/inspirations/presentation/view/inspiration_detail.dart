import 'package:matrix_ai/core/widgets/network_image.dart';
import '../../../../../core/helper/image_download.dart';
import '../../../../../core/widgets/glassmorphic_image.dart';
import '../../../../../core/widgets/gradient_widget.dart';
import '../../../../../features/dashboard/presentation/controller/dashboard_controller.dart';
import '../../../../../imports.dart';
import '../../../prompt_setting/presentation/controller/settings_controller.dart';
import '../../data/model/inspiration.dart';

class InspirationDetailScreen extends StatelessWidget {
  final Inspiration inspiration;
  const InspirationDetailScreen({super.key, required this.inspiration});

  @override
  Widget build(BuildContext context) {
    return GlassmorphicImage(
        url: inspiration.image,
        child: Column(
          children: [
            Expanded(
              child: AppBar(
                backgroundColor: Colors.transparent,
                leading: Padding(
                  padding: EdgeInsets.all(5.sp),
                  child: const GlassmorphicWidget(
                    glassOpacity: 0.2,
                    child: BackButton(color: Colors.white),
                  ),
                ),
                actions: [
                  GlassmorphicWidget(
                    glassOpacity: 0.2,
                    child: IconButton(
                      onPressed: () => DownloadImage.downloadImage(inspiration.image),
                      icon: const Icon(Iconsax.import_1, color: Colors.white),
                    ),
                  ),
                  SizedBox(width: spacingSmall),
                ],
              ),
            ),
            SizedBox(height: spacingDefault),
            CustomNetworkImage(url: inspiration.image),
            Expanded(
              child: Center(
                child: Padding(
                  padding: paddingLarge,
                  child: SizedBox(
                    width: 150.sp,
                    child: PrimaryButton(
                      text: 'try_now'.tr,
                      onPressed: () {
                        final settings = SettingsController.find;
                        pop();
                        DashboardController.find.selectedIndex = 0;
                        settings.configModel = settings.configModel.copyWith(seed: inspiration.seed);
                        settings.promptController.text = inspiration.prompt;
                        settings.seedController.text = inspiration.seed.toString();
                      },
                    ),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
