import 'dart:io';
import 'package:matrix_ai/data/model/response/background_remover.dart';
import 'package:matrix_ai/data/model/response/upscale_image.dart';

class ToolModel {
  final String name;
  final String description;
  final String image;
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
}

List<ToolModel> get tools => [
      ToolModel(
        image: 'https://images.wondershare.com/virtulook/articles/best-ai-background-removal-tools-1.jpg',
        name: 'Background Remover',
        description: 'Remove the background from images easily.',
        apiKey: 'Ah9XwMqgVKaQLiMtxykW8SrNsJ0CypVEyyrudFINjH1yWij7SFZ35c7egoaI',
        apiUrl: 'https://modelslab.com/api/v6/image_editing/removebg_mask',
        queueUrl: 'https://modelslab.com/api/v6/image_editing/fetch',
        apiKeyLoation: 'body',
        backgroundRemover: BackgroundRemover.initialValue,
      ),
      ToolModel(
        image: 'https://i.imgur.com/xwnUhAb.png',
        name: 'Image Upscale',
        description: 'Upscale images to higher resolutions.',
        apiKey: 'Ah9XwMqgVKaQLiMtxykW8SrNsJ0CypVEyyrudFINjH1yWij7SFZ35c7egoaI',
        apiUrl: 'https://modelslab.com/api/v6/image_editing/super_resolution',
        queueUrl: 'https://modelslab.com/api/v6/image_editing/fetch',
        apiKeyLoation: 'body',
        upscaleImage: UpscaleImage.initialValue,
      ),
    ];
