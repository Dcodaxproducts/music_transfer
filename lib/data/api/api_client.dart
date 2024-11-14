import 'dart:convert';
import 'dart:developer';
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

  String? token;
  final Map<String, String> _mainHeaders = {
    "Content-Type": "application/json",
    'Accept': 'application/json',
  };

  ApiClient({required this.sharedPreferences});

  @override
  Future<http.Response?> get(String uri, {Map<String, String>? headers}) async {
    try {
      // print the api call
      debugPrint('====> API Call: $uri, ====> Header: $_mainHeaders');
      // api call
      http.Response response = await http
          .get(Uri.parse(AppConstants.BASE_URL + uri),
              headers: headers ?? _mainHeaders)
          .timeout(Duration(seconds: timeoutInSeconds));

      // handle response
      return _handleResponse(response);
    } catch (e) {
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
  }) async {
    try {
      // print the api call
      debugPrint('====> API Call: $url, ====> Header: $_mainHeaders');
      debugPrint('====> Body: $body');

      // api call
      http.Response response = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {
          ..._mainHeaders,
          if (headers != null) ...headers,
        },
      ).timeout(Duration(seconds: timeoutInSeconds));

      // handle response
      return _handleResponse(response);
    } catch (e) {
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

  http.Response? _handleResponse(http.Response response) {
    if (response.statusCode != 200) {
      return _handleError(jsonDecode(response.body));
    } else {
      dismiss();
      return response;
    }
  }

  _handleError(Map<String, dynamic> body) {
    ErrorResponse response = ErrorResponse.fromJson(body);
    dismiss();
    showToast(response.errors.first.message);
    return null;
  }

  _socketException(Object e) {
    if (e is SocketException) {
      showToast('Please check your internet connection');
    } else {
      log(e.toString());
      showToast('Something went wrong');
    }
  }
}
