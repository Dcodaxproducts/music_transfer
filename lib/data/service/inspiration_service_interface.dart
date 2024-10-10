import 'package:matrix_ai/data/model/response/inspiration.dart';

abstract class InspirationServiceInterface {
  Future<List<Inspiration>> fetchInspirations();
}
