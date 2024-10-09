import 'dart:async';
import 'dart:convert';
import 'package:matrix_ai/data/model/response/inspiration.dart';
import 'package:matrix_ai/data/repository/inspiration_repo.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class InspirationController extends GetxController implements GetxService {
  final InspirationRepo inspirationRepo;
  InspirationController({required this.inspirationRepo});

  static InspirationController get find => Get.find<InspirationController>();

  List<Inspiration> _inspirations = [];

  List<Inspiration> get inspirations => _inspirations;

  Future<void> getInspirations() async {
    http.Response? response = await inspirationRepo.getInspirations();
    if (response != null) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> modelList = data['inspiration'];
      _inspirations = modelList.map((e) => Inspiration.fromJson(e)).toList();

      update();
    }
  }
}
