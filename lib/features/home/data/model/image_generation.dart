import 'package:pixart_app/features/home/data/model/model.dart';

class ImageGenerationResult {
  String status;
  String id;
  Meta meta;
  List<String> output;
  DateTime createdAt;
  bool bookmarked;

  ImageGenerationResult({
    required this.status,
    required this.id,
    required this.meta,
    required this.output,
    required this.createdAt,
    this.bookmarked = false,
  });

  factory ImageGenerationResult.fromJson(Map<String, dynamic> json) => ImageGenerationResult(
    status: json["status"],
    id: json["id"],
    meta: Meta.fromJson(json["meta"]),
    output: List<String>.from(json["output"].map((x) => x)),
    createdAt: DateTime.parse(json["created_at"]),
    bookmarked: json["bookmarked"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "id": id,
    "meta": meta.toJson(),
    "output": List<String>.from(output.map((x) => x)),
    "created_at": createdAt.toIso8601String(),
    "bookmarked": bookmarked,
  };

  // copy with
  ImageGenerationResult copyWith({
    String? status,
    String? id,
    Meta? meta,
    List<String>? output,
    DateTime? createdAt,
    bool? bookmarked,
  }) {
    return ImageGenerationResult(
      status: status ?? this.status,
      id: id ?? this.id,
      meta: meta ?? this.meta,
      output: output ?? this.output,
      createdAt: createdAt ?? this.createdAt,
      bookmarked: bookmarked ?? this.bookmarked,
    );
  }
}

class Meta {
  int height;
  int width;
  String prompt;
  Model model;
  int? seed;

  Meta({required this.height, required this.width, required this.prompt, required this.model, this.seed});

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    height: json["height"],
    width: json["width"],
    prompt: json["prompt"],
    model: Model.fromJson(json["model"]),
    seed: json["seed"],
  );

  Map<String, dynamic> toJson() => {
    "height": height,
    "width": width,
    "prompt": prompt,
    "model": model.toJson(),
    "seed": seed,
  };

  // copy with
  Meta copyWith({int? height, int? width, String? prompt, Model? model, int? seed}) {
    return Meta(
      height: height ?? this.height,
      width: width ?? this.width,
      prompt: prompt ?? this.prompt,
      model: model ?? this.model,
      seed: seed ?? this.seed,
    );
  }
}
