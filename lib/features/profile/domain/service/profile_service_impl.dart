import 'dart:convert';
import 'package:pixart_app/features/auth/data/model/user_model.dart';
import '../../../../core/api/api_client_impl.dart';
import '../../data/repository/profile_repo.dart';
import 'profile_service.dart';

class ProfileServiceImpl implements ProfileService {
  final ProfileRepo repo;
  ProfileServiceImpl({required this.repo});

  /* Credits Management */
  @override
  Future<bool> saveCredits(int credits) {
    return repo.saveCredits(credits);
  }

  @override
  int? loadCredits() => repo.loadCredits();

  @override
  Future<UserModel?> updateProfile(Map<String, dynamic> body, MultipartBody? profileImage) {
    return repo.updateProfile(body, profileImage).then((response) {
      if (response != null && response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body)['data'];
        final UserModel user = UserModel.fromJson(data);
        return user;
      }
      return null;
    });
  }
}
