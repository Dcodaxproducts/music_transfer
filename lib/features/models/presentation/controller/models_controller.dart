import 'dart:async';
import 'package:matrix_ai/features/models/data/model/model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../domain/service/model_service_interface.dart';
import '../../../prompt_setting/presentation/controller/settings_controller.dart';

class ModelsController extends GetxController {
  final ModelsServiceInterface modelsService;
  ModelsController({required this.modelsService});

  static ModelsController get find => Get.find<ModelsController>();

  List<Model> _models = [];
  List<Model> _filteredModels = [];
  int _type = 0;
  final List<int> _favoriteModels = [];

  List<Model> get models => _models;
  List<Model> get filteredModels => _filteredModels;
  int get type => _type;
  List<int> get favoriteModels => _favoriteModels;

  set models(List<Model> value) {
    _models = value;
    update();
  }

  set type(int value) {
    _type = value;
    update();
  }

  Future<void> getModels() async {
    initFavoriteModels();
    http.Response? response = await modelsService.fetchModels();
    if (response != null && response.statusCode == 200) {
      _models = modelsService.parseModels(response.body);
      _filteredModels = _models;

      final config = SettingsController.find.configModel;
      if (!config.onBoardingSkip) {
        config.selectedModel = _models.firstWhere((e) => e.isDefault == true);
      }
      update();
    }
  }

  void filterModels(int index) {
    _filteredModels = modelsService.filterModels(_models, _favoriteModels, index);
    type = index;
    update();
  }

  void toggleFavorite(int id) {
    modelsService.toggleFavorite(id, _favoriteModels);
    update();
  }

  void initFavoriteModels() {
    _favoriteModels.addAll(modelsService.getFavoriteModels());
    update();
  }
}
