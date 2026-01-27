import 'package:pixart_app/image_gen/inspirations/data/model/inspiration.dart';

abstract class InspirationService {
  Future<List<Inspiration>> fetchInspirations();
}
