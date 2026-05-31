import '../../models/models.dart';

abstract class LanguageRepository {
  Future<List<LanguageOption>> loadLanguageOptions();
  Future<List<LanguageProfile>> loadUserLanguages(String userId);
  Future<void> saveLanguageProfile(String userId, LanguageProfile profile);
  Future<void> setActiveLanguage(String userId, String languageProfileId);
}
