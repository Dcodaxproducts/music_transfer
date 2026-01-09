import 'dart:async';
import 'dart:convert';
import 'package:pixart_app/imports.dart';
import 'package:pixart_app/image_gen/history/presentation/controller/history_controller.dart';
import 'package:pixart_app/image_gen/home/presentation/controller/generation_controller.dart';
import 'package:http/http.dart' as http;
import 'package:pixart_app/features/splash/presentation/controller/splash_controller.dart';
import 'package:pixart_app/image_gen/home/data/repository/image_gen_repo.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/api/api_client_impl.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../features/ads/data/utils/firebase_events.dart';
import '../../data/model/aspect_ratio.dart';
import '../../data/model/image_generation.dart';
import '../../data/model/model.dart';
import '../../utils/image_generation_utils.dart';
import 'image_gen_service.dart';

class ImageGenerationServiceImpl implements ImageGenService {
  final ImageGenRepo repo;
  ImageGenerationServiceImpl({required this.repo});

  @override
  Future<http.Response?> generateImages(String prompt, Model model, { List<XFile>? images}) async {

    // get aspect ratio
    AspectRatioModel size = ImageGenerationUtils.getAspectRatio();

    // generate seed
    int seedValue = ImageGenerationUtils.generateSeed();

    Map<String, dynamic> body = {
      "token": Endpoints.token,
      "prompt": prompt,
      "model_id": model.id,
      "width": size.width,
      "height": size.height,
      "seed": seedValue,
    };

    // attach image if any
    List<MultipartBody>? files;
    if (images != null) {
      files = [];
      for (int i = 0; i < images.length; i++) {
        MultipartBody additionalFile = MultipartBody('images[$i]', images[i]);
        files.add(additionalFile);
      }
    }
    // send request to api
    return await repo.generateImages(body, files: files);
  }

  // process generation response
  @override
  ImageGenerationResult? processGenerationResponse(http.Response? response) {
    try {
      if (response == null) return null;

      Map<String, dynamic> data = jsonDecode(response.body);

      // Check if the response is successful
      if (!ImageGenerationUtils.isSuccessResponse(data)) {
        showErrorDialog();
        return null;
      }

      GenerationController.find.incrementGenerationCount();

      ImageGenerationResult value = ImageGenerationResult.fromJson(data);

      //  log impression for model to track usage to firebase
      PackageInfo? packageInfo = SplashController.find.packageInfo;
      EventsHelper.logEvent('model_impression', {
        'model': value.meta.model.name,
        'version': "${packageInfo?.version} (${packageInfo?.buildNumber})",
        'platform': Platform.isAndroid ? 'Android' : 'iOS',
      });

      HistoryController.find.addPrompt(value);

      return value;
    } catch (e) {
      showToast("Failed to process response: $e");
      rethrow;
    }
  }

  @override
  Future<void> cancelRequest() async {
    await repo.cancelRequest();
  }
}
