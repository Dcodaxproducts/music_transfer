import 'package:get/get.dart';
import 'package:matrix_ai/features/aws/presentation/controller/aws_controller.dart';
import '../service/aws_service.dart';
import '../service/aws_service_intereface.dart';

class AwsBinding extends Bindings {
  @override
  void dependencies() {
    // service
    AwsServiceInterface adsServiceInterface = AwsService(apiClient: Get.find());
    Get.lazyPut(() => adsServiceInterface, fenix: true);

    // controller
    Get.lazyPut(() => AwsController(awsService: Get.find()));
  }
}
