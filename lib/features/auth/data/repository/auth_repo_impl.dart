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
}
