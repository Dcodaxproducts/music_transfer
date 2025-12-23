import 'dart:io';
import '../../../../../features/ads/data/enum/ad_type.dart';
import '../../../../../features/ads/data/extension/ad_type.dart';

class Model {
  final int id;
  final String name;
  final String image;
  final bool premium;
  final bool popular;
  final bool isDefault;
  final String shortDescription;
  final AdType? adType;
  final String? adId;

  Model({
    required this.id,
    required this.name,
    required this.image,
    required this.premium,
    required this.popular,
    required this.isDefault,
    required this.shortDescription,
    this.adType,
    this.adId,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      premium: Platform.isAndroid
          ? json['premium']
          : (json['ios_premium'] ?? false),
      popular: json['popular'] ?? false,
      isDefault: json['default'] ?? false,
      shortDescription: json['short_desc'] ?? '',
      adType: AdTypeExtension.fromString(json['ad_type']),
      adId: json['ad_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'premium': premium,
      'popular': popular,
      'default': isDefault,
      'short_desc': shortDescription,
      'ad_type': adType?.name,
      'ad_id': adId,
    };
  }
}
