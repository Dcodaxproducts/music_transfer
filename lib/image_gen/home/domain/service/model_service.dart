import 'dart:async';
import 'package:pixart_app/image_gen/home/data/model/model.dart';

abstract class ModelsService {
  Future<List<Model>> fetchModels();

  Future<bool> cacheModels(List<Model> models);
  List<Model> getCachedModels();

  Future<bool> saveSelectedModel(int modelId);
  int? getSelectedModel();
}
