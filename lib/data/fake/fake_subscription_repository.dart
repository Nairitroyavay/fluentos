import '../../models/models.dart';
import '../contracts/subscription_repository.dart';
import '../local/local_persistence_repository.dart';

class FakeSubscriptionRepository implements SubscriptionRepository {
  final LocalPersistenceRepository local;

  const FakeSubscriptionRepository({required this.local});

  @override
  Future<SubscriptionEntitlement> loadEntitlement(String userId) async {
    final user = local.loadUser();
    final stored = local.loadEntitlement(userId);
    if (user.subscription == SubscriptionState.free) {
      return stored.copyWith(
        userId: userId,
        tier: SubscriptionState.free,
        activeLanguageLimit: 1,
        canUseAdvancedCorrections: false,
        canUseFearBreaker: false,
        canUseWeeklyReports: false,
      );
    }
    return stored.copyWith(
      userId: userId,
      tier: user.subscription,
      activeLanguageLimit: user.subscription == SubscriptionState.pro ? 3 : 8,
      dailyAiSecondsLimit: user.subscription == SubscriptionState.pro
          ? 2400
          : 5400,
      monthlyAiSecondsLimit: user.subscription == SubscriptionState.pro
          ? 54000
          : 144000,
      canUseAdvancedCorrections: true,
      canUseFearBreaker: true,
      canUseWeeklyReports: true,
    );
  }

  @override
  Future<bool> canAddLanguage(String userId) async {
    final entitlement = await loadEntitlement(userId);
    final active = local.loadUser().activeLanguage;
    final activeCount = active == null ? 0 : 1;
    return activeCount < entitlement.activeLanguageLimit;
  }

  @override
  Future<bool> canStartAiSession(String userId, int requestedSeconds) async {
    final entitlement = await loadEntitlement(userId);
    return entitlement.usedAiSecondsToday + requestedSeconds <=
            entitlement.dailyAiSecondsLimit &&
        entitlement.usedAiSecondsThisMonth + requestedSeconds <=
            entitlement.monthlyAiSecondsLimit;
  }

  @override
  Future<void> recordAiUsage(String userId, int secondsUsed) async {
    final entitlement = await loadEntitlement(userId);
    await local.saveEntitlement(
      entitlement.copyWith(
        usedAiSecondsToday:
            entitlement.usedAiSecondsToday + secondsUsed.clamp(0, 3600),
        usedAiSecondsThisMonth:
            entitlement.usedAiSecondsThisMonth + secondsUsed.clamp(0, 3600),
      ),
    );
  }
}
