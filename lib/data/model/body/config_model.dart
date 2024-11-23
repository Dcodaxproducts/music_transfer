import '../response/model.dart';

class ConfigModel {
  bool onBoardingSkip;
  double guidanceScale;
  int aspectRatio;
  Model? selectedModel;
  String negativePrompt;
  int? seed;
  bool notificationsEnabled;
  bool hasViewdAdsDialog;

  ConfigModel({
    required this.onBoardingSkip,
    required this.guidanceScale,
    required this.aspectRatio,
    required this.selectedModel,
    required this.negativePrompt,
    this.seed,
    required this.notificationsEnabled,
    required this.hasViewdAdsDialog,
  });

  // copy with
  ConfigModel copyWith({
    bool? onBoardingSkip,
    double? guidanceScale,
    int? aspectRatio,
    Model? selectedModel,
    String? negativePrompt,
    int? seed,
    bool? notificationsEnabled,
    bool? hasViewdAdsDialog,
  }) {
    return ConfigModel(
      onBoardingSkip: onBoardingSkip ?? this.onBoardingSkip,
      guidanceScale: guidanceScale ?? this.guidanceScale,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      selectedModel: selectedModel ?? this.selectedModel,
      negativePrompt: negativePrompt ?? this.negativePrompt,
      seed: seed ?? this.seed,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      hasViewdAdsDialog: hasViewdAdsDialog ?? this.hasViewdAdsDialog,
    );
  }
}
