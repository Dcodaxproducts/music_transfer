import 'package:matrix_ai/data/model/response/model.dart';

class PromptResponse {
  String status;
  double? eta;
  int id;
  Meta meta;
  List<String> output;
  List<String> futureLinks;
  DateTime? createdAt;
  bool bookmarked;
  Model? model;
  List<int>? linkedResponses;

  PromptResponse({
    required this.status,
    required this.id,
    required this.meta,
    required this.eta,
    required this.output,
    required this.futureLinks,
    this.createdAt,
    this.bookmarked = false,
    this.model,
    this.linkedResponses,
  });

  factory PromptResponse.fromJson(Map<String, dynamic> json) => PromptResponse(
        status: json["status"],
        id: json["id"] ?? DateTime.now().millisecondsSinceEpoch,
        meta: Meta.fromJson(json["meta"]),
        eta: json["eta"]?.toDouble(),
        output: getOutput(json),
        futureLinks: json["future_links"] == null
            ? []
            : List<String>.from(
                json["future_links"].map((x) => x),
              ),
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
        bookmarked: json["bookmarked"] ?? false,
        model: json["model"] != null ? Model.fromJson(json["model"]) : null,
        linkedResponses:
            json["linked_responses"] != null ? List<int>.from(json["linked_responses"].map((x) => x)) : [],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "id": id,
        "meta": meta.toJson(),
        "eta": eta,
        "output": List<String>.from(output.map((x) => x)),
        "future_links": List<String>.from(futureLinks.map((x) => x)),
        "created_at": createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
        "bookmarked": bookmarked,
        'model': model?.toJson(),
        'linked_responses': List<int>.from((linkedResponses ?? []).map((x) => x)),
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
    Model? model,
    List<int>? linkedResponses,
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
      model: model ?? this.model,
      linkedResponses: linkedResponses ?? this.linkedResponses,
    );
  }
}

class Meta {
  int h;
  int w;
  String prompt;
  int seed;

  Meta({
    required this.h,
    required this.w,
    required this.prompt,
    required this.seed,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        h: json["H"] ?? json["height"],
        w: json["W"] ?? json["width"],
        prompt: json["prompt"],
        seed: json["seed"],
      );

  Map<String, dynamic> toJson() => {
        "H": h,
        "W": w,
        "prompt": prompt,
        "seed": seed,
      };

  // copy with
  Meta copyWith({
    int? h,
    int? w,
    String? prompt,
    int? seed,
  }) {
    return Meta(
      h: h ?? this.h,
      w: w ?? this.w,
      prompt: prompt ?? this.prompt,
      seed: seed ?? this.seed,
    );
  }
}

List<String> getOutput(Map<String, dynamic> body) {
  if (body['output'] != null && body['output'].isNotEmpty) {
    return List<String>.from(body['output'].map((x) => x));
  }
  return [];
}
