import 'package:flutter/foundation.dart';
import 'package:pixart_app/imports.dart';
import '../../../../core/api/api_client_impl.dart';
import 'tools_repo.dart';

class ToolsRepoImpl implements ToolsRepo {
  final ApiClient client;
  ToolsRepoImpl({required this.client});

  @override
  Future<Response?> getTools() async {
    int isLive = kDebugMode ? 0 : 1;
    return await client.get('${Endpoints.tools}?is_live=$isLive');
  }

  @override
  Future<Response?> generateImage({
    required String endpoint,
    required Map<String, dynamic> body,
    required MultipartBody multipartBody,
  }) async => await client.postMultipart(endpoint, body, [multipartBody]);
}
