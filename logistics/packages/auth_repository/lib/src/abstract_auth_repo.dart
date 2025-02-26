abstract class AuthRepository {
  Future<void> logIn(String email, String password);

  Future<bool> isLoggedIn();

  Future<String?> getUserRole();

  Future<void> logOut();

  Future<void> forgotPassword({required String email});
}
