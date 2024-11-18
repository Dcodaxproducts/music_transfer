import 'dart:io';
import 'dart:typed_data';
import 'package:matrix_ai/common/snackbar.dart';
import 'package:matrix_ai/controller/history_controller.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:share_plus/share_plus.dart';

class DownloadImage {
  static downloadImage(String url) async {
    showLoading();
    Uint8List? bytes = await HistoryController.find.downloadImage(url);
    if (bytes != null) {
      ImageGallerySaver.saveImage(
        bytes,
        quality: 100,
        name: DateTime.now().toString(),
      );
      showToast(
        'image_download_success'.tr,
        success: true,
      );
    } else {
      showToast('image_download_fail'.tr);
    }
    var directory = await getTemporaryDirectory();
    // save image
    String fileName = url.substring(url.lastIndexOf("/") + 1, url.length);
    File image = File('${directory.path}/$fileName.png');
    await image.writeAsBytes(bytes!);
    dismiss();
    // Share.shareXFiles([XFile(image.path)]);
  }
}
