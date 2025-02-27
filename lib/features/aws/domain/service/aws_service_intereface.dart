import 'dart:typed_data';

abstract class AwsServiceInterface {
  void init();
  Future<void> checkAndCreateBucket(String bucketName);
  Future<String?> uploadBytes(Uint8List bytes, [String? prompt]);
  Future<String?> downloadImageAndUploadToAWS(String url, [String? prompt]);
}
