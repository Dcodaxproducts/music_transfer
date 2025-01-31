import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:matrix_ai/view/base/common/snackbar.dart';
import 'package:matrix_ai/data/api/api_client_interface.dart';
import 'package:matrix_ai/data/model/response/error.dart';
import 'package:matrix_ai/utils/app_constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:matrix_ai/view/base/common/together_ai_error_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:matrix_ai/data/api/together_ai_error.dart';

class ApiClient extends GetxService implements ApiClientInterface {
  final SharedPreferences prefs;
  final int timeoutInSeconds = 30;
  http.Client? _client; // Track the client for cancellation

  final Map<String, String> _mainHeaders = {"Content-Type": "application/json", 'Accept': 'application/json'};

  ApiClient({required this.prefs});

  @override
  Future<void> cancelRequest() async {
    if (_client != null) {
      _client!.close(); // Cancel the ongoing request
      _client = null; // Reset the client
      debugPrint('====> API request canceled');
    }
  }

  @override
  Future<http.Response?> get(
    String uri, {
    Map<String, String>? headers,
    bool hideLoading = true,
  }) async {
    try {
      // print the api call
      debugPrint('====> API Call: ${AppConstants.BASE_URL + uri}, ====> Header: $_mainHeaders');

      // Initialize a new client
      _client = http.Client();

      // api call
      http.Response response = await _client!
          .get(Uri.parse(AppConstants.BASE_URL + uri), headers: headers ?? _mainHeaders)
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
      debugPrint('====> API Call: $url, ====> Header: $_mainHeaders');
      debugPrint('====> Body: $body');

      // Initialize a new client
      _client = http.Client();

      // api call
      http.Response response = await _client!.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {..._mainHeaders, if (headers != null) ...headers},
      ).timeout(Duration(seconds: timeoutInSeconds));

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
      debugPrint('====> API Call: $uri, ====> Header: $_mainHeaders');

      http.Response response =
          await http.get(Uri.parse(uri), headers: _mainHeaders).timeout(Duration(seconds: timeoutInSeconds));
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

  _handleError(Map<String, dynamic> body) {
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

  _showCustomErrorDialog(TogetherAIError error) => showTogetherAiErrorDialog(error);

  _socketException(Object e) {
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
}
