import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../imports.dart';
import 'error.dart';
import 'api_client.dart';

class ApiClientImpl extends GetxService implements ApiClient {
  final String baseUrl;
  final int timeoutInSeconds = 20;

  ApiClientImpl({required this.baseUrl});
  http.Client? _client;
  final Map<String, String> _mainHeaders = {
    "Content-Type": "application/json",
    'Accept': 'application/json',
  };

  @override
  Future<void> cancelRequest() async {
    _client?.close();
    _client = null;
    debugPrint('====> API request canceled');
  }

  Future<http.Response?> _request(
    String method,
    String uri, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    List<MultipartBody>? muliparts,
    bool hideLoading = true,
  }) async {
    Uri url = Uri.parse('$baseUrl$uri').replace(queryParameters: queryParams);
    try {
      _printData(url.toString(), body: body);
      _client = http.Client();
      http.Response response;

      final requestHeaders = {..._mainHeaders, if (headers != null) ...headers};
      switch (method) {
        case 'GET':
          response = await _client!.get(url, headers: requestHeaders);
          break;
        case 'POST':
          response = await _client!.post(
            url,
            body: jsonEncode(body),
            headers: requestHeaders,
          );
          break;
        case 'PUT':
          response = await _client!.put(
            url,
            body: jsonEncode(body),
            headers: requestHeaders,
          );
          break;
        case 'DELETE':
          response = await _client!.delete(url, headers: requestHeaders);
          break;
        case 'MULTIPART':
          MultipartRequest request = http.MultipartRequest('POST', url);
          request.headers.addAll(requestHeaders);

          // Adding fields and files to the request
          if (body != null) {
            body.forEach((key, value) {
              request.fields[key] = value.toString();
            });
          }

          // Adding multipart files
          if (muliparts != null) {
            for (MultipartBody multipart in muliparts) {
              request.files.add(
                MultipartFile(
                  multipart.key,
                  multipart.file.readAsBytes().asStream(),
                  await multipart.file.length(),
                  filename: DateTime.now().millisecondsSinceEpoch.toString(),
                ),
              );
            }
          }

          // Sending the request
          response = await http.Response.fromStream(await request.send());
        default:
          throw UnsupportedError("HTTP method not supported");
      }
      return await _handleResponse(response);
    } catch (e) {
      _socketException(e);
      return null;
    } finally {
      _client = null;
    }
  }

  @override
  Future<http.Response?> get(
    String uri, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    bool hideLoading = true,
  }) => _request(
    'GET',
    uri,
    headers: headers,
    queryParams: queryParams,
    hideLoading: hideLoading,
  );

  @override
  Future<http.Response?> post(
    String uri,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
    bool hideLoading = true,
  }) => _request(
    'POST',
    uri,
    body: body,
    headers: headers,
    hideLoading: hideLoading,
  );

  @override
  Future<http.Response?> put(
    String uri,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
    bool hideLoading = true,
  }) => _request(
    'PUT',
    uri,
    body: body,
    headers: headers,
    hideLoading: hideLoading,
  );

  @override
  Future<http.Response?> delete(
    String uri, {
    Map<String, String>? headers,
    bool hideLoading = true,
  }) => _request('DELETE', uri, headers: headers, hideLoading: hideLoading);

  @override
  Future<http.Response?> postMultipart(
    String uri,
    Map<String, dynamic> body,
    List<MultipartBody>? muliparts, {
    bool hideLoading = true,
  }) => _request(
    'MULTIPART',
    uri,
    body: body,
    muliparts: muliparts,
    hideLoading: hideLoading,
  );

  @override
  Future<Uint8List?> downloadImage(String uri) async {
    try {
      _printData(uri);
      final response = await http
          .get(Uri.parse(uri), headers: _mainHeaders)
          .timeout(Duration(seconds: timeoutInSeconds));
      return response.statusCode == 200
          ? Uint8List.fromList(response.bodyBytes)
          : _handleError(jsonDecode(response.body));
    } catch (e) {
      _socketException(e);
      return null;
    }
  }

  void _printData(String url, {Map<String, dynamic>? body}) {
    debugPrint('====> API Call: $url, ====> Headers: $_mainHeaders');
    if (body != null) debugPrint('====> Body: $body');
  }

  Future<http.Response?> _handleResponse(
    http.Response response, {
    bool hideLoading = true,
  }) async {
    if (hideLoading) dismiss();
    return response.statusCode == 200 || response.statusCode == 201
        ? response
        : _handleError(jsonDecode(response.body));
  }

  Null _handleError(Map<String, dynamic> body) {
    if (body.containsKey('message')) {
      String message = body['message'];
      showToast(message);
      return null;
    }
    ErrorResponse response = ErrorResponse.fromJson(body);
    showToast(response.errors.first.message);
    return null;
  }

  void _socketException(Object e) {
    if (e is SocketException) {
      showToast('Please check your internet connection');
    } else {
      showToast('Something went wrong');
    }
  }
}

class MultipartBody {
  String key;
  XFile file;
  MultipartBody(this.key, this.file);
}
