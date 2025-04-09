import 'package:matrix_ai/features/tools/data/model/tools.dart';

class BackgroundRemoverUtils {
  static Map<String, dynamic> createRequestBody(String initImage, ToolModel tool) {
    Map<String, dynamic> body = {};
    for (var entry in tool.backgroundRemover!.toJson().entries.toList()) {
      body[entry.key] = entry.value;
    }
    body['key'] = tool.apiKey;
    body['image'] = initImage;

    // return body
    return body;
  }

  static Map<String, dynamic> getHeaders(ToolModel tool) {
    return tool.apiKeyLoation == 'header' ? {'Authorization': 'Bearer ${tool.apiKey}'} : {};
  }
}
