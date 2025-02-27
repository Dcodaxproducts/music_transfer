import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:matrix_ai/features/models/data/model/model.dart';

abstract class ModelsServiceInterface {
  Future<http.Response?> fetchModels();

  List<int> getFavoriteModels();

  Future<void> saveFavoriteModels(List<int> favoriteModels);

  List<Model> filterModels(
      List<Model> models, List<int> favoriteModels, int type);

  List<Model> parseModels(String responseBody);

  void toggleFavorite(int id, List<int> favoriteModels);
}
