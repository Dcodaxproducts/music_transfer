import 'dart:async';
import 'package:pixart_app/features/home/data/model/size_preset.dart';
import 'package:pixart_app/features/home/data/model/model.dart';
import 'package:get/get.dart';
import '../../domain/service/model_service.dart';

class ModelsController extends GetxController implements GetxService {
  final ModelsService modelsService;
  ModelsController({required this.modelsService});

  static ModelsController get find => Get.find<ModelsController>();

  final List<Model> _models = [];
  List<Model> get models => _models;

  Model? _selectedModel;
  Model? get selectedModel => _selectedModel;

  SizePreset _selectedSize = SizePreset.defaultPreset();
  SizePreset get selectedSize => _selectedSize;
  set selectedSize(SizePreset size) {
    _selectedSize = size;
    update();
  }

  Future<void> getModels() async {
    if (_models.isNotEmpty) return;
    _models.clear();

    // get cached models first
    List<Model> cachedModels = modelsService.getCachedModels();
    if (cachedModels.isNotEmpty) {
      _models.addAll(cachedModels);
      update();
      _getSelectedModel();
    }

    // fetch from API
    List<Model> fetchedModels = await modelsService.fetchModels();
    if (fetchedModels.isNotEmpty) {
      _models.clear();
      _models.addAll(fetchedModels);
      update();
      _getSelectedModel();
      await modelsService.cacheModels(fetchedModels);
    }
  }

  Future<bool> selectModel(Model model) async {
    _selectedModel = model;
    if (model.sizes.isNotEmpty) {
      _selectedSize = model.sizes.first;
    }
    update();
    return await modelsService.saveSelectedModel(model.id);
  }

  void _getSelectedModel() {
    int? selectedModelId = modelsService.getSelectedModel();
    if (selectedModelId != null && _models.isNotEmpty) {
      Model? model = _models.firstWhereOrNull((model) => model.id == selectedModelId);
      if (model != null) {
        _selectedModel = model;
        if (model.sizes.isNotEmpty) {
          _selectedSize = model.sizes.first;
        }
      }
    } else {
      _setDefaultModel();
    }
  }

  Future<void> _setDefaultModel() async {
    if (_models.isEmpty) return;
    Model defaultModel = _models.firstWhere((model) => model.isDefault, orElse: () => _models.first);
    await selectModel(defaultModel);
  }

  Future<void> handleImageModelSelection() async {
    // if selected model does not support image, select one that does
    if (_selectedModel != null && !_selectedModel!.supportImage) {
      Model? imageModel = _models.firstWhereOrNull((model) => model.supportImage);
      if (imageModel != null) {
        await selectModel(imageModel);
      }
    }
  }
}
