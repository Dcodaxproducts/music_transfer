class BgRemoverResult {
  String id;
  String status;
  String image;
  DateTime createdAt;

  BgRemoverResult({
    required this.status,
    required this.id,
    required this.image,
    required this.createdAt,
  });

  factory BgRemoverResult.fromJson(Map<String, dynamic> json) =>
      BgRemoverResult(
        id: json["id"],
        status: json["status"],
        image: json["image_url"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "image_url": image,
    "created_at": createdAt.toIso8601String(),
  };
}
