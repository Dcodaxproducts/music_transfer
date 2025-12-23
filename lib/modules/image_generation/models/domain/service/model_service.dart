import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pixart_app/modules/image_generation/models/data/repository/models_repo_interface.dart';
import '../../data/model/model.dart';
import 'model_service_interface.dart';

class ModelsService implements ModelsServiceInterface {
  final ModelsRepoInterface modelsRepo;
  ModelsService({required this.modelsRepo});

  @override
  Future<http.Response?> fetchModels() async {
    return await modelsRepo.getModels();
  }

  @override
  List<int> getFavoriteModels() {
    return modelsRepo.getFavoriteModels();
  }

  @override
  Future<void> saveFavoriteModels(List<int> favoriteModels) async {
    modelsRepo.saveFavoriteModel(favoriteModels);
  }

  @override
  List<Model> filterModels(
    List<Model> models,
    List<int> favoriteModels,
    int type,
  ) {
    if (type == 0) {
      return models;
    } else if (type == 1) {
      return models.where((e) => e.popular).toList();
    } else {
      return models.where((e) => favoriteModels.contains(e.id)).toList();
    }
  }

  @override
  List<Model> parseModels(String responseBody) {
    Map<String, dynamic> data = jsonDecode(responseBody);
    List<dynamic> modelList = data['aiModels'];
    return modelList.map((e) => Model.fromJson(e)).toList();
  }

  @override
  void toggleFavorite(int id, List<int> favoriteModels) {
    if (favoriteModels.contains(id)) {
      favoriteModels.remove(id);
    } else {
      favoriteModels.add(id);
    }
    modelsRepo.saveFavoriteModel(favoriteModels);
  }
}
