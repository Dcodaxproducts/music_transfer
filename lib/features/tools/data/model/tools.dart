class ToolsNew {
  final int id;
  final String name;
  final String description;
  final String beforeImage;
  final String afterImage;
  final String endPoint;
  final String category;
  final bool premium;

  ToolsNew({
    required this.id,
    required this.name,
    required this.description,
    required this.beforeImage,
    required this.afterImage,
    required this.endPoint,
    required this.category,
    this.premium = false,
  });

  factory ToolsNew.fromJson(Map<String, dynamic> json) {
    return ToolsNew(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      beforeImage: json['before_image'],
      afterImage: json['after_image'],
      endPoint: json['api_endpoint'],
      category: json['category'],
      premium: json['is_pro'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'before_image': beforeImage,
      'after_image': afterImage,
      'api_endpoint': endPoint,
      'category': category,
      'is_pro': premium,
    };
  }
}
