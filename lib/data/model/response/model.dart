class Model {
  final int id;
  final String modelId;
  final String name;
  final String image;
  final bool premium;
  final bool popular;
  final bool isDefault;
  final String shortDescription;
  final String? promptEngeenring;
  final String apiUrl;
  final String apiKey;
  final String apiKeyLoation;
  final Map<String, dynamic> apiParameters;
  final ParameterMapping parametersMapping;
  final AdType? adType;

  Model({
    required this.id,
    required this.modelId,
    required this.name,
    required this.image,
    required this.premium,
    required this.popular,
    required this.isDefault,
    required this.shortDescription,
    required this.promptEngeenring,
    required this.apiUrl,
    required this.apiKey,
    required this.apiKeyLoation,
    required this.apiParameters,
    required this.parametersMapping,
    this.adType,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      id: json['id'],
      modelId: json['model_id'],
      name: json['name'],
      image: json['image'],
      premium: json['premium'],
      popular: json['popular'] ?? false,
      isDefault: json['default'] ?? false,
      shortDescription: json['short_desc'] ?? '',
      promptEngeenring: json['prompt_engineering'],
      apiUrl: json['api_url'],
      apiKey: json['api_key'],
      apiKeyLoation: json['api_key_location'],
      apiParameters: json['provider'],
      parametersMapping: ParameterMapping.fromJson(json['parameters']),
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
      'short_desc': shortDescription,
      'prompt_engineering': promptEngeenring,
      'api_url': apiUrl,
      'api_key': apiKey,
      'api_key_location': apiKeyLoation,
      'provider': apiParameters,
      'parameters': parametersMapping.toJson(),
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
      negativePrompt: json['negative_prompt'],
      cfgScale: json['cfg_scale'],
      aspectRatio: json['aspect_ratio'],
      width: json['width'],
      height: json['height'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prompt': prompt,
      'negative_prompt': negativePrompt,
      'cfg_scale': cfgScale,
      'aspect_ratio': aspectRatio,
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
