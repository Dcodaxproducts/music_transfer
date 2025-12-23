import 'package:http/http.dart';

abstract class ImageGenRepo {
  Future<Response?> generateImages(Map<String, dynamic> body);

  Future<void> cancelRequest();
}
