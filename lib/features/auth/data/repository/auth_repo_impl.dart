import 'package:pixart_app/core/api/api_client_impl.dart';
import 'package:pixart_app/imports.dart';
import 'auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  final ApiClient client;
  final SharedPreferences prefs;
  AuthRepoImpl({required this.client, required this.prefs});

  @override
  Future<bool> saveCredits(int credits) async {
    return await prefs.setInt(SharedKeys.credits, credits);
  }

  @override
  int? loadCredits() => prefs.getInt(SharedKeys.credits);

  @override
  Future<Response?> signup(Map<String, dynamic> body, MultipartBody? profileImage) async {
    if (profileImage != null) {
      return await client.postMultipart(Endpoints.signup, body, [profileImage]);
    }
    return await client.post(Endpoints.signup, body);
  }

  @override
  Future<Response?> login(Map<String, dynamic> body) async {
    return await client.post(Endpoints.login, body);
  }
}
