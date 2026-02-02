import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:pixart_app/imports.dart';
import 'package:pixart_app/features/paywall/presentation/controller/subscription_controller.dart';
import 'package:pixart_app/core/helper/image_watermark.dart';

class DownloadImage {
  /// Save image to gallery
  /// For free users, adds watermark before saving
  /// For pro users, saves original image
  static Future<bool> saveToGallery(String url) async {
    try {
      // Check if user is pro
      final bool isPro = SubscriptionController.find.isPro;

      if (isPro) {
        // Pro user - save original image
        return (await GallerySaver.saveImage(url, albumName: AppConstants.appName)) ?? false;
      } else {
        // Free user - add watermark first
        final String? watermarkedPath = await ImageWatermark.addWatermark(url);
        if (watermarkedPath == null) {
          // Fallback to original if watermark fails
          return (await GallerySaver.saveImage(url, albumName: AppConstants.appName)) ?? false;
        }
        return (await GallerySaver.saveImage(watermarkedPath, albumName: AppConstants.appName)) ?? false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Download image to file
  /// For free users, returns watermarked image
  /// For pro users, returns original image
  static Future<File?> downloadImage(String url) async {
    try {
      // Check if user is pro
      final bool isPro = SubscriptionController.find.isPro;

      if (isPro) {
        // Pro user - download original
        return await GallerySaver.downloadFile(url);
      } else {
        // Free user - add watermark and return watermarked file
        final String? watermarkedPath = await ImageWatermark.addWatermark(url);
        if (watermarkedPath == null) {
          // Fallback to original if watermark fails
          return await GallerySaver.downloadFile(url);
        }
        return File(watermarkedPath);
      }
    } catch (e) {
      return null;
    }
  }
}
