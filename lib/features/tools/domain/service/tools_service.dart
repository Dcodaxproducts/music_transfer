import 'package:matrix_ai/features/tools/data/model/tools.dart';
import 'package:matrix_ai/features/tools/data/repository/tools_repo_interface.dart';
import 'tools_service_interface.dart';

class ToolsService implements ToolsServiceInterface {
  final ToolsRepoInterface toolsRepo;
  ToolsService({required this.toolsRepo});

  @override
  Future<List<ToolModel>> getTools() async {
    return await Future.value(tools);
  }
}
