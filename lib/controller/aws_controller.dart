import 'dart:io';
import 'package:get/get.dart';
import 'package:matrix_ai/data/service/aws_service_intereface.dart';

class AwsController extends GetxController implements GetxService {
  final AwsServiceInterface awsService;
  AwsController({required this.awsService});

  static AwsController get find => Get.find<AwsController>();

  void initAWS() => awsService.init();

  Future<String?> uploadFile(File file) async {
    return await awsService.uploadFile(file);
  }

  Future<void> downloadImageAndUploadToAWS(String url) async {
    await awsService.downloadImageAndUploadToAWS(url);
  }
}
