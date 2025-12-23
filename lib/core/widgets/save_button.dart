import '../../imports.dart';
import '../helper/image_download.dart';

class SaveButton extends StatefulWidget {
  final String url;
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
            visualDensity: VisualDensity(horizontal: 1, vertical: -1),
          ),
          onPressed: _downloadImage,
          child: _isDownloading.value
              ? SizedBox(
                  width: 16.sp,
                  height: 16.sp,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.sp,
                    color: Colors.white,
                  ),
                )
              : Text('Save'),
        );
      },
    );
  }

  Future<void> _downloadImage() async {
    _isDownloading.value = true;
    bool success = await DownloadImage.saveToGallery(widget.url);
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
