import '../../models/models.dart';
import '../contracts/auth_repository.dart';
import '../local/local_persistence_repository.dart';

class FakeAuthRepository implements AuthRepository {
  final LocalPersistenceRepository local;

  const FakeAuthRepository({required this.local});

  @override
  Future<AuthSession?> currentSession() async {
    if (!local.loadSignedIn()) {
      return null;
    }
    final user = local.loadUser();
    return AuthSession(
      id: 'session_${user.id}',
      userId: user.id,
      email: user.email,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<AuthSession> signInWithEmail(String email, String password) async {
    final user = local.loadUser().copyWith(email: email);
    await local.saveUser(user);
    await local.saveSignedIn(true);
    return AuthSession(
      id: 'session_${user.id}',
      userId: user.id,
      email: user.email,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<AuthSession> createAccount(
    String name,
    String email,
    String password,
  ) async {
    final user = local.loadUser().copyWith(name: name, email: email);
    await local.saveUser(user);
    await local.saveSignedIn(true);
    return AuthSession(
      id: 'session_${user.id}',
      userId: user.id,
      email: user.email,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> signOut() {
    return local.saveSignedIn(false);
  }

  @override
  Future<void> deleteAccount() {
    return local.clearAll();
  }
}
