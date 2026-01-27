import 'package:pixart_app/core/api/api_client_impl.dart';
import 'package:pixart_app/imports.dart';
import 'auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final ApiClient client;
  final SharedPreferences prefs;
  AuthRepoImpl({required this.client, required this.prefs});

  /* Credits Management */
  @override
  Future<bool> saveCredits(int credits) async {
    return await prefs.setInt(SharedKeys.credits, credits);
  }

  @override
  int? loadCredits() => prefs.getInt(SharedKeys.credits);

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
  Future<bool> saveToken(String token) async {
    return await prefs.setString(SharedKeys.token, token);
  }

  @override
  String? getToken() {
    return prefs.getString(SharedKeys.token);
  }
}
