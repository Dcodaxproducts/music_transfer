import 'dart:typed_data';
import 'package:matrix_ai/imports.dart';
import 'package:matrix_ai/data/api/api_client_interface.dart';
import 'package:minio_flutter/minio.dart';
import 'aws_service_intereface.dart';

class AwsService implements AwsServiceInterface {
  final ApiClientInterface apiClient;
  AwsService({required this.apiClient});
  @override
  void init() async {
    try {
      Minio.init(
        endPoint: AppConstants.AWS_ENDPOINT,
        accessKey: AppConstants.AWS_ACCESS_KEY,
        secretKey: AppConstants.AWS_SECRET_KEY,
        region: AppConstants.AWS_REGION,
      );
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
      final bool isExist = await Minio.shared.bucketExists(bucketName);
      if (!isExist) {
        await Minio.shared.makeBucket(bucketName, AppConstants.AWS_REGION);
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
      await Minio.shared.putObject(
        AppConstants.AWS_BUCKET_NAME,
        'uploads/$fileName',
        Stream.value(bytes),
        metadata: {'Content-Type': 'image/jpeg', 'prompt': _sanitizePrompt(prompt)},
      );
      fileLink = _createFileLink(fileName);
    } catch (e) {
      debugPrint("Error uploading file: $e");
    }
    return fileLink;
  }

  String _sanitizePrompt(String? prompt) {
    if (prompt == null) {
      return '';
    }
    return prompt
        .replaceAll('\n', ' ') // Replace newlines with spaces
        .replaceAll('\r', '') // Remove carriage returns
        .replaceAll('"', "'") // Replace double quotes with single quotes
        .replaceAll(RegExp(r'[^\w\s\-.,]'), ''); // Remove other special characters
  }

  _createFileLink(String fileName) {
    return 'https://${AppConstants.AWS_BUCKET_NAME}.s3.${AppConstants.AWS_REGION}.amazonaws.com/uploads/$fileName';
  }
}
