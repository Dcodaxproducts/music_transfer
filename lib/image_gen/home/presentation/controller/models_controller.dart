import 'dart:async';
import 'package:pixart_app/image_gen/home/data/model/aspect_ratio.dart';
import 'package:pixart_app/image_gen/home/data/model/model.dart';
import 'package:get/get.dart';
import '../../domain/service/model_service.dart';

class ModelsController extends GetxController {
  final ModelsService modelsService;
  ModelsController({required this.modelsService});

  static ModelsController get find => Get.find<ModelsController>();

  final List<Model> _models = [];
  List<Model> get models => _models;

  Model? _selectedModel;
  Model? get selectedModel => _selectedModel;

  AspectRatioModel _selectedAspectRatio = aspectRatios.first;
  AspectRatioModel get selectedAspectRatio => _selectedAspectRatio;

  Future<void> getModels() async {
    _models.clear();

    // get cached models first
    List<Model> cachedModels = modelsService.getCachedModels();
    if (cachedModels.isNotEmpty) {
      _models.addAll(cachedModels);
      _getSelectedModel();
      _getSelectedAspectRatio();
      update();
    }

    // fetch from API
    List<Model> fetchedModels = await modelsService.fetchModels();
    if (fetchedModels.isNotEmpty) {
      _models.clear();
      _models.addAll(fetchedModels);
      _getSelectedModel();
      _getSelectedAspectRatio();
      await modelsService.cacheModels(fetchedModels);
      update();
    }
  }

  void _getSelectedModel() {
    int? selectedId = modelsService.getSelectedModel();
    if (selectedId != null) {
      _selectedModel = _models.firstWhere((model) => model.id == selectedId, orElse: () => _models.first);
    } else {
      _selectedModel = _models.isNotEmpty
          ? _models.firstWhere((model) => !model.isPro, orElse: () => _models.first)
          : null;
    }
    update();
  }

  Future<void> selectModel(Model model) async {
    _selectedModel = model;
    update();
    await modelsService.saveSelectedModel(model.id);
  }

  void _getSelectedAspectRatio() {
    int? selectedId = modelsService.getSelectedAspectRatio();
    if (selectedId != null) {
      _selectedModel = _models.firstWhere((model) => model.id == selectedId, orElse: () => _models.first);
    } else {
      _selectedModel = _models.isNotEmpty ? _models.first : null;
    }
    update();
  }

  Future<void> selectAspectRatio(AspectRatioModel aspectRatio) async {
    _selectedAspectRatio = aspectRatio;
    update();
    await modelsService.saveSelectedAspectRatio(aspectRatio.id);
  }
}
