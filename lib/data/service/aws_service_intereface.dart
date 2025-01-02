import 'dart:io';

abstract class AwsServiceInterface {
  void init();
  Future<void> checkAndCreateBucket(String bucketName);
  Future<String?> uploadFile(File file);
  Future<String?> downloadImageAndUploadToAWS(String url);
}
