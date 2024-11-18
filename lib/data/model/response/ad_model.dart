import 'package:matrix_ai/data/model/response/model.dart';

class AdModel {
  int id;
  AdType? type;
  bool active;
  String androidAdId;
  String iosAdId;
  AdPosition position;

  AdModel({
    required this.id,
    required this.type,
    required this.active,
    required this.androidAdId,
    required this.iosAdId,
    required this.position,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'],
      type: AdTypeExtension.fromString(json['type']),
      active: json['status'] == 1,
      androidAdId: json['android_ad_id'] ?? '',
      iosAdId: json['ios_ad_id'] ?? '',
      position: AdPositionExtension.fromString(json['position']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type?.name,
      'status': active,
      'android_ad_id': androidAdId,
      'ios_ad_id': iosAdId,
      'position': position.name,
    };
  }
}

enum AdPosition {
  appOpen,
  modelScreen,
  promptSettingScreen,
  resultScreen,
  historyScreen,
  inspirationScreen,
  onGenerateVideo,
  onGenerateInterstitial,
  languageScreen,
}

extension AdPositionExtension on AdPosition {
  String get name {
    switch (this) {
      case AdPosition.appOpen:
        return 'app_open';
      case AdPosition.modelScreen:
        return 'model_screen';
      case AdPosition.promptSettingScreen:
        return 'prompt_setting_screen';
      case AdPosition.resultScreen:
        return 'result_screen';
      case AdPosition.historyScreen:
        return 'history_screen';
      case AdPosition.inspirationScreen:
        return 'inspiration_screen';
      case AdPosition.onGenerateVideo:
        return 'on_generate_video';
      case AdPosition.onGenerateInterstitial:
        return 'on_generate_interstitial';
      case AdPosition.languageScreen:
        return 'language_screen';
    }
  }

  static AdPosition fromString(String value) {
    switch (value) {
      case 'app_open':
        return AdPosition.appOpen;
      case 'model_screen':
        return AdPosition.modelScreen;
      case 'prompt_setting_screen':
        return AdPosition.promptSettingScreen;
      case 'result_screen':
        return AdPosition.resultScreen;
      case 'history_screen':
        return AdPosition.historyScreen;
      case 'inspiration_screen':
        return AdPosition.inspirationScreen;
      case 'on_generate_video':
        return AdPosition.onGenerateVideo;
      case 'on_generate_interstitial':
        return AdPosition.onGenerateInterstitial;
      case 'language_screen':
        return AdPosition.languageScreen;
      default:
        return AdPosition.appOpen;
    }
  }
}
