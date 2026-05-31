import '../../models/models.dart';

abstract class UserRepository {
  Future<UserProfile?> loadUser(String userId);
  Future<void> saveUser(UserProfile user);
  Future<void> updateOnboardingStatus(String userId, bool completed);
  Future<void> updateActiveLanguage(String userId, LanguageProfile language);
  Future<void> updateUserRegion(String userId, String region);
  Future<void> updateConsent(String userId, ConsentSettings consent);
}
