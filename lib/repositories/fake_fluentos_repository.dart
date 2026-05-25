import '../models/models.dart';

class FakeFluentOSRepository {
  const FakeFluentOSRepository();

  UserProfile loadUser() {
    return const UserProfile(
      id: 'user_roy',
      name: 'Roy',
      email: 'roy@example.com',
      subscription: SubscriptionState.free,
      activeLanguage: null,
      hasCompletedOnboarding: false,
      speakingGoal: 'Everyday conversation',
      streakDays: 12,
      totalSpeakMinutes: 186,
    );
  }

  List<LanguageProfile> loadLanguages() {
    return const [
      LanguageProfile(
        id: 'lang_es',
        code: 'es',
        name: 'Spanish',
        nativeName: 'Español',
        flag: 'ES',
        level: 'A2',
        focus: 'Travel and daily life',
        fluencyScore: 458,
      ),
      LanguageProfile(
        id: 'lang_fr',
        code: 'fr',
        name: 'French',
        nativeName: 'Français',
        flag: 'FR',
        level: 'A1',
        focus: 'Cafe and city basics',
        fluencyScore: 220,
      ),
      LanguageProfile(
        id: 'lang_ja',
        code: 'ja',
        name: 'Japanese',
        nativeName: '日本語',
        flag: 'JP',
        level: 'Starter',
        focus: 'Polite introductions',
        fluencyScore: 120,
      ),
      LanguageProfile(
        id: 'lang_de',
        code: 'de',
        name: 'German',
        nativeName: 'Deutsch',
        flag: 'DE',
        level: 'Starter',
        focus: 'Work and errands',
        fluencyScore: 140,
      ),
    ];
  }

  List<DailyMission> loadDailyMissions() {
    return const [
      DailyMission(
        id: 'mission_coffee',
        title: 'Order a coffee',
        description: 'Ask for a coffee politely and confirm the size.',
        scenario: 'You are at a busy cafe counter in Madrid.',
        successCue: 'Use quisiera, tamaño, and por favor.',
        targetPhrases: ['quisiera', 'tamaño mediano', 'por favor'],
        estimatedMinutes: 4,
      ),
      DailyMission(
        id: 'mission_directions',
        title: 'Ask for directions',
        description: 'Find the train station and clarify the next turn.',
        scenario: 'A local is helping you near a metro entrance.',
        successCue: 'Ask where something is and repeat the direction back.',
        targetPhrases: ['dónde está', 'a la derecha', 'gracias'],
        estimatedMinutes: 5,
      ),
      DailyMission(
        id: 'mission_checkin',
        title: 'Hotel check-in',
        description: 'Confirm your reservation and ask about breakfast.',
        scenario: 'You have just arrived at a small hotel.',
        successCue: 'Use tengo una reserva and está incluido.',
        targetPhrases: ['tengo una reserva', 'desayuno', 'incluido'],
        estimatedMinutes: 6,
      ),
    ];
  }

  SpeakSession buildSpeakSession(DailyMission mission) {
    final now = DateTime.now();

    return SpeakSession(
      id: 'session_${mission.id}',
      missionId: mission.id,
      title: mission.title,
      scenarioPrompt: mission.scenario,
      coachPrompt: _coachPromptForMission(mission.id),
      turns: [
        SpeakTurn(
          id: 'coach_intro_${mission.id}',
          speaker: SpeakSpeaker.coach,
          text: _coachPromptForMission(mission.id),
          createdAt: now,
        ),
      ],
      correction: null,
      phase: SpeakSessionPhase.ready,
      attemptCount: 0,
      isSavedToReview: false,
    );
  }

  Correction fakeCorrectionForMission(String missionId) {
    switch (missionId) {
      case 'mission_directions':
        return const Correction(
          id: 'correction_directions',
          originalText: 'Donde es la estacion tren?',
          correctedText: '¿Dónde está la estación de tren?',
          explanation: 'Use está for location and add de before tren.',
          focusArea: 'Location question',
        );
      case 'mission_checkin':
        return const Correction(
          id: 'correction_checkin',
          originalText: 'Tengo reservacion para Roy.',
          correctedText: 'Tengo una reserva a nombre de Roy.',
          explanation:
              'A nombre de is the natural way to say the booking name.',
          focusArea: 'Hotel check-in',
        );
      case 'mission_coffee':
      default:
        return const Correction(
          id: 'correction_coffee',
          originalText: 'Yo quiero un cafe mediano',
          correctedText: 'Quisiera un café mediano, por favor.',
          explanation: 'Quisiera sounds more polite when ordering.',
          focusArea: 'Polite requests',
        );
    }
  }

  List<ReviewItem> loadReviewItems() {
    return [
      ReviewItem(
        id: 'review_seed_1',
        languageCode: 'es',
        missionTitle: 'Order a coffee',
        dateAdded: DateTime.now().subtract(const Duration(days: 1)),
        correction: const Correction(
          id: 'correction_seed_1',
          originalText: 'Yo quiero un cafe',
          correctedText: 'Quisiera un café, por favor.',
          explanation: 'Quisiera is softer and more natural in a cafe.',
          focusArea: 'Polite requests',
        ),
      ),
      ReviewItem(
        id: 'review_seed_2',
        languageCode: 'es',
        missionTitle: 'Ask for directions',
        dateAdded: DateTime.now().subtract(const Duration(days: 3)),
        correction: const Correction(
          id: 'correction_seed_2',
          originalText: 'La estacion donde?',
          correctedText: '¿Dónde está la estación?',
          explanation: 'Put dónde está before the place you are asking about.',
          focusArea: 'Question order',
        ),
      ),
    ];
  }

  List<FluencySnapshot> loadFluencySnapshots() {
    final today = DateTime.now();

    return [
      FluencySnapshot(
        date: today.subtract(const Duration(days: 6)),
        score: 372,
        speakMinutes: 14,
        correctionsSaved: 2,
      ),
      FluencySnapshot(
        date: today.subtract(const Duration(days: 5)),
        score: 386,
        speakMinutes: 18,
        correctionsSaved: 3,
      ),
      FluencySnapshot(
        date: today.subtract(const Duration(days: 4)),
        score: 401,
        speakMinutes: 21,
        correctionsSaved: 4,
      ),
      FluencySnapshot(
        date: today.subtract(const Duration(days: 3)),
        score: 418,
        speakMinutes: 16,
        correctionsSaved: 2,
      ),
      FluencySnapshot(
        date: today.subtract(const Duration(days: 2)),
        score: 433,
        speakMinutes: 23,
        correctionsSaved: 5,
      ),
      FluencySnapshot(
        date: today.subtract(const Duration(days: 1)),
        score: 446,
        speakMinutes: 20,
        correctionsSaved: 3,
      ),
      FluencySnapshot(
        date: today,
        score: 458,
        speakMinutes: 12,
        correctionsSaved: 1,
      ),
    ];
  }

  String _coachPromptForMission(String missionId) {
    switch (missionId) {
      case 'mission_directions':
        return 'Perdón, ¿en qué puedo ayudarte?';
      case 'mission_checkin':
        return 'Buenas tardes. ¿Tiene una reserva?';
      case 'mission_coffee':
      default:
        return 'Buenos días. ¿Qué le gustaría tomar?';
    }
  }
}
