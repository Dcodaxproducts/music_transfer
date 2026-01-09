import 'dart:async';
import 'package:pixart_app/image_gen/home/data/model/aspect_ratio.dart';
import 'package:pixart_app/image_gen/home/data/model/model.dart';
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

  AspectRatioModel _selectedAspectRatio = aspectRatios.first;
  AspectRatioModel get selectedAspectRatio => _selectedAspectRatio;

  Future<void> getModels() async {
    _models.clear();

    // get cached models first
    List<Model> cachedModels = modelsService.getCachedModels();
    if (cachedModels.isNotEmpty) {
      _models.addAll(cachedModels);
      update();
      setDefaultModel();
      _getSelectedAspectRatio();
    }

    // fetch from API
    List<Model> fetchedModels = await modelsService.fetchModels();
    if (fetchedModels.isNotEmpty) {
      _models.clear();
      _models.addAll(fetchedModels);
      update();
      setDefaultModel();
      _getSelectedAspectRatio();
      await modelsService.cacheModels(fetchedModels);
    }
  }

  // void _getSelectedModel() {
  //   int? selectedId = modelsService.getSelectedModel();
  //   if (selectedId != null) {
  //     _selectedModel = _models.firstWhere((model) => model.id == selectedId, orElse: _getDefaultModel);
  //   } else {
  //     _selectedModel = _models.isNotEmpty ? _getDefaultModel() : null;
  //   }
  //   update();
  // }

  Future<bool> selectModel(Model model) async {
    _selectedModel = model;
    update();
    return await modelsService.saveSelectedModel(model.id);
  }

  Model _getDefaultModel() {
    return _models.firstWhere((model) => model.isDefault, orElse: () => _models.first);
  }

  Future<void> setDefaultModel() async {
    Model defaultModel = _getDefaultModel();
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

  /*   Aspect Ratio Methods  */

  void _getSelectedAspectRatio() {
    int? selectedId = modelsService.getSelectedAspectRatio();
    if (selectedId != null) {
      _selectedAspectRatio = aspectRatios.firstWhere(
        (model) => model.id == selectedId,
        orElse: () => aspectRatios.first,
      );
    } else {
      _selectedAspectRatio = aspectRatios.first;
    }
    update();
  }

  Future<void> selectAspectRatio(AspectRatioModel aspectRatio) async {
    _selectedAspectRatio = aspectRatio;
    update();
    await modelsService.saveSelectedAspectRatio(aspectRatio.id);
  }
}
