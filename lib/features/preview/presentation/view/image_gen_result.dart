import 'package:pixart_app/features/home/data/model/image_generation.dart';
import 'package:pixart_app/imports.dart';
import '../../../ads/presentation/controller/ads_controller.dart';
import '../../../home/presentation/controller/image_generation_controller.dart';
import '../widgets/bottom_actions.dart';

class PreviewScreen extends StatelessWidget {
  final ImageGenerationResult result;
  PreviewScreen({super.key, required this.result}) {
    ImageGenController.find.result = result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const PrimaryBackButton(),
        title: Text("preview".tr),
        actions: [
          SaveButton(url: ImageGenController.find.result!.output.first),
          const SizedBox(width: 8),
        ],
      ),
      body: GetBuilder<ImageGenController>(
        builder: (controller) {
          ImageGenerationResult response = controller.result ?? result;
          return Column(
            children: [
              SizedBox(height: 16.sp),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Hero(
                    tag: response.output.first,
                    child: PhotoView(
                      backgroundDecoration: BoxDecoration(color: context.theme.scaffoldBackgroundColor),
                      imageProvider: CachedNetworkImageProvider(response.output.first),
                      errorBuilder: (context, error, stackTrace) {
                        return Center(child: Icon(Iconsax.image, size: 50.sp));
                      },
                    ),
                  ),
                ),
              ),
              const BottomActions(),
              AdsController.find.buildModelScreenAd(),
            ],
          );
        },
      ),
    );
  }
}
