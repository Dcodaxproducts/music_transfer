import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart' show Offset;
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

enum WatermarkPosition { topLeft, topRight, bottomLeft, bottomRight, center }

class ImageWatermark {
  /// Add watermark to an image from URL
  /// Returns the path to the watermarked image file, or null if failed
  static Future<String?> addWatermark(
    String imageUrl, {
    double opacity = 0.4,
    WatermarkPosition position = WatermarkPosition.bottomRight,
    String logoAssetPath = 'assets/images/logo.png',
    double logoScale = 0.15, // Logo will be 15% of image width
  }) async {
    try {
      // Download the original image
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) return null;

      // Decode the original image
      img.Image? originalImage = img.decodeImage(response.bodyBytes);
      if (originalImage == null) return null;

      // Load the watermark logo from assets
      final ByteData logoData = await rootBundle.load(logoAssetPath);
      final Uint8List logoBytes = logoData.buffer.asUint8List();
      img.Image? logo = img.decodeImage(logoBytes);
      if (logo == null) return null;

      // Calculate logo size based on original image dimensions
      final int logoWidth = (originalImage.width * logoScale).toInt();
      final int logoHeight = (logo.height * logoWidth / logo.width).toInt();

      // Resize logo
      logo = img.copyResize(logo, width: logoWidth, height: logoHeight);

      // Calculate position for watermark
      final position = _calculatePosition(
        imageWidth: originalImage.width,
        imageHeight: originalImage.height,
        logoWidth: logoWidth,
        logoHeight: logoHeight,
        position: WatermarkPosition.bottomRight,
      );

      // Composite the logo onto the original image with opacity
      img.compositeImage(
        originalImage,
        logo,
        dstX: position.dx.toInt(),
        dstY: position.dy.toInt(),
        blend: img.BlendMode.alpha,
      );

      // Apply opacity by creating a semi-transparent version
      logo = _applyOpacity(logo, opacity);

      // Composite again with opacity applied
      img.compositeImage(originalImage, logo, dstX: position.dx.toInt(), dstY: position.dy.toInt());

      // Save the watermarked image to temp directory
      final Directory tempDir = await getTemporaryDirectory();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String filePath = '${tempDir.path}/watermarked_$timestamp.jpg';

      // Encode and save
      final Uint8List watermarkedBytes = Uint8List.fromList(img.encodeJpg(originalImage, quality: 95));
      final File file = File(filePath);
      await file.writeAsBytes(watermarkedBytes);

      return filePath;
    } catch (e) {
      print('Error adding watermark: $e');
      return null;
    }
  }

  /// Calculate watermark position based on placement strategy
  static Offset _calculatePosition({
    required int imageWidth,
    required int imageHeight,
    required int logoWidth,
    required int logoHeight,
    required WatermarkPosition position,
  }) {
    const int padding = 20; // Padding from edges in pixels

    switch (position) {
      case WatermarkPosition.topLeft:
        return Offset(padding.toDouble(), padding.toDouble());
      case WatermarkPosition.topRight:
        return Offset((imageWidth - logoWidth - padding).toDouble(), padding.toDouble());
      case WatermarkPosition.bottomLeft:
        return Offset(padding.toDouble(), (imageHeight - logoHeight - padding).toDouble());
      case WatermarkPosition.bottomRight:
        return Offset(
          (imageWidth - logoWidth - padding).toDouble(),
          (imageHeight - logoHeight - padding).toDouble(),
        );
      case WatermarkPosition.center:
        return Offset(((imageWidth - logoWidth) / 2).toDouble(), ((imageHeight - logoHeight) / 2).toDouble());
    }
  }

  /// Apply opacity to an image
  static img.Image _applyOpacity(img.Image image, double opacity) {
    // Create a copy of the image
    final img.Image result = image.clone();

    // Iterate through all pixels and adjust alpha channel
    for (final pixel in result) {
      pixel.a = (pixel.a * opacity).toInt();
    }

    return result;
  }
}
