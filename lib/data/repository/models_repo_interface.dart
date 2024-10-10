import 'package:http/http.dart';

abstract class ModelsRepoInterface {
  Future<Response?> getModels();
  Future<bool> saveFavoriteModel(List<int> models);
  List<int> getFavoriteModels();
}
