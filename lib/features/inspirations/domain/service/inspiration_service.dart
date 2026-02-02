import 'package:pixart_app/features/inspirations/data/model/inspiration.dart';

abstract class InspirationService {
  Future<List<Inspiration>> fetchInspirations();
}
