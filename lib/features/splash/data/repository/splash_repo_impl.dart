import '../../../../imports.dart';
import 'splash_repo.dart';

class SettingsRepoImpl implements SettingsRepo {
  final SharedPreferences prefs;
  SettingsRepoImpl({required this.prefs});

  @override
  Future<bool> saveFirstTime() async => await prefs.setBool(SharedKeys.onBoardingSkip, false);

  @override
  bool getFirstTime() => prefs.getBool(SharedKeys.onBoardingSkip) ?? true;
}
