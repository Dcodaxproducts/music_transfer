import 'package:http/http.dart';

abstract class ToolsRepoInterface {
  Future<Response?> getTools();
}
