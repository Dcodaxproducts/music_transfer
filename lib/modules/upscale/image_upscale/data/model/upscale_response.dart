import '../../../../image_generation/home/data/model/models_lab_response.dart';

class UpscaleResponse {
  String status;
  double? eta;
  int id;
  List<String> output;
  List<String> futureLinks;
  DateTime? createdAt;
  String? queueUrl;
  String? apiKey;
  bool isBackgroundRemover;

  UpscaleResponse({
    required this.status,
    required this.id,
    required this.eta,
    required this.output,
    required this.futureLinks,
    this.createdAt,
    this.queueUrl,
    this.apiKey,
    this.isBackgroundRemover = true,
  });

  factory UpscaleResponse.fromJson(Map<String, dynamic> json) => UpscaleResponse(
        status: json["status"],
        id: json["id"] ?? DateTime.now().millisecondsSinceEpoch,
        eta: json["eta"]?.toDouble(),
        output: getOutput(json),
        futureLinks: json["future_links"] == null
            ? []
            : List<String>.from(
                json["future_links"].map((x) => x),
              ),
        createdAt: json["created_at"] != null ? DateTime.parse(json["created_at"]) : null,
        queueUrl: json["queue_url"],
        apiKey: json["api_key"],
        isBackgroundRemover: json["is_background_remover"] ?? true,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "id": id,
        "eta": eta,
        "output": List<String>.from(output.map((x) => x)),
        "future_links": List<String>.from(futureLinks.map((x) => x)),
        "created_at": createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
        "queue_url": queueUrl,
        "api_key": apiKey,
        "is_background_remover": isBackgroundRemover,
      };

  // copy with
  UpscaleResponse copyWith({
    String? status,
    int? id,
    double? eta,
    List<String>? output,
    List<String>? futureLinks,
    DateTime? createdAt,
    String? queueUrl,
    String? apiKey,
    bool? isBackgroundRemover,
  }) {
    return UpscaleResponse(
      status: status ?? this.status,
      id: id ?? this.id,
      eta: eta ?? this.eta,
      output: output ?? this.output,
      futureLinks: futureLinks ?? this.futureLinks,
      createdAt: createdAt ?? this.createdAt,
      queueUrl: queueUrl ?? this.queueUrl,
      apiKey: apiKey ?? this.apiKey,
      isBackgroundRemover: isBackgroundRemover ?? this.isBackgroundRemover,
    );
  }
}
