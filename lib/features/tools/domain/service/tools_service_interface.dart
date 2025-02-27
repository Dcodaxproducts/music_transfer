import '../../data/model/tools.dart';

abstract class ToolsServiceInterface {
  Future<List<ToolModel>> getTools();
}
