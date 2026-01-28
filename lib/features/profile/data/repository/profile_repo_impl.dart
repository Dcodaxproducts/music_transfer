import 'package:pixart_app/imports.dart';
import '../../../../core/api/api_client_impl.dart';
import 'profile_repo.dart';

class ProfileRepoImpl implements ProfileRepo {
  final ApiClient client;
  final SharedPreferences prefs;
  ProfileRepoImpl({required this.client, required this.prefs});

  /* Credits Management */
  @override
  Future<bool> saveCredits(int credits) async {
    return await prefs.setInt(SharedKeys.credits, credits);
  }

  @override
  int? loadCredits() => prefs.getInt(SharedKeys.credits);

  /* Profile Management */
  @override
  Future<Response?> updateProfile(Map<String, dynamic> body, MultipartBody? profileImage) async {
    List<MultipartBody>? images;
    if (profileImage != null) {
      images = [profileImage];
    }
    return await client.postMultipart(Endpoints.updateProfile, body, images);
  }
}
