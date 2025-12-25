import 'package:pixart_app/features/tools/domain/service/tools_service.dart';
import 'package:pixart_app/imports.dart';
import '../../data/model/tools.dart';

class ToolsController extends GetxController implements GetxService {
  final ToolsService service;
  ToolsController({required this.service});

  static ToolsController get find => Get.find<ToolsController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  bool _generatingImage = false;
  bool get generatingImage => _generatingImage;
  set generatingImage(bool value) {
    _generatingImage = value;
    update();
  }

  List<ToolsNew> _tools = [];
  List<ToolsNew> get tools => _tools;
  set tools(List<ToolsNew> value) {
    _tools = value;
    update();
  }

  ToolResult? _result;
  ToolResult? get result => _result;
  set result(ToolResult? value) {
    _result = value;
    update();
  }

  Future<void> getTools() async {
    try {
      if (_tools.isNotEmpty) return;
      isLoading = true;
      _tools.addAll(await service.getTools());
    } catch (e) {
      showToast('Failed to load tools: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<ToolResult?> generateImage(ToolsNew tool, XFile image) async {
    try {
      generatingImage = true;
      final Response? response = await service.generateImage(tool.endPoint, image);
      return service.processResponse(tool, response);
    } catch (e) {
      showToast('Image generation failed: $e');
      return null;
    } finally {
      generatingImage = false;
    }
  }
}
