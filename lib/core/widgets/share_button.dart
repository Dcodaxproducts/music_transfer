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
  final Function() onPressed;
  final Color? color;
  final bool isLoading;
  const ActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: AppRadius.circular32,
      child: Container(
        width: 50.sp,
        height: 50.sp,
        decoration: BoxDecoration(shape: BoxShape.circle, color: context.theme.cardColor),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 16.sp,
                  height: 16.sp,
                  child: CircularProgressIndicator(strokeWidth: 2.sp, color: color ?? Colors.white),
                )
              : Icon(icon, size: 18.sp, color: color ?? Colors.white),
        ),
      ),
    );
  }
}
