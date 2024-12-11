import 'dart:convert';
import 'dart:io';
import 'package:matrix_ai/data/model/response/tools.dart';

class ImageUpscaleUtils {
  static Map<String, dynamic> createRequestBody(File initImage, ToolModel tool) {
    Map<String, dynamic> body = {};
    for (var entry in tool.upscaleImage!.toJson().entries.toList()) {
      body[entry.key] = entry.value;
    }
    body['key'] = tool.apiKey;

    // image to base64
    String base64 = base64Encode(initImage.readAsBytesSync());
    body['image'] = "data:image/jpeg;base64,$base64";

    // return body
    return body;
  }

  static Map<String, dynamic> getHeaders(ToolModel tool) {
    return tool.apiKeyLoation == 'header' ? {'Authorization': 'Bearer ${tool.apiKey}'} : {};
  }
}
