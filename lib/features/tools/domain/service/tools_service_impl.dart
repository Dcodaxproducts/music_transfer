import 'dart:convert';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pixart_app/features/tools/data/model/tools.dart';
import 'package:pixart_app/features/tools/data/repository/tools_repo.dart';
import 'package:pixart_app/image_gen/home/data/model/size_preset.dart';
import '../../../../core/api/api_client_impl.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../../imports.dart';
import '../../../../image_gen/home/utils/image_generation_utils.dart';
import '../../../splash/presentation/controller/splash_controller.dart';
import '../../../ads/data/utils/firebase_events.dart';
import 'tools_service.dart';

class ToolsServiceImpl implements ToolsService {
  final ToolsRepo toolsRepo;
  ToolsServiceImpl({required this.toolsRepo});

  @override
  Future<List<Tool>> getTools() async {
    final Response? response = await toolsRepo.getTools();
    if (response != null && response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)["data"];
      return data.map((json) => Tool.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tools');
    }
  }

  @override
  Future<Response?> generateImage(Tool tool, XFile image, {SizePreset? size}) async {
    final Map<String, dynamic> body = {};
    MultipartBody multipartBody = MultipartBody('image', image);

    // add model id if any
    if (tool.model != null) {
      body['tool_id'] = tool.id;
    }

    // add size if any
    if (size != null) {
      body['width'] = size.width;
      body['height'] = size.height;
      body['aspect_ratio'] = size.aspectRatio;
    }

    // send request to api
    return await toolsRepo.generateImage(endpoint: tool.endPoint, body: body, multipartBody: multipartBody);
  }

  @override
  Future<ToolResult?> processResponse(Tool tool, Response? response) async {
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
    PackageInfo? packageInfo = SplashController.find.packageInfo;
    EventsHelper.logEvent(tool.name, {
      'tool_name': tool.name,
      'version': "${packageInfo?.version} (${packageInfo?.buildNumber})",
      'platform': Platform.isAndroid ? 'Android' : 'iOS',
    });
    return value;
  }
}
