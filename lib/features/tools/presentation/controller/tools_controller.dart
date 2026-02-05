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

  List<ToolCategory> _toolCategories = [];
  List<ToolCategory> get toolCategories => _toolCategories;
  set toolCategories(List<ToolCategory> value) {
    _toolCategories = value;
    update();
  }

  int _selectedCategoryIndex = 0;
  int get selectedCategoryIndex => _selectedCategoryIndex;
  set selectedCategoryIndex(int value) {
    if (_selectedCategoryIndex == value || _toolCategories.isEmpty) return;
    _selectedCategoryIndex = value;
    update();
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

  Future<void> getTools({bool refresh = false}) async {
    try {
      // if tools are already loaded and not refreshing, return early
      if (_toolCategories.isNotEmpty && !refresh) return;

      // Clear the tools list if refreshing
      if (refresh) _toolCategories.clear();

      // refresh only sets isLoading when not refreshing
      if (!refresh) isLoading = true;
      _toolCategories.addAll(await service.getTools());
    } catch (e) {
      debugPrint('Failed to load tools: $e');
    } finally {
      isLoading = false;
    }
  }

  Future<ToolResult?> generateImage(Tool tool, List<XFile> images) async {
    try {
      generatingImage = true;
      final Response? response = await service.generateImage(tool, images, size: selectedSize);
      return service.processResponse(tool, response);
    } catch (e) {
      showToast('Image generation failed: $e');
      return null;
    } finally {
      generatingImage = false;
    }
  }
}
