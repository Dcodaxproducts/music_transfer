import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:matrix_ai/common/snackbar.dart';
import 'package:matrix_ai/data/api/api_client_interface.dart';
import 'package:matrix_ai/data/model/response/error.dart';
import 'package:matrix_ai/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient extends GetxService implements ApiClientInterface {
  final SharedPreferences sharedPreferences;
  final int timeoutInSeconds = 120;
  http.Client? _client; // Track the client for cancellation

  final Map<String, String> _mainHeaders = {
    "Content-Type": "application/json",
    'Accept': 'application/json',
  };

  ApiClient({required this.sharedPreferences});

  @override
  Future<void> cancelRequest() async {
    if (_client != null) {
      _client!.close(); // Cancel the ongoing request
      _client = null; // Reset the client
      debugPrint('====> API request canceled');
    }
  }

  @override
  Future<http.Response?> get(String uri, {Map<String, String>? headers}) async {
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
      return _handleResponse(response);
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
    bool dismissDelay = false,
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
        headers: {
          ..._mainHeaders,
          if (headers != null) ...headers,
        },
      ).timeout(Duration(seconds: timeoutInSeconds));

      _client = null; // Reset the client after completion

      // handle response
      return _handleResponse(response, dismissDelay: dismissDelay);
    } catch (e) {
      _client = null; // Reset the client after completion
      dismiss();
      _socketException(e);
      return null;
    }
  }

  @override
  Future<Uint8List?> downloadImage(String uri) async {
    try {
      // print the api call
      debugPrint('====> API Call: $uri, ====> Header: $_mainHeaders');

      http.Response response = await http
          .get(
            Uri.parse(uri),
            headers: _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      if (response.statusCode != 200) {
        return _handleError(jsonDecode(response.body));
      } else {
        dismiss();
        return Uint8List.fromList(response.bodyBytes);
      }
    } catch (e) {
      dismiss();
      _socketException(e);
      return null;
    }
  }

  Future<http.Response?> _handleResponse(http.Response response, {bool? dismissDelay = false}) async {
    if (response.statusCode != 200) {
      return _handleError(jsonDecode(response.body));
    } else {
      if (dismissDelay == true) {
        await Future.delayed(const Duration(seconds: 2), dismiss);
      } else {
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
    dismiss();
    showToast(response.errors.first.message);
    return null;
  }

  _socketException(Object e) {
    if (e is SocketException) {
      showToast('Please check your internet connection');
    } else {
      if (e is http.ClientException) {
        if (e.message != 'Connection closed before full header was received') {
          showToast('Something went wrong');
        }
      } else {
        showToast('Something went wrong');
      }
    }
  }
}
