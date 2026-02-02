import '../../../home/data/model/size_preset.dart';
import '../../../../imports.dart';
import '../../data/model/tools.dart';

abstract class ToolsService {
  Future<List<ToolCategory>> getTools();
  Future<Response?> generateImage(Tool tool, List<XFile> images, {SizePreset? size});
  Future<ToolResult?> processResponse(Tool tool, Response? response);
}
