import '../../../../imports.dart';
import '../../data/model/tools.dart';

abstract class ToolsService {
  Future<List<Tools>> getTools();
  Future<Response?> generateImage(String endpoint, XFile image);
  Future<ToolResult?> processResponse(Tools tool, Response? response);
}
