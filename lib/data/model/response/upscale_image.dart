class UpscaleImage {
  final int scale;
  final bool faceEnhance;

  UpscaleImage({
    required this.scale,
    required this.faceEnhance,
  });

  // from json
  factory UpscaleImage.fromJson(Map<String, dynamic> json) {
    return UpscaleImage(
      scale: json['scale'],
      faceEnhance: json['face_enhance'],
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
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
      scale: scale ?? this.scale,
      faceEnhance: faceEnhance ?? this.faceEnhance,
    );
  }

  // initial value
  static UpscaleImage get initialValue => UpscaleImage(scale: 3, faceEnhance: false);
}
