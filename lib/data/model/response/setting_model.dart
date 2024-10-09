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
        freeGenerations: json["free_generations"] ?? 0,
      );
}
