import 'dart:io';
import '../../../../../features/ads/data/enum/ad_type.dart';
import '../../../../../features/ads/data/extension/ad_type.dart';

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
  final String queueUrl;
  final Map<String, dynamic> apiParameters;
  final ParameterMapping parametersMapping;
  final AdType? adType;
  final String? adId;
  final int delay;

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
    required this.queueUrl,
    required this.apiKeyLoation,
    required this.apiParameters,
    required this.parametersMapping,
    this.adType,
    this.adId,
    this.delay = 0,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      id: json['id'],
      modelId: json['model_id'],
      name: json['name'],
      image: json['image'],
      premium: Platform.isAndroid ? json['premium'] : (json['ios_premium'] ?? false),
      popular: json['popular'] ?? false,
      isDefault: json['default'] ?? false,
      shortDescription: json['short_desc'] ?? '',
      promptEngeenring: json['prompt_engineering'],
      apiUrl: json['api_url'],
      apiKey: json['api_key'],
      queueUrl: json['queue_url'] ?? '',
      apiKeyLoation: json['api_key_location'],
      apiParameters: json['provider'],
      parametersMapping: ParameterMapping.fromJson(json['parameters']),
      adType: AdTypeExtension.fromString(json['ad_type']),
      adId: json['ad_id'],
      delay: json['delay'] != null ? int.parse(json['delay'].toString()) : 0,
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
      'queue_url': queueUrl,
      'provider': apiParameters,
      'parameters': parametersMapping.toJson(),
      'ad_type': adType?.name,
      'ad_id': adId,
      'delay': delay,
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
  final String modelId;

  ParameterMapping({
    required this.prompt,
    required this.negativePrompt,
    required this.cfgScale,
    required this.aspectRatio,
    required this.width,
    required this.height,
    required this.modelId,
  });

  factory ParameterMapping.fromJson(Map<String, dynamic> json) {
    return ParameterMapping(
      prompt: json['prompt'],
      negativePrompt: json['negative_prompt'],
      cfgScale: json['cfg_scale'],
      aspectRatio: json['aspect_ratio'],
      width: json['width'],
      height: json['height'],
      modelId: json['model_id'] ?? 'model_id',
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
      'model_id': modelId,
    };
  }
}
