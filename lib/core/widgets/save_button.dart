import 'package:share_plus/share_plus.dart';
import '../../imports.dart';
import '../helper/image_download.dart';
import 'action_button.dart';

class SaveButton extends StatefulWidget {
  final String? url;
  const SaveButton({super.key, required this.url});

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  final ValueNotifier<bool> _isDownloading = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isDownloading,
      builder: (context, isDownloading, child) {
        return TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: primaryLight,
            visualDensity: const VisualDensity(horizontal: 1, vertical: -1),
          ),
          onPressed: _downloadImage,
          child: _isDownloading.value
              ? SizedBox(
                  width: 16.sp,
                  height: 16.sp,
                  child: CircularProgressIndicator(strokeWidth: 2.sp, color: Colors.white),
                )
              : Text('save'.tr),
        );
      },
    );
  }

  Future<void> _downloadImage() async {
    if (widget.url == null || widget.url!.isEmpty) return;
    _isDownloading.value = true;
    bool success = await DownloadImage.saveToGallery(widget.url!);
    _isDownloading.value = false;
    if (success) {
      showToast('image_download_success'.tr);
    } else {
      if (mounted) {
        showToast('Failed to download image.');
      }
    }
  }
}

class ShareButton extends StatefulWidget {
  final String? url;
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
        return ActionButton(icon: Iconsax.share_copy, isLoading: isDownloading, onPressed: _downloadImage);
      },
    );
  }

  Future<void> _downloadImage() async {
    if (widget.url == null || widget.url!.isEmpty) return;
    _isDownloading.value = true;
    File? file = await DownloadImage.downloadImage(widget.url!);
    _isDownloading.value = false;
    if (file != null) {
      await Share.shareXFiles([XFile(file.path)], text: 'Check out this image!');
    } else {
      if (mounted) {
        showToast('Failed to download image for sharing.');
      }
    }
  }
}
