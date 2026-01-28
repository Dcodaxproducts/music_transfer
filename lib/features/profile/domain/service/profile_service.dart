import '../../../../core/api/api_client_impl.dart';
import '../../../auth/data/model/user_model.dart';

abstract class ProfileService {
  /* Credits Management */
  Future<bool> saveCredits(int credits);
  int? loadCredits();

  /* Profile Management */
  Future<UserModel?> updateProfile(Map<String, dynamic> body, MultipartBody? profileImage);
}
