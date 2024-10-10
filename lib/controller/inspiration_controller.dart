import 'dart:async';
import 'package:matrix_ai/data/model/response/inspiration.dart';
import 'package:get/get.dart';
import '../data/service/inspiration_service_interface.dart';

class InspirationController extends GetxController {
  final InspirationServiceInterface inspirationService;
  InspirationController({required this.inspirationService});

  static InspirationController get find => Get.find<InspirationController>();

  List<Inspiration> _inspirations = [];
  List<Inspiration> get inspirations => _inspirations;

  Future<void> getInspirations() async {
    _inspirations = await inspirationService.fetchInspirations();
    update();
  }
}
