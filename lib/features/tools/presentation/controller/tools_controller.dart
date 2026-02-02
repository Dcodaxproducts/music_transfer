import 'package:pixart_app/features/tools/domain/service/tools_service.dart';
import 'package:pixart_app/features/home/data/model/size_preset.dart';
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

  List<Tool> _tools = [];
  List<Tool> get tools => _tools;
  set tools(List<Tool> value) {
    _tools = value;
    update();
  }

  Map<String, List<Tool>> get categorizedTools {
    Map<String, List<Tool>> categorized = {};
    for (var tool in _tools) {
      if (!categorized.containsKey(tool.category)) {
        categorized[tool.category] = [];
      }
      categorized[tool.category]!.add(tool);
    }
    return categorized;
  }

  Tool? _selectedTool;
  Tool? get selectedTool => _selectedTool;
  set selectedTool(Tool? value) {
    _selectedTool = value;
    _selectedSize = SizePreset.defaultPreset();
    update();
  }

  SizePreset _selectedSize = SizePreset.defaultPreset();
  SizePreset get selectedSize => _selectedSize;
  set selectedSize(SizePreset value) {
    _selectedSize = value;
    update();
  }

  bool _generatingImage = false;
  bool get generatingImage => _generatingImage;
  set generatingImage(bool value) {
    _generatingImage = value;
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
      debugPrint('Failed to load tools: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<ToolResult?> generateImage(Tool tool, XFile image) async {
    try {
      generatingImage = true;
      final Response? response = await service.generateImage(tool, image, size: selectedSize);
      return service.processResponse(tool, response);
    } catch (e) {
      showToast('Image generation failed: $e');
      return null;
    } finally {
      generatingImage = false;
    }
  }
}
