import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart' as st;
import 'package:http/http.dart';
import 'package:pixart_app/features/aws/presentation/controller/aws_controller.dart';
import 'package:pixart_app/modules/upscale/image_upscale/data/model/upscale_response.dart';
import 'package:pixart_app/features/ads/data/utils/firebase_events.dart';
import 'package:pixart_app/features/loading_screen/presentation/view/src/loading_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../../core/widgets/snackbar.dart';
import '../../presentation/controller/background_remover_controller.dart';
import '../../../../image_generation/prompt_setting/presentation/controller/settings_controller.dart';
import '../../../../../features/tools/data/model/tools.dart';
import '../../data/repository/background_remover_repo_interface.dart';
import '../../data/utils/background_remover_utils.dart';
import '../../../../image_generation/home/data/utils/image_generation_utils.dart';
import 'background_remover_service_interface.dart';

class BackgroundRemoverService implements BackgroundRemoverServiceInterface {
  final BackgroundRemoverRepoInterface backgroundRemoverRepo;
  BackgroundRemoverService({required this.backgroundRemoverRepo});

  @override
  Future<Response?> removeImageBackground({File? image, required ToolModel tool, String? urlImage}) async {
    LoadingManager.show(backgroundRemover: true);
    LoadingManager.updateProgress(1);
    final String? imageUrl = urlImage ?? await AwsController.find.uploadFile(image!);
    if (imageUrl == null) {
      showToast('image_upload_failed');
      dismiss();
      return null;
    }
    LoadingManager.updateProgress(2);
    final Map<String, dynamic> body = BackgroundRemoverUtils.createRequestBody(imageUrl, tool);
    final Map<String, dynamic> headers = BackgroundRemoverUtils.getHeaders(tool);
    final String url = tool.apiUrl;
    return await backgroundRemoverRepo.removeImageBackground(url: url, body: body, headers: headers);
  }

  @override
  Future<UpscaleResponse?> processResponse({required Response? response, required ToolModel tool}) async {
    if (response == null) return null;

    // Decode the response
    Map<String, dynamic> data = jsonDecode(response.body);

    // Check if the response is successful
    if (!ImageGenerationUtils.isSuccessResponse(data)) return null;

    // Create an UpscaleResponse object
    UpscaleResponse value = UpscaleResponse.fromJson(data);

    // Update the UpscaleResponse object
    value = value.copyWith(
      createdAt: DateTime.now(),
      queueUrl: tool.queueUrl,
      apiKey: tool.apiKey,
      isBackgroundRemover: true,
    );

    LoadingManager.updateProgress(3);

    // add the response to the history
    BackgroundRemoverController.find.addBackgroundRemovalHistory(value);

    // Log the event
    PackageInfo? packageInfo = SettingsController.find.packageInfo;
    EventsHelper.logEvent('background_remover_impression', {
      'tool_name': tool.name,
      'version': "${packageInfo?.version} (${packageInfo?.buildNumber})",
      'platform': Platform.isAndroid ? 'Android' : 'iOS',
    });
    // Check if the response is successful
    if (value.status == "success") {
      return value;
    } else if (value.status == "processing") {
      await LoadingManager.queue();
      showToast('your_image_is_processing_in_the_queue', success: true);
      st.Get.close(1);
    } else {
      await LoadingManager.error();
      showToast(data["message"]);
    }
    return null;
  }

  @override
  Future<bool> getQueuedImages(UpscaleResponse value) async {
    // Save the original value in case of rollback
    UpscaleResponse oldResponse = value;

    // prepare body
    Map<String, dynamic> body = {"key": value.apiKey};

    // get queue url
    String url = "${value.queueUrl!}/${value.id}";

    Response? response = await backgroundRemoverRepo.getQueueImage(url: url, body: body);

    if (response != null) {
      Map<String, dynamic> data = jsonDecode(response.body);

      if (data['status'] == "success") {
        final List<String> output = List<String>.from(data['output']);

        // Update response with new data
        value = value.copyWith(status: 'success', output: output);

        // Update the history
        await BackgroundRemoverController.find.removeBackgroundRemovalHistory(oldResponse);
        BackgroundRemoverController.find.addBackgroundRemovalHistory(value);

        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> saveHistoryInPrefs(List<UpscaleResponse> upscaleHistory) async {
    return await backgroundRemoverRepo.saveHistoryInPrefs(upscaleHistory);
  }

  @override
  List<UpscaleResponse> getHistoryFromPrefs() {
    List<String>? history = backgroundRemoverRepo.getHistoryFromPrefs();
    if (history == null) return [];

    List<UpscaleResponse> list = history.map((e) => UpscaleResponse.fromJson(jsonDecode(e))).toList();
    list.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    if (list.isNotEmpty) {
      list.removeWhere((e) => e.createdAt!.isBefore(DateTime.now().subtract(const Duration(days: 30))));
    }
    return list;
  }
}
