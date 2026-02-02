import 'package:pixart_app/features/home/data/model/size_preset.dart';

class Model {
  final int id;
  final String modelId;
  final String name;
  final String description;
  final String image;
  final bool isPro;
  final bool supportImage;
  final bool requiresImage;
  final int creditsPerImage;
  final bool expensive;
  final bool isDefault;
  final List<SizePreset> sizes;

  Model({
    required this.id,
    required this.modelId,
    required this.name,
    required this.image,
    required this.isPro,
    required this.description,
    required this.supportImage,
    this.requiresImage = false,
    required this.creditsPerImage,
    required this.expensive,
    this.isDefault = false,
    this.sizes = const [],
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      id: json['id'],
      modelId: json['model_id'],
      name: json['name'],
      image: json['image'],
      description: json['description'] ?? '',
      isPro: json['is_pro'] ?? false,
      supportImage: json['support_image'] ?? false,
      requiresImage: json['requires_image'] ?? false,
      creditsPerImage: json['credits_per_image'] ?? 5,
      expensive: json['expensive'] ?? false,
      isDefault: json['is_default'] ?? false,
      sizes: json['sizes'] != null
          ? List<SizePreset>.from(json['sizes'].map((x) => SizePreset.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model_id': modelId,
      'name': name,
      'image': image,
      'description': description,
      'is_pro': isPro,
      'support_image': supportImage,
      'requires_image': requiresImage,
      'credits_per_image': creditsPerImage,
      'expensive': expensive,
      'is_default': isDefault,
      'sizes': sizes.map((x) => x.toJson()).toList(),
    };
  }
}
