import 'package:http/http.dart';

import '../../../../core/api/api_client_impl.dart';

abstract class ImageGenRepo {
  Future<Response?> generateImages(Map<String, dynamic> body, {List<MultipartBody>? files});

  Future<void> cancelRequest();
}
