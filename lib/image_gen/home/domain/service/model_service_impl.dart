import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pixart_app/image_gen/home/data/repository/models_repo.dart';
import '../../data/model/model.dart';
import 'model_service.dart';

class ModelsServiceImpl implements ModelsService {
  final ModelsRepo modelsRepo;
  ModelsServiceImpl({required this.modelsRepo});

  @override
  Future<List<Model>> fetchModels() async {
    http.Response? response = await modelsRepo.getModels();
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> modelList = data['data'];
      return modelList.map((e) => Model.fromJson(e)).toList();
    } else {
      return [];
    }
  }

  @override
  Future<bool> cacheModels(List<Model> models) async {
    List<Map<String, dynamic>> modelMaps = models.map((e) => e.toJson()).toList();
    String encodedJson = jsonEncode(modelMaps);
    return await modelsRepo.cacheModels(encodedJson);
  }

  @override
  List<Model> getCachedModels() {
    String? cachedModelsJson = modelsRepo.getCachedModels();
    if (cachedModelsJson != null) {
      List<dynamic> modelList = jsonDecode(cachedModelsJson);
      return modelList.map((e) => Model.fromJson(e)).toList();
    }
    return [];
  }

  @override
  Future<bool> saveSelectedModel(int modelId) async {
    return await modelsRepo.saveSelectedModel(modelId);
  }

  @override
  int? getSelectedModel() => modelsRepo.getSelectedModel();
}
