import 'dart:typed_data';
import 'package:pixart_app/imports.dart';
import 'package:pixart_app/core/api/api_client.dart';
import 'package:minio/minio.dart';
import 'aws_service_intereface.dart';

class AwsService implements AwsServiceInterface {
  final ApiClient apiClient;
  final Minio minio;
  AwsService({required this.apiClient, required this.minio});
  @override
  void init() async {
    try {
      await checkAndCreateBucket(AppConstants.AWS_BUCKET_NAME);
    } catch (e) {
      // throw error
      throw Exception('Error initializing Minio: $e');
    }
  }

  // Check and create bucket
  @override
  Future<void> checkAndCreateBucket(String bucketName) async {
    try {
      final bool isExist = await minio.bucketExists(bucketName);
      if (!isExist) {
        await minio.makeBucket(bucketName, AppConstants.AWS_REGION);
      }
    } catch (e) {
      // Throw bucket creation error
      debugPrint('Error checking or creating bucket: $e');
    }
  }

  @override
  Future<String?> downloadImageAndUploadToAWS(String url, [String? prompt]) async {
    try {
      final Uint8List? response = await apiClient.downloadImage(url, hideLoading: false);
      if (response != null) {
        return await uploadBytes(response, prompt);
      }
    } catch (e) {
      debugPrint("Error downloading file: $e");
    }
    return null;
  }

  @override
  Future<String?> uploadBytes(Uint8List bytes, [String? prompt]) async {
    final String fileName = "${DateTime.now().millisecondsSinceEpoch}.jpeg";
    String? fileLink;
    try {
      await minio.putObject(
        AppConstants.AWS_BUCKET_NAME,
        'uploads/$fileName',
        Stream.value(bytes),
        metadata: {'Content-Type': 'image/jpeg'},
      );
      fileLink = _createFileLink(fileName);
    } catch (e) {
      debugPrint("Error uploading file: $e");
    }
    return fileLink;
  }

  // String _sanitizePrompt(String? prompt) {
  //   if (prompt == null) {
  //     return '';
  //   }
  //   String data = prompt
  //       .replaceAll('\n', ' ') // Replace newlines with spaces
  //       .replaceAll('\r', '') // Remove carriage returns
  //       .replaceAll('"', "'") // Replace double quotes with single quotes
  //       .replaceAll(RegExp(r'[^\w\s\-.,]'), ''); // Remove other special characters
  //   return jsonEncode(data);
  // }

  String _createFileLink(String fileName) {
    return 'https://${AppConstants.AWS_BUCKET_NAME}.s3.${AppConstants.AWS_REGION}.amazonaws.com/uploads/$fileName';
  }
}
