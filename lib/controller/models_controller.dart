import 'dart:async';
import 'dart:convert';
import 'package:matrix_ai/data/model/response/model.dart';
import 'package:matrix_ai/data/repository/models_repo.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'generation_controller.dart';
import 'settings_controller.dart';

class ModelsController extends GetxController implements GetxService {
  final ModelsRepo modelsRepo;
  ModelsController({required this.modelsRepo});

  static ModelsController get find => Get.find<ModelsController>();

  @override
  onInit() {
    super.onInit();
    initFavoriteModels();
  }

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

  Future<void> getModels() async {
    http.Response? response = await modelsRepo.getModels();
    if (response != null) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> modelList = data['aiModels'];
      _models = modelList.map((e) => MyModel.fromJson(e)).toList();
      _filteredModels = _models;
      final config = SetttingsController.find.initSharedData();
      if (!config.onBoardingSkip) {
        config.selectedModel =
            _models.firstWhere((e) => e.isDefault == true).id;
      }
      update();
    }
  }

  void filterModels(int index) {
    type = index;
    if (type == 0) {
      _filteredModels = _models;
    } else if (type == 1) {
      _filteredModels = _models.where((e) => e.popular).toList();
    } else {
      _filteredModels =
          _models.where((e) => _favoriteModels.contains(e.id)).toList();
    }
  }

  void toggleFavorite(int id) {
    if (_favoriteModels.contains(id)) {
      _favoriteModels.remove(id);
    } else {
      _favoriteModels.add(id);
    }
    modelsRepo.saveFavoriteModel(_favoriteModels);
    update();
  }

  void initFavoriteModels() {
    _favoriteModels.addAll(modelsRepo.getFavoriteModels());
    update();
  }

  bool canShowVideoAd() {
    int count = SetttingsController.find.settingModel.freeGenerations -
        GenerationController.find.dailyGenerationCount;
    // show after 1 generations (at 2rd generation)
    if (count > 0 && count % 2 == 1) {
      return true;
    }
    return false;
  }

  bool canShowInterstitialAd() {
    int count = SetttingsController.find.settingModel.freeGenerations -
        GenerationController.find.dailyGenerationCount;
    // show after 2 generations (at 3rd generation)
    if (count > 0 && count % 2 == 0) {
      return true;
    }
    return false;
  }
}
