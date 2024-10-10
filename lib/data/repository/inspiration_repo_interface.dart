import 'package:http/http.dart';

abstract class InspirationRepoInterface {
  Future<Response?> getInspirations();
}
