class UpscaleImage {
  final String modelId;
  final int scale;
  final bool faceEnhance;

  UpscaleImage({
    required this.modelId,
    required this.scale,
    required this.faceEnhance,
  });

  // from json
  factory UpscaleImage.fromJson(Map<String, dynamic> json) {
    return UpscaleImage(
      modelId: json['model_id'],
      scale: json['scale'],
      faceEnhance: json['face_enhance'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'model_id': modelId,
      'scale': scale,
      'face_enhance': faceEnhance,
    };
  }

  // copy with
  UpscaleImage copyWith({
    String? key,
    String? initImage,
    String? modelId,
    int? scale,
    bool? faceEnhance,
  }) {
    return UpscaleImage(
      modelId: modelId ?? this.modelId,
      scale: scale ?? this.scale,
      faceEnhance: faceEnhance ?? this.faceEnhance,
    );
  }

  // initial value
  static UpscaleImage get initialValue => UpscaleImage(
        modelId: 'ultra_resolution',
        scale: 3,
        faceEnhance: false,
      );
}
