import '../../../../core/api/api_client_impl.dart';
import '../../../../imports.dart';

abstract class ProfileRepo {
  // Credits Management
  Future<bool> saveCredits(int credits);
  int? loadCredits();

  Future<Response?> updateProfile(Map<String, dynamic> body, MultipartBody? profileImage);
}
