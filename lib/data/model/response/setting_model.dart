import 'dart:io';

class SettingModel {
  String termsAndConditions;
  String privacyPolicy;
  String userAgreement;
  String cancelAnytime;
  int freeGenerations;

  SettingModel({
    required this.termsAndConditions,
    required this.privacyPolicy,
    required this.userAgreement,
    required this.cancelAnytime,
    required this.freeGenerations,
  });

  // from json
  factory SettingModel.fromJson(Map<String, dynamic> json) => SettingModel(
        termsAndConditions: json["terms_condition"]["value"],
        privacyPolicy: json["privacy_policy"]["value"],
        userAgreement: json["user_agreement"]["value"],
        cancelAnytime: json["cancel_anytime"]["value"],
        freeGenerations: (Platform.isAndroid
                ? json["free_generations"]
                : json["ios_free_generations"]) ??
            0,
      );

  // to json
  Map<String, dynamic> toJson() => {
        "terms_condition": {"value": termsAndConditions},
        "privacy_policy": {"value": privacyPolicy},
        "user_agreement": {"value": userAgreement},
        "cancel_anytime": {"value": cancelAnytime},
        "free_generations": freeGenerations,
      };
}
