import '../../../../imports.dart';
import '../../data/model/tools.dart';

abstract class ToolsService {
  Future<List<ToolsNew>> getTools();
  Future<Response?> generateImage(String endpoint, XFile image);
  Future<ToolResult?> processResponse(ToolsNew tool, Response? response);
}
