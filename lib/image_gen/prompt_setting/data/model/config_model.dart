class ConfigModel {
  bool onBoardingSkip;
  double guidanceScale;
  bool notificationsEnabled;
  bool hasViewdAdsDialog;

  ConfigModel({
    required this.onBoardingSkip,
    required this.guidanceScale,
    required this.notificationsEnabled,
    required this.hasViewdAdsDialog,
  });

  // copy with
  ConfigModel copyWith({
    bool? onBoardingSkip,
    double? guidanceScale,
    bool? notificationsEnabled,
    bool? hasViewdAdsDialog,
  }) {
    return ConfigModel(
      onBoardingSkip: onBoardingSkip ?? this.onBoardingSkip,
      guidanceScale: guidanceScale ?? this.guidanceScale,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      hasViewdAdsDialog: hasViewdAdsDialog ?? this.hasViewdAdsDialog,
    );
  }
}
