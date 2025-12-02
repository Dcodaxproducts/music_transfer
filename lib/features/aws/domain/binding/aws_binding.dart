import 'package:pixart_app/features/aws/presentation/controller/aws_controller.dart';
import 'package:minio/minio.dart';
import '../../../../imports.dart';
import '../service/aws_service.dart';
import '../service/aws_service_intereface.dart';

class AwsBinding extends Bindings {
  @override
  void dependencies() {
    Minio minio = Minio(
      endPoint: AppConstants.AWS_ENDPOINT,
      accessKey: AppConstants.AWS_ACCESS_KEY,
      secretKey: AppConstants.AWS_SECRET_KEY,
      region: AppConstants.AWS_REGION,
    );
    Get.lazyPut(() => minio, fenix: true);
    // service
    AwsServiceInterface adsServiceInterface = AwsService(apiClient: Get.find(), minio: Get.find());
    Get.lazyPut(() => adsServiceInterface, fenix: true);

    // controller
    Get.lazyPut(() => AwsController(awsService: Get.find()));
  }
}
