import 'package:share_plus/share_plus.dart';
import '../../imports.dart';
import '../helper/image_download.dart';

class ShareButton extends StatefulWidget {
  final String url;
  const ShareButton({super.key, required this.url});

  @override
  State<ShareButton> createState() => _ShareButtonState();
}

class _ShareButtonState extends State<ShareButton> {
  final ValueNotifier<bool> _isDownloading = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isDownloading,
      builder: (context, isDownloading, child) {
        return ActionButton(icon: Iconsax.share, isLoading: isDownloading, onPressed: _downloadImage);
      },
    );
  }

  Future<void> _downloadImage() async {
    _isDownloading.value = true;
    File? file = await DownloadImage.downloadImage(widget.url);
    _isDownloading.value = false;
    if (file != null) {
      await Share.shareXFiles([XFile(file.path)], text: 'Check out this image!');
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to download image for sharing.')));
      }
    }
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final bool isLoading;
  final Function() onPressed;
  final Color? color;

  //
  final bool useCanvas;
  final double size;
  final double iconSize;

  const ActionButton({
    super.key,
    required this.icon,
    this.isLoading = false,
    required this.onPressed,
    this.color,
    this.useCanvas = false,
    this.size = 50,
    this.iconSize = 18,
  });

  const ActionButton.small({
    super.key,
    required this.icon,
    this.isLoading = false,
    this.color,
    required this.onPressed,
    this.useCanvas = true,
    this.size = 36,
    this.iconSize = 18,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = useCanvas ? context.theme.canvasColor : context.theme.cardColor;
    return InkWell(
      onTap: onPressed,
      borderRadius: AppRadius.circular32,
      child: Container(
        width: size.sp,
        height: size.sp,
        decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundColor),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: (iconSize - 2).sp,
                  height: (iconSize - 2).sp,
                  child: CircularProgressIndicator(strokeWidth: 2.sp, color: color ?? context.font14.color),
                )
              : Icon(icon, size: iconSize.sp, color: color ?? context.font14.color),
        ),
      ),
    );
  }
}
