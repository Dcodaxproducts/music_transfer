import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:matrix_ai/imports.dart';

class DownloadImage {
  static downloadImage(String url) async {
    showLoading();
    try {
      bool success = (await GallerySaver.saveImage(url, albumName: AppConstants.APP_NAME)) ?? false;
      if (success) {
        showToast('image_download_success'.tr, success: true);
      } else {
        showToast('image_not_available'.tr);
      }
    } catch (e) {
      showToast('image_not_available'.tr);
    }
    dismiss();
  }
}
