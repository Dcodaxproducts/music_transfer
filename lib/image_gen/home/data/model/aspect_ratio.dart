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

List<AspectRatioModel> get aspectRatios => [
  AspectRatioModel(id: 1, aspectRatio: '1:1', width: 1024, height: 1024),
  AspectRatioModel(id: 12, aspectRatio: '4:3', width: 1024, height: 768),
  AspectRatioModel(id: 10, aspectRatio: '3:2', width: 768, height: 512),
  AspectRatioModel(id: 6, aspectRatio: '2:3', width: 512, height: 768),
  AspectRatioModel(id: 8, aspectRatio: '16:9', width: 1024, height: 576),
  AspectRatioModel(id: 5, aspectRatio: '9:16', width: 576, height: 1024),
  AspectRatioModel(id: 11, aspectRatio: '5:4', width: 784, height: 632),
  AspectRatioModel(id: 3, aspectRatio: '3:4', width: 768, height: 1024),
  AspectRatioModel(id: 7, aspectRatio: '2:1', width: 1024, height: 512),
];
