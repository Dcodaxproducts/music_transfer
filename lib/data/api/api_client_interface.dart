import 'dart:typed_data';
import 'package:http/http.dart';

abstract class ApiClientInterface<T> {
  Future<void> cancelRequest();

  Future<Response?> get(String uri, {Map<String, String>? headers});

  Future<Response?> post(String url, Map<String, dynamic> body,
      {Map<String, dynamic>? headers, bool hideLoading = true});

  Future<Uint8List?> downloadImage(String uri);
}
