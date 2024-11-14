import '../../controller/models_controller.dart';
import '../model/body/aspect_ratio.dart';
import '../model/body/config_model.dart';
import '../model/response/model.dart';
import '../../controller/settings_controller.dart';

class ImageGenerationUtils {
  static AspectRatioModel getAspectRatio() {
    return aspectRatios.firstWhere(
      (e) => e.id == SettingsController.find.configModel.aspectRatio,
    );
  }

  static Model getModel(String? modelId) {
    final controller = ModelsController.find;
    return modelId != null
        ? controller.models.firstWhere((e) => e.modelId == modelId)
        : SettingsController.find.configModel.selectedModel!;
  }

  static Map<String, dynamic> createRequestBody(
    String prompt,
    AspectRatioModel size,
    Model model,
    int? seed,
    bool upscale,
    bool faceFix,
  ) {
    final body = {...model.apiParameters};
    ConfigModel config = SettingsController.find.configModel;

    body[model.parametersMapping.prompt] = prompt;
    body[model.parametersMapping.negativePrompt] = config.negativePrompt;
    body[model.parametersMapping.cfgScale] = config.guidanceScale.toString();

    if (upscale && body.containsKey('upscale')) body['upscale'] = upscale;
    if (seed != null) body['seed'] = seed.toString();
    if (faceFix && body.containsKey('highres_fix')) body['highres_fix'] = 'yes';

    body['model_id'] = model.modelId;
    if (model.parametersMapping.aspectRatio != null) {
      body[model.parametersMapping.aspectRatio!] = size.aspectRatio;
    }
    if (model.parametersMapping.width != null &&
        model.parametersMapping.height != null) {
      body[model.parametersMapping.width!] = size.width.toString();
      body[model.parametersMapping.height!] = size.height.toString();
    }
    if (model.apiKeyLoation == 'body') {
      body['key'] = model.apiKey;
    }

    return body;
  }

  static Map<String, dynamic> getHeaders(Model model) {
    return model.apiKeyLoation == 'header'
        ? {'Authorization': 'Bearer ${model.apiKey}'}
        : {};
  }
}
