import 'package:matrix_ai/modules/image_generation/inspirations/data/model/inspiration.dart';

abstract class InspirationServiceInterface {
  Future<List<Inspiration>> fetchInspirations();
}
