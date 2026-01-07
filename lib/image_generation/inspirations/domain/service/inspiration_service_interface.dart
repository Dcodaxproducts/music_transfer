import 'package:pixart_app/image_generation/inspirations/data/model/inspiration.dart';

abstract class InspirationServiceInterface {
  Future<List<Inspiration>> fetchInspirations();
}
