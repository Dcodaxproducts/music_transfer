import 'package:pixart_app/modules/image_generation/home/data/model/image_generation.dart';
import 'package:pixart_app/imports.dart';
import '../../../../../features/ads/presentation/controller/ads_controller.dart';
import '../../../home/presentation/controller/image_generation_controller.dart';
import '../widgets/bottom_actions.dart';

class PreviewScreen extends StatelessWidget {
  final ImageGenerationResult result;
  final bool favorites;
  PreviewScreen({super.key, required this.result, this.favorites = false}) {
    ImageGenerationController.find.result = result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: PrimaryBackButton(),
        title: Text('Preview'),
        actions: [
          SaveButton(url: ImageGenerationController.find.result!.output.first),
          SizedBox(width: 8),
        ],
      ),
      body: GetBuilder<ImageGenerationController>(
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
                      backgroundDecoration: const BoxDecoration(color: Colors.black),
                      imageProvider: CachedNetworkImageProvider(response.output.first),
                      errorBuilder: (context, error, stackTrace) {
                        return Center(child: Icon(Iconsax.image, size: 50.sp));
                      },
                    ),
                  ),
                ),
              ),
              BottomActions(),
              AdsController.find.buildModelScreenAd(),
            ],
          );
        },
      ),
    );
  }
}
