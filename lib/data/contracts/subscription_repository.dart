import '../../models/models.dart';

abstract class SubscriptionRepository {
  Future<SubscriptionEntitlement> loadEntitlement(String userId);
  Future<bool> canAddLanguage(String userId);
  Future<bool> canStartAiSession(String userId, int requestedSeconds);
  Future<void> recordAiUsage(String userId, int secondsUsed);
}
