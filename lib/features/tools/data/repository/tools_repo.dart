import 'package:http/http.dart';
import 'package:pixart_app/core/api/api_client.dart';
import 'tools_repo_interface.dart';

class ToolsRepo implements ToolsRepoInterface {
  final ApiClient apiClient;
  ToolsRepo({required this.apiClient});

  @override
  Future<Response?> getTools() async => await apiClient.get('');
}
