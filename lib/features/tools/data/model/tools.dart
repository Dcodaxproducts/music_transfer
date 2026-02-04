import '../../../home/data/model/model.dart';

class ToolCategory {
  final int id;
  final String title;
  final List<Tool> tools;

  ToolCategory({required this.id, required this.title, required this.tools});

  factory ToolCategory.fromJson(Map<String, dynamic> json) {
    var toolsList = <Tool>[];
    if (json['tools'] != null) {
      toolsList = List<Tool>.from(json['tools'].map((tool) => Tool.fromJson(tool)));
    }
    return ToolCategory(id: json['id'], title: json['title'], tools: toolsList);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'tools': tools.map((tool) => tool.toJson()).toList()};
  }
}

class Tool {
  final int id;
  final String name;
  final String description;
  final String? prompt;
  final Model? model;
  final String beforeImage;
  final String? afterImage;
  final String endPoint;
  final String category;
  final bool premium;
  final int credits;
  final int inputImages;
  final String? guideline;

  Tool({
    required this.id,
    required this.name,
    required this.description,
    this.prompt,
    this.model,
    required this.beforeImage,
    this.afterImage,
    required this.endPoint,
    required this.category,
    this.premium = false,
    this.credits = 0,
    this.inputImages = 1,
    this.guideline,
  });

  factory Tool.fromJson(Map<String, dynamic> json) {
    return Tool(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      prompt: json['prompt'],
      model: json['model'] != null ? Model.fromJson(json['model']) : null,
      beforeImage: json['before_image'],
      afterImage: json['after_image'],
      endPoint: json['api_endpoint'],
      category: json['category'],
      premium: json['is_pro'] ?? false,
      credits: json['credits'] ?? 0,
      inputImages: json['input_images'] ?? 1,
      guideline: json['guideline'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'prompt': prompt,
      'model': model?.toJson(),
      'before_image': beforeImage,
      'after_image': afterImage,
      'api_endpoint': endPoint,
      'category': category,
      'is_pro': premium,
      'credits': credits,
      'input_images': inputImages,
      'guideline': guideline,
    };
  }
}
