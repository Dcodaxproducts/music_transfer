class Inspiration {
  int seed;
  String image;
  String prompt;

  Inspiration({
    required this.seed,
    required this.image,
    required this.prompt,
  });

  factory Inspiration.fromJson(Map<String, dynamic> json) {
    return Inspiration(
      seed: int.parse(json['seed'].toString()),
      image: json['imageurl'],
      prompt: json['prompt'],
    );
  }
}
