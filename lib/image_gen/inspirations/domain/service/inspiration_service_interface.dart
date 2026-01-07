import 'package:pixart_app/image_gen/inspirations/data/model/inspiration.dart';

abstract class InspirationServiceInterface {
  Future<List<Inspiration>> fetchInspirations();
}
