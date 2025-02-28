abstract class ThemeRepoInterface {
  String? loadCurrentTheme();
  Future<void> setTheme(String theme);
}
