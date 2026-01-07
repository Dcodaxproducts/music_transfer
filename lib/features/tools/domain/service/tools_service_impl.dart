import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pixart_app/features/tools/data/model/tools.dart';
import 'package:pixart_app/features/tools/data/repository/tools_repo.dart';
import '../../../../core/api/api_client_impl.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../imports.dart';
import '../../../../image_generation/home/utils/image_generation_utils.dart';
import '../../../../image_generation/prompt_setting/presentation/controller/settings_controller.dart';
import '../../../ads/data/utils/firebase_events.dart';
import 'tools_service.dart';

class ToolsServiceImpl implements ToolsService {
  final ToolsRepo toolsRepo;
  ToolsServiceImpl({required this.toolsRepo});

  @override
  Future<List<ToolsNew>> getTools() async {
    final Response? response = await toolsRepo.getTools();
    if (response != null && response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)["data"];
      return data.map((json) => ToolsNew.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tools');
    }
  }

  @override
  Future<Response?> generateImage(String endpoint, XFile image) async {
    final Map<String, dynamic> body = {"token": Endpoints.token};
    MultipartBody multipartBody = MultipartBody('image', image);
    return await toolsRepo.generateImage(endpoint: endpoint, body: body, multipartBody: multipartBody);
  }

  @override
  Future<ToolResult?> processResponse(ToolsNew tool, Response? response) async {
    if (response == null) return null;

    // Decode the response
    Map<String, dynamic> data = jsonDecode(response.body);

    // Check if the response is successful
    if (!ImageGenerationUtils.isSuccessResponse(data)) {
      showErrorDialog();
      return null;
    }

    ToolResult value = ToolResult.fromJson(data);

    // Log the event
    PackageInfo? packageInfo = SettingsController.find.packageInfo;
    EventsHelper.logEvent(tool.name, {
      'tool_name': tool.name,
      'version': "${packageInfo?.version} (${packageInfo?.buildNumber})",
      'platform': Platform.isAndroid ? 'Android' : 'iOS',
    });
    return value;
  }
}
