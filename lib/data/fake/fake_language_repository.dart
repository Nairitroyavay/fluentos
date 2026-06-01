import '../../models/models.dart';
import '../../repositories/fake_fluentos_repository.dart';
import '../contracts/language_repository.dart';
import '../local/local_persistence_repository.dart';

class FakeLanguageRepository implements LanguageRepository {
  final LocalPersistenceRepository local;
  final FakeFluentOSRepository defaults;

  const FakeLanguageRepository({required this.local, required this.defaults});

  @override
  List<LanguageOption> cachedLanguageOptions() {
    return defaults.loadLanguageOptions();
  }

  @override
  Future<List<LanguageOption>> loadLanguageOptions() async {
    return cachedLanguageOptions();
  }

  @override
  Future<List<LanguageProfile>> loadUserLanguages(String userId) async {
    final active = local.loadUser().activeLanguage;
    if (active == null) {
      return const [];
    }
    return [active.copyWith(userId: userId)];
  }

  @override
  Future<void> saveLanguageProfile(String userId, LanguageProfile profile) {
    final next = profile.copyWith(userId: userId);
    final user = local.loadUser();
    if (next.isActive || user.activeLanguage == null) {
      return local.saveUser(
        user.copyWith(activeLanguage: next, activeLanguageProfileId: next.id),
      );
    }
    return Future<void>.value();
  }

  @override
  Future<void> setActiveLanguage(String userId, String languageProfileId) {
    final active = local.loadUser().activeLanguage;
    if (active == null || active.id != languageProfileId) {
      return Future<void>.value();
    }
    return local.saveUser(
      local.loadUser().copyWith(
        activeLanguage: active.copyWith(isActive: true, userId: userId),
        activeLanguageProfileId: active.id,
      ),
    );
  }

  @override
  LanguageProfile createLanguageProfile(
    String userId,
    OnboardingProfile profile,
  ) {
    return defaults.createLanguageProfile(profile).copyWith(userId: userId);
  }

  @override
  String targetCultureFor(LanguageOption target, String userRegion) {
    return defaults.targetCultureFor(target, userRegion);
  }

  @override
  String accentPreferenceFor(LanguageOption target, String userRegion) {
    return defaults.accentPreferenceFor(target, userRegion);
  }
}
