class BackgroundRemover {
  final bool alphaMatting;
  final bool postProcessMask;
  final bool onlyMask;
  final int? seed;
  final int? alphaMattingForegroundThreshold;
  final int? alphaMattingBackgroundThreshold;
  final int? alphaMattingErodeSize;

  BackgroundRemover({
    required this.alphaMatting,
    required this.postProcessMask,
    required this.onlyMask,
    this.seed,
    this.alphaMattingForegroundThreshold,
    this.alphaMattingBackgroundThreshold,
    this.alphaMattingErodeSize,
  });

  // from json
  factory BackgroundRemover.fromJson(Map<String, dynamic> json) {
    return BackgroundRemover(
      alphaMatting: json['alpha_matting'],
      postProcessMask: json['post_process_mask'],
      onlyMask: json['only_mask'],
      seed: json['seed'],
      alphaMattingForegroundThreshold: json['alpha_matting_foreground_threshold'],
      alphaMattingBackgroundThreshold: json['alpha_matting_background_threshold'],
      alphaMattingErodeSize: json['alpha_matting_erode_size'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'alpha_matting': alphaMatting,
      'post_process_mask': postProcessMask,
      'only_mask': onlyMask,
      'seed': seed,
      'alpha_matting_foreground_threshold': alphaMattingForegroundThreshold,
      'alpha_matting_background_threshold': alphaMattingBackgroundThreshold,
      'alpha_matting_erode_size': alphaMattingErodeSize,
    };
  }

  // copy with
  BackgroundRemover copyWith({
    bool? alphaMatting,
    bool? postProcessMask,
    bool? onlyMask,
    int? seed,
    int? alphaMattingForegroundThreshold,
    int? alphaMattingBackgroundThreshold,
    int? alphaMattingErodeSize,
  }) {
    return BackgroundRemover(
      alphaMatting: alphaMatting ?? this.alphaMatting,
      postProcessMask: postProcessMask ?? this.postProcessMask,
      onlyMask: onlyMask ?? this.onlyMask,
      seed: seed ?? this.seed,
      alphaMattingForegroundThreshold:
          alphaMattingForegroundThreshold ?? this.alphaMattingForegroundThreshold,
      alphaMattingBackgroundThreshold:
          alphaMattingBackgroundThreshold ?? this.alphaMattingBackgroundThreshold,
      alphaMattingErodeSize: alphaMattingErodeSize ?? this.alphaMattingErodeSize,
    );
  }

  // initial value
  static BackgroundRemover get initialValue => BackgroundRemover(
        alphaMatting: false,
        postProcessMask: false,
        onlyMask: false,
        alphaMattingBackgroundThreshold: 20,
        alphaMattingForegroundThreshold: 240,
        alphaMattingErodeSize: 5,
      );
}
