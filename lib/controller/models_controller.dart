import 'dart:async';
import 'package:matrix_ai/data/model/response/model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../data/service/model_service_interface.dart';
import 'generation_controller.dart';
import 'settings_controller.dart';

class ModelsController extends GetxController {
  final ModelsServiceInterface modelsService;

  ModelsController({required this.modelsService});

  static ModelsController get find => Get.find<ModelsController>();

  late MyModel _selectedModel;
  List<MyModel> _models = [];
  List<MyModel> _filteredModels = [];
  int _type = 0;
  final List<int> _favoriteModels = [];

  MyModel get selectedModel => _selectedModel;
  List<MyModel> get models => _models;
  List<MyModel> get filteredModels => _filteredModels;
  int get type => _type;
  List<int> get favoriteModels => _favoriteModels;

  set models(List<MyModel> value) {
    _models = value;
    update();
  }

  set type(int value) {
    _type = value;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    initFavoriteModels();
    getModels(); // Initialize this during controller init
  }

  Future<void> getModels() async {
    http.Response? response = await modelsService.fetchModels();
    if (response != null && response.statusCode == 200) {
      _models = modelsService.parseModels(response.body);
      _filteredModels = _models;

      final config = SettingsController.find.initSharedData();
      if (!config.onBoardingSkip) {
        config.selectedModel =
            _models.firstWhere((e) => e.isDefault == true).id;
      }
      update();
    }
  }

  void filterModels(int index) {
    _filteredModels =
        modelsService.filterModels(_models, _favoriteModels, index);
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

  bool canShowVideoAd() {
    return modelsService.canShowVideoAd(
      SettingsController.find.settingModel.freeGenerations,
      GenerationController.find.dailyGenerationCount,
    );
  }

  bool canShowInterstitialAd() {
    return modelsService.canShowInterstitialAd(
      SettingsController.find.settingModel.freeGenerations,
      GenerationController.find.dailyGenerationCount,
    );
  }
}
