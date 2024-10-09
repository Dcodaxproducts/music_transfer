class PromptResponse {
  String status;
  double? eta;
  int id;
  Meta meta;
  List<String> output;
  List<String> futureLinks;
  DateTime? createdAt;
  bool bookmarked;

  PromptResponse({
    required this.status,
    required this.id,
    required this.meta,
    required this.eta,
    required this.output,
    required this.futureLinks,
    this.createdAt,
    this.bookmarked = false,
  });

  factory PromptResponse.fromJson(Map<String, dynamic> json) => PromptResponse(
        status: json["status"],
        id: json["id"],
        meta: Meta.fromJson(json["meta"]),
        eta: json["eta"]?.toDouble(),
        output: json["output"] == null
            ? []
            : List<String>.from(
                json["output"].map((x) => x),
              ),
        futureLinks: json["future_links"] == null
            ? []
            : List<String>.from(
                json["future_links"].map((x) => x),
              ),
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
        bookmarked: json["bookmarked"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "id": id,
        "meta": meta.toJson(),
        "eta": eta,
        "output": List<String>.from(output.map((x) => x)),
        "future_links": List<String>.from(futureLinks.map((x) => x)),
        "created_at": createdAt?.toIso8601String() ?? DateTime.now(),
        "bookmarked": bookmarked,
      };

  // copy with
  PromptResponse copyWith({
    String? status,
    int? id,
    Meta? meta,
    double? eta,
    List<String>? output,
    List<String>? futureLinks,
    DateTime? createdAt,
    bool? bookmarked,
  }) {
    return PromptResponse(
      status: status ?? this.status,
      id: id ?? this.id,
      meta: meta ?? this.meta,
      eta: eta ?? this.eta,
      output: output ?? this.output,
      futureLinks: futureLinks ?? this.futureLinks,
      createdAt: createdAt ?? this.createdAt,
      bookmarked: bookmarked ?? this.bookmarked,
    );
  }
}

class Meta {
  int h;
  int w;
  String? model;
  String prompt;
  int seed;

  Meta({
    required this.h,
    required this.w,
    required this.model,
    required this.prompt,
    required this.seed,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        h: json["H"] ?? json["height"],
        w: json["W"] ?? json["width"],
        model: json["model_id"] ?? json["model"],
        prompt: json["prompt"],
        seed: json["seed"],
      );

  Map<String, dynamic> toJson() => {
        "H": h,
        "W": w,
        "model_id": model,
        "model": model,
        "prompt": prompt,
        "seed": seed,
      };

  // copy with
  Meta copyWith({
    int? h,
    int? w,
    String? model,
    String? prompt,
    int? seed,
  }) {
    return Meta(
      h: h ?? this.h,
      w: w ?? this.w,
      model: model ?? this.model,
      prompt: prompt ?? this.prompt,
      seed: seed ?? this.seed,
    );
  }
}
