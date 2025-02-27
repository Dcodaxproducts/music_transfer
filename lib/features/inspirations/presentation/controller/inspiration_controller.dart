import 'dart:async';
import 'package:matrix_ai/features/inspirations/data/model/inspiration.dart';
import 'package:get/get.dart';
import '../../domain/service/inspiration_service_interface.dart';

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
