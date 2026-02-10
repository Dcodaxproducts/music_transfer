import '../../../../imports.dart';
import '../../data/model/inspiration.dart';
import '../widgets/bottom_actions.dart';

class InspirationDetailScreen extends StatelessWidget {
  final Inspiration inspiration;
  const InspirationDetailScreen({super.key, required this.inspiration});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const PrimaryBackButton(),
        title: Text("preview".tr),
        actions: [
          SaveButton(url: inspiration.image),
          SizedBox(width: 8.sp),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 16.sp),
          Expanded(
            child: Hero(
              tag: inspiration.image,
              child: PhotoView(
                backgroundDecoration: BoxDecoration(color: context.theme.scaffoldBackgroundColor),
                imageProvider: CachedNetworkImageProvider(inspiration.image),
                errorBuilder: (context, error, stackTrace) {
                  return Center(child: Icon(Iconsax.image_copy, size: 50.sp));
                },
              ),
            ),
          ),
          SizedBox(height: 16.sp),
          Padding(
            padding: AppPadding.padding16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  inspiration.prompt.tr,
                  style: context.font14,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 24.sp),
                InspirationActions(inspiration: inspiration),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
