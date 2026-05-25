import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

class AuthNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void setAuthenticated(bool value) => state = value;
}
final authProvider = NotifierProvider<AuthNotifier, bool>(AuthNotifier.new);

final userProvider = Provider<UserProfile>((ref) {
  return UserProfile(
    id: 'u1',
    name: 'Roy',
    subscription: SubscriptionState.free,
    activeLanguage: LanguageProfile(
      id: 'l1',
      code: 'es',
      name: 'Spanish',
      fluencyScore: 450,
    ),
  );
});

final dailyMissionProvider = Provider<DailyMission>((ref) {
  return DailyMission(
    title: 'Order a coffee in Spanish',
    description: 'Use the words "por favor" and "gracias".',
  );
});

class ReviewsNotifier extends Notifier<List<ReviewItem>> {
  @override
  List<ReviewItem> build() {
    return [
      ReviewItem(
        id: 'r1',
        dateAdded: DateTime.now().subtract(const Duration(days: 1)),
        correction: Correction(
          originalText: 'Yo quiero un cafe',
          correctedText: 'Quisiera un café, por favor.',
          explanation: '"Quisiera" is more polite when ordering.',
        ),
      )
    ];
  }
}
final reviewsProvider = NotifierProvider<ReviewsNotifier, List<ReviewItem>>(ReviewsNotifier.new);

class SpeakSessionNotifier extends Notifier<SpeakSession?> {
  @override
  SpeakSession? build() => null;
}
final speakSessionProvider = NotifierProvider<SpeakSessionNotifier, SpeakSession?>(SpeakSessionNotifier.new);
