abstract class AuthRepo {
  Future<bool> saveCredits(int credits);
  int? loadCredits();
}
