class AspectRatioModel {
  final int id;
  final String aspectRatio;
  final int height;
  final int width;
  AspectRatioModel({
    required this.id,
    required this.aspectRatio,
    required this.height,
    required this.width,
  });

  factory AspectRatioModel.fromJson(Map<String, dynamic> json) {
    return AspectRatioModel(
      id: json['id'],
      aspectRatio: json['aspectRatio'],
      height: json['height'],
      width: json['width'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'aspectRatio': aspectRatio,
      'height': height,
      'width': width,
    };
  }
}

// Exact dimensions supported by Together AI image models (from API)
List<AspectRatioModel> get aspectRatios => [
  AspectRatioModel(id: 1, aspectRatio: '1:1', width: 1024, height: 1024),
  AspectRatioModel(id: 2, aspectRatio: '3:2', width: 1264, height: 848),
  AspectRatioModel(id: 3, aspectRatio: '2:3', width: 848, height: 1264),
  AspectRatioModel(id: 4, aspectRatio: '4:3', width: 1200, height: 896),
  AspectRatioModel(id: 5, aspectRatio: '3:4', width: 896, height: 1200),
  AspectRatioModel(id: 6, aspectRatio: '4:5', width: 928, height: 1152),
  AspectRatioModel(id: 7, aspectRatio: '5:4', width: 1152, height: 928),
  AspectRatioModel(id: 8, aspectRatio: '9:16', width: 768, height: 1376),
  AspectRatioModel(id: 9, aspectRatio: '16:9', width: 1376, height: 768),
  AspectRatioModel(id: 10, aspectRatio: '21:9', width: 1584, height: 672),
];
