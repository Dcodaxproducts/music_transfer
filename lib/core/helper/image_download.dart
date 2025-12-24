import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:pixart_app/imports.dart';

class DownloadImage {
  static Future<bool> saveToGallery(String url) async {
    try {
      return (await GallerySaver.saveImage(url, albumName: AppConstants.appName)) ?? false;
    } catch (e) {
      return false;
    }
  }

  static Future<File?> downloadImage(String url) async {
    try {
      return await GallerySaver.downloadFile(url);
    } catch (e) {
      return null;
    }
  }
}
