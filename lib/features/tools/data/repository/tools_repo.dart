import 'package:http/http.dart';
import 'package:matrix_ai/core/api/api_client_interface.dart';
import 'tools_repo_interface.dart';

class ToolsRepo implements ToolsRepoInterface {
  final ApiClientInterface apiClient;
  ToolsRepo({required this.apiClient});

  @override
  Future<Response?> getTools() async => await apiClient.get('');
}
