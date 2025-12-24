import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:pixart_app/core/api/api_client_impl.dart';
import 'package:pixart_app/imports.dart';
import 'package:pixart_app/modules/bg_remover/data/model/bg_remover_result.dart';
import 'package:pixart_app/features/ads/data/utils/firebase_events.dart';
import 'package:pixart_app/features/loading_screen/src/loading_manager.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../image_generation/home/utils/image_generation_utils.dart';
import '../../presentation/controller/background_remover_controller.dart';
import '../../../image_generation/prompt_setting/presentation/controller/settings_controller.dart';
import '../../../../features/tools/data/model/tools.dart';
import '../../data/repository/bg_remover_repo.dart';
import 'bg_remover_service.dart';

class BgRemoverServiceImpl implements BgRemoverService {
  final BgRemoverRepo backgroundRemoverRepo;
  BgRemoverServiceImpl({required this.backgroundRemoverRepo});

  @override
  Future<Response?> removeBg(XFile image) async {
    LoadingManager.show(backgroundRemover: true);
    LoadingManager.updateProgress(1);
    final Map<String, dynamic> body = {"token": Endpoints.token};
    MultipartBody multipartBody = MultipartBody('image', image);
    return await backgroundRemoverRepo.removeImageBackground(body, multipartBody);
  }

  @override
  Future<BgRemoverResult?> processResponse(Response? response) async {
    if (response == null) return null;

    // Decode the response
    Map<String, dynamic> data = jsonDecode(response.body);

    // Check if the response is successful
    if (!ImageGenerationUtils.isSuccessResponse(data)) {
      showErrorDialog();
      return null;
    }

    // Create an UpscaleResponse object
    BgRemoverResult value = BgRemoverResult.fromJson(data);

    LoadingManager.updateProgress(2);

    // add the response to the history
    BgRemoverController.find.addToHistory(value);

    // Log the event
    PackageInfo? packageInfo = SettingsController.find.packageInfo;
    EventsHelper.logEvent('background_remover_impression', {
      'tool_name': ToolModel.backgroundRemoverTool.name,
      'version': "${packageInfo?.version} (${packageInfo?.buildNumber})",
      'platform': Platform.isAndroid ? 'Android' : 'iOS',
    });
    return value;
  }

  @override
  Future<bool> saveHistoryInPrefs(List<BgRemoverResult> history) async {
    return await backgroundRemoverRepo.saveHistoryInPrefs(history);
  }

  @override
  List<BgRemoverResult> getHistoryFromPrefs() {
    List<String>? history = backgroundRemoverRepo.getHistoryFromPrefs();
    if (history == null) return [];

    List<BgRemoverResult> list = history.map((e) => BgRemoverResult.fromJson(jsonDecode(e))).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (list.isNotEmpty) {
      list.removeWhere((e) => e.createdAt.isBefore(DateTime.now().subtract(const Duration(days: 30))));
    }
    return list;
  }
}
