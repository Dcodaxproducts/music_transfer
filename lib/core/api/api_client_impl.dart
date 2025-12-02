import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:pixart_app/core/utils/endpoints.dart';
import 'package:pixart_app/core/widgets/snackbar.dart';
import 'package:pixart_app/core/api/api_client.dart';
import 'package:pixart_app/core/error/error.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pixart_app/core/widgets/together_ai_error_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pixart_app/core/error/together_ai_error.dart';

class ApiClientImpl extends GetxService implements ApiClient {
  final SharedPreferences prefs;
  final int timeoutInSeconds = 30;
  http.Client? _client; // Track the client for cancellation

  final Map<String, String> _mainHeaders = {"Content-Type": "application/json", 'Accept': 'application/json'};

  ApiClientImpl({required this.prefs});

  @override
  Future<void> cancelRequest() async {
    if (_client != null) {
      _client!.close(); // Cancel the ongoing request
      _client = null; // Reset the client
    }
  }

  @override
  Future<http.Response?> get(String uri, {Map<String, String>? headers, bool hideLoading = true}) async {
    try {
      // print the api call
      _debugPrint('====> API Call: ${Endpoints.BASE_URL + uri}, ====> Header: $_mainHeaders');

      // Initialize a new client
      _client = http.Client();

      // api call
      http.Response response = await _client!
          .get(Uri.parse(Endpoints.BASE_URL + uri), headers: headers ?? _mainHeaders)
          .timeout(Duration(seconds: timeoutInSeconds));

      _client = null; // Reset the client after completion

      // handle response
      return _handleResponse(response, hideLoading: hideLoading);
    } catch (e) {
      _client = null; // Reset the client after completion
      dismiss();
      _socketException(e);
      return null;
    }
  }

  @override
  Future<http.Response?> post(
    String url,
    Map<String, dynamic> body, {
    Map<String, dynamic>? headers,
    bool hideLoading = true,
  }) async {
    try {
      // print the api call
      _debugPrint('====> API Call: $url, ====> Header: $_mainHeaders');
      _debugPrint('====> Body: $body');

      // Initialize a new client
      _client = http.Client();

      // api call
      http.Response response = await _client!
          .post(
            Uri.parse(url),
            body: jsonEncode(body),
            headers: {..._mainHeaders, if (headers != null) ...headers},
          )
          .timeout(Duration(seconds: timeoutInSeconds));

      _client = null; // Reset the client after completion
      // handle response
      return _handleResponse(response, hideLoading: hideLoading);
    } catch (e) {
      _client = null; // Reset the client after completion
      dismiss();
      _socketException(e);
      return null;
    }
  }

  @override
  Future<Uint8List?> downloadImage(String uri, {bool hideLoading = true}) async {
    try {
      // print the api call
      _debugPrint('====> API Call: $uri, ====> Header: $_mainHeaders');

      http.Response response = await http
          .get(Uri.parse(uri), headers: _mainHeaders)
          .timeout(Duration(seconds: timeoutInSeconds));
      if (response.statusCode != 200) {
        return _handleError(jsonDecode(response.body));
      } else {
        if (hideLoading) dismiss();
        return Uint8List.fromList(response.bodyBytes);
      }
    } catch (e) {
      dismiss();
      _socketException(e);
      return null;
    }
  }

  Future<http.Response?> _handleResponse(http.Response response, {bool hideLoading = true}) async {
    if (response.statusCode != 200) {
      dismiss();
      try {
        return _handleError(jsonDecode(response.body));
      } catch (e) {
        showToast('Something went wrong');
        return null;
      }
    } else {
      if (hideLoading) {
        dismiss();
      }
      return response;
    }
  }

  Null _handleError(Map<String, dynamic> body) {
    if (body.containsKey('message')) {
      showToast(body['message']);
      return null;
    }
    ErrorResponse response = ErrorResponse.fromJson(body);
    // Handle TogetherAIError
    if (body.containsKey('id')) {
      TogetherAIError error = getTogetherAIError(body['error']['type'], body['error']['message']);
      dismiss();
      _showCustomErrorDialog(error);
    } else {
      showToast(response.errors.first.message);
    }

    return null;
  }

  dynamic _showCustomErrorDialog(TogetherAIError error) => showTogetherAiErrorDialog(error);

  void _socketException(Object e) {
    if (e is SocketException) {
      showToast('Please check your internet connection');
    } else {
      if (e is http.ClientException) {
        showToast('Something went wrong');
      } else {
        showToast('Something went wrong');
      }
    }
  }

  void _debugPrint(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }
}
