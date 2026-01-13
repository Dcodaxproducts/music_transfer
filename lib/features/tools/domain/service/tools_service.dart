import '../../../../image_gen/home/data/model/size_preset.dart';
import '../../../../imports.dart';
import '../../data/model/tools.dart';

abstract class ToolsService {
  Future<List<Tool>> getTools();
  Future<Response?> generateImage(Tool tool, XFile image, {SizePreset? size});
  Future<ToolResult?> processResponse(Tool tool, Response? response);
}
