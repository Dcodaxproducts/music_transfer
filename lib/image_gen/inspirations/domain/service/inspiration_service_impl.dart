import 'dart:convert';
import 'package:pixart_app/image_gen/inspirations/data/model/inspiration.dart';
import 'package:pixart_app/image_gen/inspirations/data/repository/inspiration_repo.dart';
import '../../../../imports.dart';
import 'inspiration_service.dart';

class InspirationServiceImpl implements InspirationService {
  final InspirationRepo inspirationRepo;
  InspirationServiceImpl({required this.inspirationRepo});

  @override
  Future<List<Inspiration>> fetchInspirations() async {
    Response? response = await inspirationRepo.getInspirations();
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> inspirationList = data['inspiration'];
      List<Inspiration> inspirations = inspirationList.map((e) => Inspiration.fromJson(e)).toList();
      return inspirations;
    }
    return [];
  }
}
