import 'package:flutter/foundation.dart';
import 'package:pixart_app/imports.dart';
import '../enum/ad_type.dart';
import '../enum/ad_position.dart';

class AdModel {
  int id;
  AdType? type;
  bool active;
  String adId;
  AdPosition position;

  AdModel({
    required this.id,
    required this.type,
    required this.active,
    required this.adId,
    required this.position,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'],
      type: AdType.fromString(GetPlatform.isAndroid ? json['type'] : (json['ios_type'] ?? json['type'])),
      active: Platform.isAndroid ? json['status'] == 1 : json['ios_status'] == 1,
      adId: GetPlatform.isAndroid ? json['android_ad_id'] ?? '' : json['ios_ad_id'] ?? '',
      position: AdPosition.fromString(json['position']),
    );
  }

  String getAdId() {
    String id = adId;
    if (!kDebugMode) {
      id = type?.testId ?? adId;
    }
    return id;
  }
}
