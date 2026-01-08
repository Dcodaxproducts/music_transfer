class ConfigModel {
  bool onBoardingSkip;
  bool notificationsEnabled;
  bool hasViewdAdsDialog;

  ConfigModel({
    required this.onBoardingSkip,
    required this.notificationsEnabled,
    required this.hasViewdAdsDialog,
  });

  // copy with
  ConfigModel copyWith({bool? onBoardingSkip, bool? notificationsEnabled, bool? hasViewdAdsDialog}) {
    return ConfigModel(
      onBoardingSkip: onBoardingSkip ?? this.onBoardingSkip,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      hasViewdAdsDialog: hasViewdAdsDialog ?? this.hasViewdAdsDialog,
    );
  }
}
