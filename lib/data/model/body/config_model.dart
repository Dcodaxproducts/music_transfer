class ConfigModel {
  bool onBoardingSkip;
  double guidanceScale;
  int steps;
  int aspectRatio;
  int selectedModel;
  int selectedStyle;
  String negativePrompt;
  int? seed;

  ConfigModel({
    required this.onBoardingSkip,
    required this.guidanceScale,
    required this.steps,
    required this.aspectRatio,
    required this.selectedModel,
    required this.selectedStyle,
    required this.negativePrompt,
    this.seed,
  });

  // copy with
  ConfigModel copyWith({
    bool? onBoardingSkip,
    double? guidanceScale,
    int? steps,
    int? aspectRatio,
    int? selectedModel,
    int? selectedStyle,
    bool? panoramaImage,
    String? negativePrompt,
    int? seed,
  }) {
    return ConfigModel(
      onBoardingSkip: onBoardingSkip ?? this.onBoardingSkip,
      guidanceScale: guidanceScale ?? this.guidanceScale,
      steps: steps ?? this.steps,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      selectedModel: selectedModel ?? this.selectedModel,
      selectedStyle: selectedStyle ?? this.selectedStyle,
      negativePrompt: negativePrompt ?? this.negativePrompt,
      seed: seed ?? this.seed,
    );
  }
}
