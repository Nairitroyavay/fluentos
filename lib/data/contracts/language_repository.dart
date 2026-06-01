import '../../models/models.dart';

abstract class LanguageRepository {
  List<LanguageOption> cachedLanguageOptions();
  Future<List<LanguageOption>> loadLanguageOptions();
  Future<List<LanguageProfile>> loadUserLanguages(String userId);
  LanguageProfile createLanguageProfile(
    String userId,
    OnboardingProfile profile,
  );
  String targetCultureFor(LanguageOption target, String userRegion);
  String accentPreferenceFor(LanguageOption target, String userRegion);
  Future<void> saveLanguageProfile(String userId, LanguageProfile profile);
  Future<void> setActiveLanguage(String userId, String languageProfileId);
}
