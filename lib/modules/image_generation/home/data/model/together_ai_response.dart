class TogetherAiRespsonse {
  String id;
  String model;
  String object;
  List<Data> data;

  TogetherAiRespsonse({required this.id, required this.model, required this.object, required this.data});

  factory TogetherAiRespsonse.fromJson(Map<String, dynamic> json) {
    return TogetherAiRespsonse(
      id: json['id'],
      model: json['model'],
      object: json['object'],
      data: List<Data>.from(json['data'].map((x) => Data.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'object': object,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class Data {
  int index;
  String url;
  Timings timings;

  Data({required this.index, required this.url, required this.timings});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(index: json['index'], url: json['url'], timings: Timings.fromJson(json['timings']));
  }

  Map<String, dynamic> toJson() {
    return {'index': index, 'url': url, 'timings': timings.toJson()};
  }
}

class Timings {
  double inference;
  Timings({required this.inference});

  factory Timings.fromJson(Map<String, dynamic> json) {
    return Timings(inference: json['inference']);
  }

  Map<String, dynamic> toJson() => {'inference': inference};
}
