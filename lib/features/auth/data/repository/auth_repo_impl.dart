import 'dart:convert';

import 'package:pixart_app/core/api/api_client_impl.dart';
import 'package:pixart_app/imports.dart';
import 'auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final ApiClient client;
  final SharedPreferences prefs;
  AuthRepoImpl({required this.client, required this.prefs});

  /* Authentication */
  @override
  Future<Response?> login(Map<String, dynamic> body) async {
    return await client.post(Endpoints.login, body);
  }

  @override
  Future<Response?> socialLogin(Map<String, dynamic> body) async {
    return await client.post(Endpoints.socialLogin, body);
  }

  @override
  Future<Response?> guestLogin(Map<String, dynamic> body) async {
    return await client.post(Endpoints.register, body);
  }

  @override
  Future<Response?> signup(Map<String, dynamic> body, MultipartBody? profileImage) async {
    if (profileImage != null) {
      return await client.postMultipart(Endpoints.register, body, [profileImage]);
    }
    return await client.post(Endpoints.register, body);
  }

  @override
  Future<Response?> logout() async {
    return await client.post(Endpoints.logout, {});
  }

  @override
  Future<Response?> verifyOtp(Map<String, dynamic> body) async {
    return await client.post(Endpoints.verifyEmail, body);
  }

  @override
  Future<Response?> forgetPasswrod(Map<String, dynamic> body) async {
    return await client.post(Endpoints.forgetPassword, body);
  }

  @override
  Future<void> updateHeader(String token) async {
    await prefs.setString(SharedKeys.token, token);
    client.updateHeader(token);
  }

  //  user  Management
  @override
  Future<bool> saveUser(Map<String, dynamic> user) async {
    return await prefs.setString(SharedKeys.user, jsonEncode(user));
  }

  @override
  String? getUser() {
    return prefs.getString(SharedKeys.user);
  }

  @override
  Future<bool> deleteUser() async {
    updateHeader('');
    return await prefs.remove(SharedKeys.user);
  }
}
