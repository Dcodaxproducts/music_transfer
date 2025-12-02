import 'package:pixart_app/features/tools/data/model/tools.dart';

class ImageUpscaleUtils {
  static Map<String, dynamic> createRequestBody(String initImage, ToolModel tool) {
    Map<String, dynamic> body = {};
    for (var entry in tool.upscaleImage!.toJson().entries.toList()) {
      body[entry.key] = entry.value;
    }
    body['key'] = tool.apiKey;
    body['init_image'] = initImage;

    // return body
    return body;
  }

  static Map<String, dynamic> getHeaders(ToolModel tool) {
    return tool.apiKeyLoation == 'header' ? {'Authorization': 'Bearer ${tool.apiKey}'} : {};
  }
}
