import 'package:http/http.dart';

abstract class AdRepoInterface {
  Future<Response?> getAdIds();
}
