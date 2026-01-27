import 'dart:async';
import 'package:pixart_app/image_gen/inspirations/data/model/inspiration.dart';
import 'package:get/get.dart';
import '../../domain/service/inspiration_service.dart';

class InspirationController extends GetxController implements GetxService {
  final InspirationService service;
  InspirationController({required this.service});

  static InspirationController get find => Get.find<InspirationController>();

  List<Inspiration> _inspirations = [];
  List<Inspiration> get inspirations => _inspirations;

  Future<void> getInspirations() async {
    if (_inspirations.isNotEmpty) return;
    _inspirations = await service.fetchInspirations();
    update();
  }
}
