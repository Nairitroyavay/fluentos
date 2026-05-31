import '../../models/models.dart';
import '../contracts/user_repository.dart';
import '../local/local_persistence_repository.dart';

class FakeUserRepository implements UserRepository {
  final LocalPersistenceRepository local;

  const FakeUserRepository({required this.local});

  @override
  Future<UserProfile?> loadUser(String userId) async {
    final user = local.loadUser();
    return user.id == userId ? user : null;
  }

  @override
  Future<void> saveUser(UserProfile user) {
    return local.saveUser(user);
  }

  @override
  Future<void> updateOnboardingStatus(String userId, bool completed) {
    return local.saveUser(
      local.loadUser().copyWith(hasCompletedOnboarding: completed),
    );
  }

  @override
  Future<void> updateActiveLanguage(String userId, LanguageProfile language) {
    return local.saveUser(
      local.loadUser().copyWith(
        activeLanguage: language.copyWith(isActive: true, userId: userId),
        activeLanguageProfileId: language.id,
      ),
    );
  }

  @override
  Future<void> updateUserRegion(String userId, String region) {
    return local.saveUser(local.loadUser().copyWith(userRegion: region));
  }

  @override
  Future<void> updateConsent(String userId, ConsentSettings consent) {
    return local.saveUser(local.loadUser().copyWith(consentSettings: consent));
  }
}
