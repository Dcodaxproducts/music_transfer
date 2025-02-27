import 'package:matrix_ai/features/inspirations/data/model/inspiration.dart';

abstract class InspirationServiceInterface {
  Future<List<Inspiration>> fetchInspirations();
}
