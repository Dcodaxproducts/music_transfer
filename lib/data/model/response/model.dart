class Model {
  final int id;
  final String name;
  final String modelId;
  final String image;
  final bool premium;
  final bool popular;
  final bool isDefault;

  Model({
    required this.id,
    required this.name,
    required this.modelId,
    required this.image,
    required this.premium,
    required this.popular,
    this.isDefault = false,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      id: json['id'],
      name: json['name'],
      modelId: json['model_id'],
      image: json['image'],
      premium: json['premium'],
      popular: json['popular'] ?? false,
      isDefault: json['default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model_id': modelId,
      'image': image,
      'premium': premium,
      'popular': popular,
      'default': isDefault,
    };
  }
}

class MyModel {
  int id;
  String modelId;
  String name;
  String image;
  bool premium;
  bool popular;
  bool isDefault;
  String promptEngeenring;
  String apiUrl;
  String apiKey;
  String apiKeyLoation;
  Map<String, dynamic> apiParameters;
  ParameterMapping parametersMapping;
  AdType? adType;

  MyModel({
    required this.id,
    required this.modelId,
    required this.name,
    required this.image,
    required this.premium,
    required this.popular,
    required this.isDefault,
    required this.promptEngeenring,
    required this.apiUrl,
    required this.apiKey,
    required this.apiKeyLoation,
    required this.apiParameters,
    required this.parametersMapping,
    this.adType,
  });

  factory MyModel.fromJson(Map<String, dynamic> json) {
    return MyModel(
      id: json['id'],
      modelId: json['model_id'],
      name: json['name'],
      image: json['image'],
      premium: json['premium'],
      popular: json['popular'] ?? false,
      isDefault: json['default'] ?? false,
      promptEngeenring: json['prompt_engineering'],
      apiUrl: json['api_url'],
      apiKey: json['api_key'],
      apiKeyLoation: json['api_key_location'],
      apiParameters: json['api_parameters'],
      parametersMapping: ParameterMapping.fromJson(json['parameters_mapping']),
      adType: AdTypeExtension.fromString(json['ad_type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model_id': modelId,
      'name': name,
      'image': image,
      'premium': premium,
      'popular': popular,
      'default': isDefault,
      'prompt_engineering': promptEngeenring,
      'api_url': apiUrl,
      'api_key': apiKey,
      'api_key_location': apiKeyLoation,
      'api_parameters': apiParameters,
      'parameters_mapping': parametersMapping,
      'ad_type': adType?.name,
    };
  }
}

class ParameterMapping {
  final String prompt;
  final String negativePrompt;
  final String cfgScale;
  final String? aspectRatio;
  final String? width;
  final String? height;

  ParameterMapping({
    required this.prompt,
    required this.negativePrompt,
    required this.cfgScale,
    required this.aspectRatio,
    required this.width,
    required this.height,
  });

  factory ParameterMapping.fromJson(Map<String, dynamic> json) {
    return ParameterMapping(
      prompt: json['prompt'],
      negativePrompt: json['negativePrompt'],
      cfgScale: json['cfgScale'],
      aspectRatio: json['aspectRatio'],
      width: json['width'],
      height: json['height'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prompt': prompt,
      'negativePrompt': negativePrompt,
      'cfgScale': cfgScale,
      'aspectRatio': aspectRatio,
      'width': width,
      'height': height,
    };
  }
}

enum AdType { rewardVideo, rewardInterstitial }

extension AdTypeExtension on AdType {
  String get name {
    switch (this) {
      case AdType.rewardVideo:
        return 'reward_video';
      case AdType.rewardInterstitial:
        return 'reward_interstitial';
    }
  }

  static AdType fromString(String? value) {
    switch (value) {
      case 'reward_video':
        return AdType.rewardVideo;
      case 'reward_interstitial':
        return AdType.rewardInterstitial;
      default:
        return AdType.rewardVideo;
    }
  }
}
