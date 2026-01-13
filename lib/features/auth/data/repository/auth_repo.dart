import 'package:pixart_app/imports.dart';
import '../../../../core/api/api_client_impl.dart';

abstract class AuthRepo {
  Future<bool> saveCredits(int credits);
  int? loadCredits();

  Future<Response?> signup(Map<String, dynamic> body, MultipartBody? profileImage);
  Future<Response?> login(Map<String, dynamic> body);
}
