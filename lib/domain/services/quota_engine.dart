import '../../models/models.dart';

class QuotaEngine {
  const QuotaEngine();

  bool canAddLanguage({
    required SubscriptionEntitlement entitlement,
    required int activeLanguageCount,
  }) {
    return activeLanguageCount < entitlement.activeLanguageLimit;
  }

  bool canStartAiSession({
    required SubscriptionEntitlement entitlement,
    required int requestedSeconds,
  }) {
    return entitlement.usedAiSecondsToday + requestedSeconds <=
            entitlement.dailyAiSecondsLimit &&
        entitlement.usedAiSecondsThisMonth + requestedSeconds <=
            entitlement.monthlyAiSecondsLimit;
  }
}
