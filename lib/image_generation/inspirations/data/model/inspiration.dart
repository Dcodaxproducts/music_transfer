class Inspiration {
  final int seed;
  final String image;
  final String prompt;
  final String? authorName;
  final String? authorUsername;
  final String? authorAvatar;

  Inspiration({
    required this.seed,
    required this.image,
    required this.prompt,
    this.authorName,
    this.authorUsername,
    this.authorAvatar,
  });

  factory Inspiration.fromJson(Map<String, dynamic> json) {
    return Inspiration(
      seed: int.parse(json['seed'].toString()),
      image: json['imageurl'],
      prompt: json['prompt'],
      authorName: json['author_name'],
      authorUsername: json['author_username'],
      authorAvatar: json['author_avatar'],
    );
  }
}
