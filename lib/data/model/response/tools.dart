import 'dart:io';
import 'package:matrix_ai/data/model/response/background_remover.dart';
import 'package:matrix_ai/data/model/response/upscale_image.dart';
import 'package:matrix_ai/imports.dart';
import 'package:matrix_ai/view/screens/tools/widgets/background_remover_animation.dart';
import 'package:matrix_ai/view/screens/tools/widgets/upscale_animation.dart';

class ToolModel {
  final String name;
  final String description;
  final String image;
  final Widget? animation;
  final String apiUrl;
  final String apiKey;
  final String queueUrl;
  final String apiKeyLoation;
  final bool premium;
  final UpscaleImage? upscaleImage;
  final BackgroundRemover? backgroundRemover;

  ToolModel({
    required this.name,
    required this.description,
    required this.image,
    this.animation,
    required this.apiKey,
    required this.apiUrl,
    required this.queueUrl,
    required this.apiKeyLoation,
    this.premium = false,
    this.upscaleImage,
    this.backgroundRemover,
  });

  // from json
  factory ToolModel.fromJson(Map<String, dynamic> json) {
    return ToolModel(
      name: json['name'],
      description: json['description'],
      image: json['image'],
      animation: json['animation'],
      apiUrl: json['api_url'],
      apiKey: json['api_key'],
      queueUrl: json['queue_url'] ?? '',
      apiKeyLoation: json['api_key_location'],
      premium: Platform.isAndroid ? json['premium'] : json['ios_premium'] ?? false,
      upscaleImage: json['upscale_image'] != null ? UpscaleImage.fromJson(json['upscale_image']) : null,
      backgroundRemover:
          json['background_remover'] != null ? BackgroundRemover.fromJson(json['background_remover']) : null,
    );
  }
  static ToolModel backgroundRemoverTool = ToolModel(
    image: Images.bg_remover,
    animation: const BackgroundRemoverAnimation(),
    name: 'ai_bg_remover',
    description: 'remove_background_easily',
    apiKey: 'Ah9XwMqgVKaQLiMtxykW8SrNsJ0CypVEyyrudFINjH1yWij7SFZ35c7egoaI',
    apiUrl: 'https://modelslab.com/api/v6/image_editing/removebg_mask',
    queueUrl: 'https://modelslab.com/api/v6/image_editing/fetch',
    apiKeyLoation: 'body',
    backgroundRemover: BackgroundRemover.initialValue,
  );
  static ToolModel upscaleImageTool = ToolModel(
    image: Images.toolsImage,
    animation: const UpscaleAnimation(),
    name: 'ai_upscale',
    description: 'upscale_images_to_higher_resolutions',
    apiKey: 'Ah9XwMqgVKaQLiMtxykW8SrNsJ0CypVEyyrudFINjH1yWij7SFZ35c7egoaI',
    apiUrl: 'https://modelslab.com/api/v6/image_editing/super_resolution',
    queueUrl: 'https://modelslab.com/api/v6/image_editing/fetch',
    apiKeyLoation: 'body',
    upscaleImage: UpscaleImage.initialValue,
  );
}

List<ToolModel> get tools => [ToolModel.upscaleImageTool, ToolModel.backgroundRemoverTool];
