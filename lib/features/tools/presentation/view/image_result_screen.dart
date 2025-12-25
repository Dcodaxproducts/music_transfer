import 'package:pixart_app/imports.dart';
import '../controller/tools_controller.dart';
import '../widgets/bottom_actions.dart';

class ToolResultScreen extends StatefulWidget {
  final ToolResult response;
  ToolResultScreen({super.key, required this.response}) {
    ToolsController.find.result = response;
  }

  @override
  State<ToolResultScreen> createState() => _ToolResultScreenState();
}

class _ToolResultScreenState extends State<ToolResultScreen> {
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
                  backgroundDecoration: BoxDecoration(color: context.theme.scaffoldBackgroundColor),
                  imageProvider: CachedNetworkImageProvider(widget.response.image),
                  errorBuilder: (context, error, stackTrace) {
                    return Center(child: Icon(Iconsax.image, size: 50.sp));
                  },
                  loadingBuilder: (context, event) {
                    return Center(
                      child: SizedBox(
                        width: 27.sp,
                        height: 27.sp,
                        child: CircularProgressIndicator(
                          value: event == null || event.expectedTotalBytes == null
                              ? null
                              : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                          color: context.theme.primaryColor,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 16.sp),
          ToolResultActions(),
          SafeArea(child: SizedBox(height: 8.sp)),
        ],
      ),
    );
  }
}
