import 'package:http/http.dart';

abstract class InspirationRepo {
  Future<Response?> getInspirations();
}
