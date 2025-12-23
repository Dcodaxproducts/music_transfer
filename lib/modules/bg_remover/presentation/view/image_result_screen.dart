import 'package:pixart_app/imports.dart';
import 'package:pixart_app/modules/bg_remover/data/model/bg_remover_result.dart';
import '../controller/background_remover_controller.dart';
import '../widgets/bottom_actions.dart';

class BgRemoverResultScreen extends StatefulWidget {
  final BgRemoverResult response;
  BgRemoverResultScreen({super.key, required this.response}) {
    BgRemoverController.find.result = response;
  }

  @override
  State<BgRemoverResultScreen> createState() => _BgRemoverResultScreenState();
}

class _BgRemoverResultScreenState extends State<BgRemoverResultScreen> {
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
          BgRemoverActions(),
          SafeArea(child: SizedBox(height: 8.sp)),
        ],
      ),
    );
  }
}
