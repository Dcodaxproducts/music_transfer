import 'package:http/http.dart';
import 'api_client_impl.dart';

abstract class ApiClient {
  void updateHeader(String token);

  Future<void> cancelRequest();

  Future<Response?> get(
    String uri, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    bool hideLoading = true,
  });

  Future<Response?> post(
    String url,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
    bool hideLoading = true,
  });

  Future<Response?> put(
    String url,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
    bool hideLoading = true,
  });

  Future<Response?> delete(String url, {Map<String, String>? headers, bool hideLoading = true});

  Future<Response?> postMultipart(
    String uri,
    Map<String, dynamic> body,
    List<MultipartBody>? muliparts, {
    bool hideLoading = true,
  });
}
