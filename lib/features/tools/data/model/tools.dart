import 'dart:io';
import 'package:pixart_app/imports.dart';
import 'package:pixart_app/features/tools/presentation/widgets/bg_remover_animation.dart';
import 'package:pixart_app/features/tools/presentation/widgets/upscale_animation.dart';

class ToolModel {
  final String name;
  final String description;
  final String image;
  final Widget? animation;
  final bool premium;

  ToolModel({
    required this.name,
    required this.description,
    required this.image,
    this.animation,
    this.premium = false,
  });

  // from json
  factory ToolModel.fromJson(Map<String, dynamic> json) {
    return ToolModel(
      name: json['name'],
      description: json['description'],
      image: json['image'],
      animation: json['animation'],
      premium: Platform.isAndroid
          ? json['premium']
          : json['ios_premium'] ?? false,
    );
  }
  static ToolModel backgroundRemoverTool = ToolModel(
    image: Images.bg_remover,
    animation: const BgRemoverAnimation(),
    name: 'ai_bg_remover',
    description: 'remove_background_easily',
  );
  static ToolModel upscaleImageTool = ToolModel(
    image: Images.toolsImage,
    animation: const UpscaleAnimation(),
    name: 'ai_upscale',
    description: 'upscale_images_to_higher_resolutions',
  );
}

List<ToolModel> get tools => [
  ToolModel.upscaleImageTool,
  ToolModel.backgroundRemoverTool,
];
