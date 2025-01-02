import 'dart:io';
import 'dart:typed_data';
import 'package:matrix_ai/view/base/common/snackbar.dart';
import 'package:matrix_ai/data/api/api_client_interface.dart';
import 'package:minio_flutter/minio.dart';
import '../../utils/app_constants.dart';
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
      throw Exception('Error checking or creating bucket: $e');
    }
  }

  @override
  Future<String?> uploadFile(File file) async {
    final String fileName = "${DateTime.now().millisecondsSinceEpoch}.jpeg";
    String? fileLink;
    try {
      await Minio.shared.putObject(
        AppConstants.AWS_BUCKET_NAME,
        'uploads/$fileName',
        Stream.value(file.readAsBytesSync()),
        size: file.lengthSync(),
        metadata: {'Content-Type': 'image/jpeg'},
      );
      fileLink = _createFileLink(fileName);
    } catch (e) {
      showToast('Error uploading file: $e');
    }
    return fileLink;
  }

  @override
  Future<void> downloadImageAndUploadToAWS(String url) async {
    try {
      final Uint8List? response = await apiClient.downloadImage(url);
      if (response != null) {
        await uploadBytes(response);
      }
    } catch (e) {
      showToast('Error downloading and uploading file: $e');
    }
  }

  Future<String?> uploadBytes(Uint8List bytes) async {
    final String fileName = "${DateTime.now().millisecondsSinceEpoch}.jpeg";
    String? fileLink;
    try {
      await Minio.shared.putObject(
        AppConstants.AWS_BUCKET_NAME,
        'uploads/$fileName',
        Stream.value(bytes),
        metadata: {'Content-Type': 'image/jpeg'},
      );
      fileLink = _createFileLink(fileName);
    } catch (e) {
      showToast('Error uploading file: $e');
    }
    return fileLink;
  }

  _createFileLink(String fileName) {
    return 'https://${AppConstants.AWS_BUCKET_NAME}.s3.${AppConstants.AWS_REGION}.amazonaws.com/uploads/$fileName';
  }
}
