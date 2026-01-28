import 'package:pixart_app/features/profile/domain/service/profile_service.dart';
import 'package:pixart_app/imports.dart';

import '../../../../core/api/api_client_impl.dart';
import '../../../auth/data/model/user_model.dart';
import '../../../auth/presentation/controller/auth_controller.dart';

class ProfileController extends GetxController implements GetxService {
  final ProfileService service;
  ProfileController({required this.service});

  static ProfileController get find => Get.find<ProfileController>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  int _credits = 0;
  int get credits => _credits;

  void loadCredits() {
    int? savedCredits = service.loadCredits();
    _credits = savedCredits ?? 0;
    update();
  }

  Future<void> updateCredits(int value) async {
    // deduct credits used from available credits
    int updatedCredits = _credits - value;
    if (updatedCredits.isNegative) {
      updatedCredits = 0;
    }
    bool success = await service.saveCredits(updatedCredits);
    if (success) {
      _credits = updatedCredits;
      update();
    }
  }

  Future<bool> updateProfile({String? name, String? password, XFile? image}) async {
    try {
      isLoading = true;

      // prepare body
      Map<String, dynamic> body = {};
      if (name != null && name.isNotEmpty) {
        body['name'] = name;
      }
      if (password != null && password.isNotEmpty) {
        body['password'] = password;
      }

      MultipartBody? profileImage;
      if (image != null) {
        profileImage = MultipartBody('profile_image', image);
      }

      // call service
      UserModel? updatedUser = await service.updateProfile(body, profileImage);
      isLoading = false;

      // if successful, update user in AuthController
      if (updatedUser != null) {
        await AuthController.find.saveUser(updatedUser);
      }

      return updatedUser != null;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }
}
