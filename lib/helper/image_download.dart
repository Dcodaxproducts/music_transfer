import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:matrix_ai/imports.dart';

class DownloadImage {
  static downloadImage(String url) async {
    showLoading();
    bool success = (await GallerySaver.saveImage(url, albumName: AppConstants.APP_NAME)) ?? false;
    if (success) {
      showToast('image_download_success'.tr, success: true);
    } else {
      showToast('image_download_fail'.tr);
    }
    // var directory = await getTemporaryDirectory();
    // // save image
    // String fileName = url.substring(url.lastIndexOf("/") + 1, url.length);
    // File image = File('${directory.path}/$fileName.png');
    // await image.writeAsBytes(bytes!);
    dismiss();
    // Share.shareXFiles([XFile(image.path)]);
  }
}
