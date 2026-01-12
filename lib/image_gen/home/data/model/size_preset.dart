class SizePreset {
  final int id;
  final String aspectRatio;
  final int height;
  final int width;
  SizePreset({required this.id, required this.aspectRatio, required this.height, required this.width});

  factory SizePreset.fromJson(Map<String, dynamic> json) {
    return SizePreset(
      id: json['id'],
      aspectRatio: json['aspect_ratio'],
      height: json['height'],
      width: json['width'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'aspect_ratio': aspectRatio, 'height': height, 'width': width};
  }

  static SizePreset defaultPreset() {
    return SizePreset(id: 1, aspectRatio: "1:1", height: 1024, width: 1024);
  }
}
