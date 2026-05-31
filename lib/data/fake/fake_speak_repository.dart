import '../../models/models.dart';
import '../../repositories/fake_fluentos_repository.dart';
import '../contracts/speak_repository.dart';
import '../local/local_persistence_repository.dart';

class FakeSpeakRepository implements SpeakRepository {
  final LocalPersistenceRepository local;
  final FakeFluentOSRepository defaults;

  const FakeSpeakRepository({required this.local, required this.defaults});

  @override
  Future<SpeakSession> createSession(
    DailyMission mission,
    SpeakMode mode,
  ) async {
    final user = local.loadUser();
    return defaults
        .buildSpeakSession(mission, mode: mode)
        .copyWith(
          userId: user.id,
          languageProfileId: mission.languageProfileId.isEmpty
              ? user.activeLanguageProfileId
              : mission.languageProfileId,
        );
  }

  @override
  Future<TranscriptResult> transcribeMockOrRemote(SpeakSession session) async {
    final user = local.loadUser();
    final language = user.activeLanguage;
    final mission = local.loadDailyMissions().firstWhere(
      (item) => item.id == session.missionId,
      orElse: () => DailyMission(
        id: session.missionId,
        languageCode: language?.code ?? 'en',
        title: session.title,
        description: session.scenario,
        scenario: session.scenario,
        coachPrompt: session.coachPrompt,
        successCue: session.coachPrompt,
        targetPhrases: const [],
        estimatedMinutes: 5,
        difficulty: 'Starter',
        focusArea: 'Speaking confidence',
        category: 'Introduction',
      ),
    );
    final transcript = language == null
        ? 'Hello, my name is Roy.'
        : defaults.fakeTranscriptForMission(
            mission: mission,
            language: language,
            mode: session.mode,
          );
    final confidenceLow =
        session.mode == SpeakMode.freeTalk ||
        session.mode == SpeakMode.pronunciationDrill;
    return TranscriptResult(
      id: 'transcript_${session.id}',
      sessionId: session.id,
      transcriptText: transcript,
      transcriptConfidence: confidenceLow ? 0.64 : 0.91,
      confidenceLow: confidenceLow,
      languageDetected: language?.code ?? 'en',
      provider: 'mock',
      requestId: 'mock_${session.id}',
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<Correction> correctTranscript(CorrectionRequest request) async {
    final user = local.loadUser();
    final language = user.activeLanguage;
    final mission = local.loadDailyMissions().firstWhere(
      (item) => item.id == request.missionId,
      orElse: () => DailyMission(
        id: request.missionId,
        languageCode: request.targetLanguageCode,
        title: 'Daily Mission',
        description: 'Practice speaking.',
        scenario: 'Practice speaking.',
        coachPrompt: 'Speak clearly.',
        successCue: 'Speak clearly.',
        targetPhrases: const [],
        estimatedMinutes: 5,
        difficulty: 'Starter',
        focusArea: 'Speaking confidence',
        category: 'Introduction',
      ),
    );
    return defaults.fakeCorrectionForSession(
      mission: mission,
      language:
          language ??
          LanguageProfile(
            id: request.languageProfileId,
            userId: request.userId,
            code: request.targetLanguageCode,
            name: request.targetLanguageCode,
            nativeName: request.targetLanguageCode,
            flag: request.targetLanguageCode,
            supportStatus: LanguageSupportStatus.supported,
            baseLanguageCode: request.baseLanguageCode,
            baseLanguageName: request.baseLanguageCode,
            userRegion: request.region,
            targetCulture: 'Global culture',
            level: request.currentLevel,
            focus: request.learningGoal,
            goal: request.learningGoal,
            fluencyScore: 160,
            confidenceScore: 40,
            pronunciationScore: 50,
            weakSounds: request.userWeakAreas,
            scriptMode: 'Latin script',
            scriptName: 'Latin script',
            hasRomanization: false,
            hasTransliteration: false,
            supportsTransliteration: false,
            commonRegions: const [],
            defaultAccentOptions: const ['Global clear'],
            accentPreference: 'Global clear',
            isActive: true,
          ),
      mode: request.mode,
      transcript: request.transcriptText,
    );
  }

  @override
  Future<void> saveSession(String userId, SpeakSession session) {
    return local.saveSpeakSession(session.copyWith(userId: userId));
  }
}
