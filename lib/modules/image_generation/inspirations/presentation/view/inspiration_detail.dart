import 'package:pixart_app/core/widgets/network_image.dart';
import '../../../../../core/helper/image_download.dart';
import '../../../../../core/widgets/glassmorphic_image.dart';
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
                child: DecoratedBox(
                  decoration: BoxDecoration(borderRadius: AppRadius.circular32),
                  child: BackButton(color: Colors.white),
                ),
              ),
              actions: [
                DecoratedBox(
                  decoration: BoxDecoration(borderRadius: AppRadius.circular16),
                  child: IconButton(
                    onPressed: () => DownloadImage.downloadImage(inspiration.image),
                    icon: const Icon(Iconsax.import_1, color: Colors.white),
                  ),
                ),
                SizedBox(width: 8.sp),
              ],
            ),
          ),
          SizedBox(height: 16.sp),
          CustomNetworkImage(url: inspiration.image),
          Expanded(
            child: Center(
              child: Padding(
                padding: AppPadding.padding24,
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
          ),
        ],
      ),
    );
  }
}
