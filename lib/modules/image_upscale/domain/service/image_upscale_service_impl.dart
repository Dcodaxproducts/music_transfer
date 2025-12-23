import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:pixart_app/features/tools/data/model/tools.dart';
import 'package:pixart_app/modules/image_upscale/data/repository/image_upscale_repo.dart';
import 'package:pixart_app/features/ads/data/utils/firebase_events.dart';
import 'package:pixart_app/features/loading_screen/src/loading_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/api/api_client_impl.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../imports.dart';
import '../../../image_generation/home/utils/image_generation_utils.dart';
import '../../presentation/controller/image_upscale_controller.dart';
import '../../../image_generation/prompt_setting/presentation/controller/settings_controller.dart';
import '../../data/model/upscale_result.dart';
import 'image_upscale_service.dart';

class ImageUpscaleServiceImpl implements ImageUpscaleService {
  ImageUpscaleRepo repo;
  ImageUpscaleServiceImpl({required this.repo});

  @override
  Future<Response?> upscaleImage(XFile image) async {
    LoadingManager.show(upscale: true);
    LoadingManager.updateProgress(1);
    MultipartBody multipartBody = MultipartBody('image', image);
    final Map<String, dynamic> body = {"token": Endpoints.token};
    return await repo.upscaleImage(body, multipartBody);
  }

  @override
  Future<UpscaleResult?> processResponse(Response? response) async {
    if (response == null) return null;

    // Decode the response
    Map<String, dynamic> data = jsonDecode(response.body);

    // Check if the response is successful
    if (!ImageGenerationUtils.isSuccessResponse(data)) {
      showErrorDialog();
      return null;
    }

    // Create an UpscaleResponse object
    UpscaleResult value = UpscaleResult.fromJson(data);

    LoadingManager.updateProgress(2);

    // add the response to the history
    ImageUpscaleController.find.addToHistory(value);

    // Log the event
    PackageInfo? packageInfo = SettingsController.find.packageInfo;
    EventsHelper.logEvent('upscale_image_impression', {
      'tool_name': ToolModel.upscaleImageTool.name,
      'version': "${packageInfo?.version} (${packageInfo?.buildNumber})",
      'platform': Platform.isAndroid ? 'Android' : 'iOS',
    });
    return value;
  }

  @override
  Future<bool> saveHistoryInPrefs(List<UpscaleResult> upscaleHistory) async {
    return await repo.saveHistoryInPrefs(upscaleHistory);
  }

  @override
  List<UpscaleResult> getHistoryFromPrefs() {
    List<String>? history = repo.getHistoryFromPrefs();
    if (history == null) return [];
    List<UpscaleResult> list = history.map((e) => UpscaleResult.fromJson(jsonDecode(e))).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (list.isNotEmpty) {
      list.removeWhere((e) => e.createdAt.isBefore(DateTime.now().subtract(const Duration(days: 30))));
    }
    return list;
  }
}
