import '../model/response/tools.dart';

abstract class ToolsServiceInterface {
  Future<List<ToolModel>> getTools();
}
