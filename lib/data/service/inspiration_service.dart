import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:matrix_ai/data/model/response/inspiration.dart';
import 'package:matrix_ai/data/repository/inspiration_repo_interface.dart';
import 'inspiration_service_interface.dart';

class InspirationService implements InspirationServiceInterface {
  final InspirationRepoInterface inspirationRepo;

  InspirationService({required this.inspirationRepo});

  @override
  Future<List<Inspiration>> fetchInspirations() async {
    http.Response? response = await inspirationRepo.getInspirations();
    if (response != null && response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> modelList = data['inspiration'];
      List<Inspiration> inspirations =
          modelList.map((e) => Inspiration.fromJson(e)).toList();
      return inspirations;
    }
    return [];
  }
}
