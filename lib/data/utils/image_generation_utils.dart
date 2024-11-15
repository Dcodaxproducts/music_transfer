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

  static Model getModel(Model? model) {
    return model ?? SettingsController.find.configModel.selectedModel!;
  }

  static Map<String, dynamic> createRequestBody(
    String prompt,
    AspectRatioModel size,
    Model model,
    int? seed,
    bool upscale,
    bool faceFix,
  ) {
    // get the model api parameters
    final body = {...model.apiParameters};

    // get the config model
    ConfigModel config = SettingsController.find.configModel;

    // add the prompt to the body (if prompt engineering is enabled, add the prompt engineering to the prompt)
    body[model.parametersMapping.prompt] =
        prompt + (model.promptEngeenring ?? '');

    // add the negative prompt to the body
    body[model.parametersMapping.negativePrompt] = config.negativePrompt;

    // add the guidance scale to the body
    body[model.parametersMapping.cfgScale] = config.guidanceScale.toString();

    // if upscale is enabled and the model supports upscaling, add upscale to the body
    if (upscale && body.containsKey('upscale')) {
      body['upscale'] = 2;
    }

    // if face fix is enabled and the model supports face fix, add face fix to the body
    if (faceFix && body.containsKey('highres_fix')) body['highres_fix'] = 'yes';

    // if seed is not null, add seed to the body
    if (seed != null) body['seed'] = seed.toString();

    // add the model id to the body
    body['model_id'] = model.modelId;

    // if the model supports aspect ratio, add aspect ratio to the body
    if (model.parametersMapping.aspectRatio != null) {
      body[model.parametersMapping.aspectRatio!] = size.aspectRatio;
    }

    // if the model supports width and height, add width and height to the body
    if (model.parametersMapping.width != null &&
        model.parametersMapping.height != null) {
      body[model.parametersMapping.width!] = size.width;
      body[model.parametersMapping.height!] = size.height;
    }

    // if the model supports the api key in the body, add the api key to the body
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
