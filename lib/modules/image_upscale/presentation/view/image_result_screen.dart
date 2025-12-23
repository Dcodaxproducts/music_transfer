import 'package:pixart_app/imports.dart';
import 'package:pixart_app/modules/image_upscale/presentation/controller/image_upscale_controller.dart';
import 'package:pixart_app/modules/image_upscale/presentation/widgets/bottom_actions.dart';
import '../../data/model/upscale_result.dart';

class UpscaleResultScreen extends StatefulWidget {
  final UpscaleResult response;
  UpscaleResultScreen({super.key, required this.response}) {
    ImageUpscaleController.find.result = response;
  }

  @override
  State<UpscaleResultScreen> createState() => _UpscaleResultScreenState();
}

class _UpscaleResultScreenState extends State<UpscaleResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: PrimaryBackButton(),
        title: Text('Preview'),
        actions: [
          SaveButton(url: widget.response.image),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16.sp),
          Expanded(
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: Hero(
                tag: widget.response.image,
                child: PhotoView(
                  backgroundDecoration: const BoxDecoration(color: Colors.black),
                  imageProvider: CachedNetworkImageProvider(widget.response.image),
                  errorBuilder: (context, error, stackTrace) {
                    return Center(child: Icon(Iconsax.image, size: 50.sp));
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 16.sp),
          UpscaleActions(),
          SafeArea(child: SizedBox(height: 8.sp)),
        ],
      ),
    );
  }
}
