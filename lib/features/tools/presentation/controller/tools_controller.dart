import 'package:get/get.dart';
import 'package:matrix_ai/features/tools/domain/service/tools_service_interface.dart';
import '../../data/model/tools.dart';

class ToolsController extends GetxController implements GetxService {
  final ToolsServiceInterface toolsService;
  ToolsController({required this.toolsService});

  static ToolsController get find => Get.find<ToolsController>();

  List<ToolModel> _tools = [];
  bool _loading = false;

  List<ToolModel> get tools => _tools;
  bool get loading => _loading;

  set tools(List<ToolModel> value) {
    _tools = value;
    update();
  }

  set loading(bool value) {
    _loading = value;
    update();
  }

  Future<List<ToolModel>> getTools() async {
    if (_tools.isNotEmpty) return _tools;
    loading = true;
    tools = await toolsService.getTools();
    Future.delayed(const Duration(milliseconds: 500), () {
      loading = false;
    });
    return _tools;
  }
}
