import '../../models/models.dart';

abstract class AuthRepository {
  Future<AuthSession?> currentSession();
  Future<AuthSession> signInWithEmail(String email, String password);
  Future<AuthSession> createAccount(String name, String email, String password);
  Future<void> signOut();
  Future<void> deleteAccount();
}
