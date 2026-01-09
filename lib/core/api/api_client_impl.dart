import 'dart:convert';
import '../../imports.dart';
import '../model/dev.dart';
import 'error.dart';

class ApiClientImpl extends GetxService implements ApiClient {
  final String baseUrl;
  final int timeoutInSeconds = 20;

  ApiClientImpl({required this.baseUrl});
  Client? _client;
  final Map<String, String> _mainHeaders = {"Content-Type": "application/json", 'Accept': 'application/json'};

  @override
  Future<void> cancelRequest() async {
    _client?.close();
    _client = null;
    debugPrint('====> API request canceled');
  }

  Future<Response?> _request(
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
      _client = Client();
      Response response;

      final requestHeaders = {..._mainHeaders, if (headers != null) ...headers};
      switch (method) {
        case 'GET':
          response = await _client!.get(url, headers: requestHeaders);
          break;
        case 'POST':
          response = await _client!.post(url, body: jsonEncode(body), headers: requestHeaders);
          break;
        case 'PUT':
          response = await _client!.put(url, body: jsonEncode(body), headers: requestHeaders);
          break;
        case 'DELETE':
          response = await _client!.delete(url, headers: requestHeaders);
          break;
        case 'MULTIPART':
          MultipartRequest request = MultipartRequest('POST', url);
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
          response = await Response.fromStream(await request.send());
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
  Future<Response?> get(
    String uri, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    bool hideLoading = true,
  }) => _request('GET', uri, headers: headers, queryParams: queryParams, hideLoading: hideLoading);

  @override
  Future<Response?> post(
    String uri,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
    bool hideLoading = true,
  }) => _request('POST', uri, body: body, headers: headers, hideLoading: hideLoading);

  @override
  Future<Response?> put(
    String uri,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
    bool hideLoading = true,
  }) => _request('PUT', uri, body: body, headers: headers, hideLoading: hideLoading);

  @override
  Future<Response?> delete(String uri, {Map<String, String>? headers, bool hideLoading = true}) =>
      _request('DELETE', uri, headers: headers, hideLoading: hideLoading);

  @override
  Future<Response?> postMultipart(
    String uri,
    Map<String, dynamic> body,
    List<MultipartBody>? muliparts, {
    bool hideLoading = true,
  }) => _request('MULTIPART', uri, body: body, muliparts: muliparts, hideLoading: hideLoading);

  void _printData(String url, {Map<String, dynamic>? body}) {
    if (Environment.isProd) return;
    debugPrint('====> API Call: $url, ====> Headers: $_mainHeaders');
    if (body != null) debugPrint('====> Body: $body');
  }

  Future<Response?> _handleResponse(Response response, {bool hideLoading = true}) async {
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
