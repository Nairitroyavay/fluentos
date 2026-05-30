import '../models/models.dart';
import 'fake_mission_engine.dart';

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
      speakingGoal: 'Speak with confidence',
      streakDays: 0,
      totalSpeakMinutes: 0,
    );
  }

  List<LanguageOption> loadLanguageOptions() {
    return const [
      LanguageOption(
        code: 'en',
        name: 'English',
        nativeName: 'English',
        flag: 'EN',
        isPhaseOne: true,
        canBeBase: true,
        canBeTarget: true,
      ),
      LanguageOption(
        code: 'hi',
        name: 'Hindi',
        nativeName: 'हिन्दी',
        flag: 'HI',
        isPhaseOne: true,
        canBeBase: true,
        canBeTarget: true,
      ),
      LanguageOption(
        code: 'bn',
        name: 'Bengali',
        nativeName: 'বাংলা',
        flag: 'BN',
        isPhaseOne: true,
        canBeBase: true,
        canBeTarget: true,
      ),
      LanguageOption(
        code: 'ta',
        name: 'Tamil',
        nativeName: 'தமிழ்',
        flag: 'TA',
        isPhaseOne: false,
        canBeBase: true,
        canBeTarget: true,
      ),
      LanguageOption(
        code: 'te',
        name: 'Telugu',
        nativeName: 'తెలుగు',
        flag: 'TE',
        isPhaseOne: false,
        canBeBase: true,
        canBeTarget: true,
      ),
      LanguageOption(
        code: 'mr',
        name: 'Marathi',
        nativeName: 'मराठी',
        flag: 'MR',
        isPhaseOne: false,
        canBeBase: true,
        canBeTarget: true,
      ),
      LanguageOption(
        code: 'kn',
        name: 'Kannada',
        nativeName: 'ಕನ್ನಡ',
        flag: 'KN',
        isPhaseOne: false,
        canBeBase: true,
        canBeTarget: true,
      ),
      LanguageOption(
        code: 'ml',
        name: 'Malayalam',
        nativeName: 'മലയാളം',
        flag: 'ML',
        isPhaseOne: false,
        canBeBase: true,
        canBeTarget: true,
      ),
      LanguageOption(
        code: 'gu',
        name: 'Gujarati',
        nativeName: 'ગુજરાતી',
        flag: 'GU',
        isPhaseOne: false,
        canBeBase: true,
        canBeTarget: false,
      ),
      LanguageOption(
        code: 'pa',
        name: 'Punjabi',
        nativeName: 'ਪੰਜਾਬੀ',
        flag: 'PA',
        isPhaseOne: false,
        canBeBase: true,
        canBeTarget: false,
      ),
      LanguageOption(
        code: 'or',
        name: 'Odia',
        nativeName: 'ଓଡ଼ିଆ',
        flag: 'OD',
        isPhaseOne: false,
        canBeBase: true,
        canBeTarget: false,
      ),
      LanguageOption(
        code: 'as',
        name: 'Assamese',
        nativeName: 'অসমীয়া',
        flag: 'AS',
        isPhaseOne: false,
        canBeBase: true,
        canBeTarget: false,
      ),
      LanguageOption(
        code: 'ur',
        name: 'Urdu',
        nativeName: 'اردو',
        flag: 'UR',
        isPhaseOne: false,
        canBeBase: true,
        canBeTarget: false,
      ),
      LanguageOption(
        code: 'ja',
        name: 'Japanese',
        nativeName: '日本語',
        flag: 'JA',
        isPhaseOne: true,
        canBeBase: false,
        canBeTarget: true,
      ),
      LanguageOption(
        code: 'de',
        name: 'German',
        nativeName: 'Deutsch',
        flag: 'DE',
        isPhaseOne: true,
        canBeBase: false,
        canBeTarget: true,
      ),
      LanguageOption(
        code: 'fr',
        name: 'French',
        nativeName: 'Francais',
        flag: 'FR',
        isPhaseOne: false,
        canBeBase: false,
        canBeTarget: true,
      ),
      LanguageOption(
        code: 'es',
        name: 'Spanish',
        nativeName: 'Espanol',
        flag: 'ES',
        isPhaseOne: false,
        canBeBase: false,
        canBeTarget: true,
      ),
      LanguageOption(
        code: 'ko',
        name: 'Korean',
        nativeName: '한국어',
        flag: 'KO',
        isPhaseOne: false,
        canBeBase: false,
        canBeTarget: true,
      ),
      LanguageOption(
        code: 'more',
        name: 'More',
        nativeName: 'More',
        flag: '+',
        isPhaseOne: false,
        canBeBase: true,
        canBeTarget: false,
      ),
    ];
  }

  LanguageProfile createLanguageProfile(OnboardingProfile profile) {
    final target = loadLanguageOptions().firstWhere(
      (option) => option.code == profile.targetLanguageCode,
      orElse: () => loadLanguageOptions().first,
    );

    final baseline = profile.voiceBaseline;
    return LanguageProfile(
      id: 'lang_${profile.targetLanguageCode}_${profile.baseLanguageCode}',
      code: target.code,
      name: target.name,
      nativeName: target.nativeName,
      flag: target.flag,
      baseLanguageCode: profile.baseLanguageCode,
      baseLanguageName: profile.baseLanguageName,
      level: _levelLabel(profile.currentLevel),
      focus: _focusFor(profile.learningGoal, target.name),
      fluencyScore: _initialFluency(profile.currentLevel),
      confidenceScore: baseline.confidenceScore,
      weakSounds: _weakSoundsFor(target.code, baseline.firstWeakArea),
      scriptMode: _scriptModeFor(target.code),
      supportsTransliteration: target.code != 'en' && target.code != 'de',
      isActive: true,
    );
  }

  ProgressState loadInitialProgress({
    required OnboardingProfile profile,
    required LanguageProfile language,
  }) {
    final today = DateTime.now();
    final fluencyScore = language.fluencyScore;
    final confidence = profile.voiceBaseline.confidenceScore;
    final pronunciation = profile.voiceBaseline.pronunciationScore;
    final grammar = _initialGrammar(profile.currentLevel);
    final readiness = ((fluencyScore / 10) + confidence + pronunciation) ~/ 3;

    return ProgressState(
      speakingMinutes: 0,
      completedMissions: 0,
      correctionsSaved: 0,
      repeatedCorrections: 0,
      masteredReviewItems: 0,
      scenarioCount: 0,
      streakDays: 0,
      fluencyScore: fluencyScore,
      confidenceScore: confidence,
      pronunciationScore: pronunciation,
      grammarScore: grammar,
      conversationReadiness: readiness.clamp(15, 86),
      skillScores: {
        'Speaking': confidence,
        'Listening': 42,
        'Pronunciation': pronunciation,
        'Grammar': grammar,
        'Vocabulary': 38,
        'Response speed': 34,
      },
      snapshots: [
        for (var index = 6; index >= 0; index--)
          FluencySnapshot(
            date: today.subtract(Duration(days: index)),
            fluencyScore: index == 0
                ? fluencyScore
                : (fluencyScore - 6 + index),
            confidenceScore: confidence,
            pronunciationScore: pronunciation,
            grammarScore: grammar,
            conversationReadiness: readiness.clamp(15, 86),
            speakMinutes: 0,
            correctionsSaved: 0,
            completedMissions: 0,
          ),
      ],
    );
  }

  List<DailyMission> buildMissions({
    required OnboardingProfile profile,
    required LanguageProfile language,
  }) {
    return const FakeMissionEngine().generateMissions(
      profile: profile,
      language: language,
    );
  }

  SpeakSession buildSpeakSession(
    DailyMission mission, {
    SpeakMode mode = SpeakMode.dailyMission,
  }) {
    final now = DateTime.now();
    final title = mode == SpeakMode.dailyMission
        ? mission.title
        : '${mode.label}: ${mission.category}';

    return SpeakSession(
      id: 'session_${mission.id}_${mode.name}_${now.millisecondsSinceEpoch}',
      missionId: mission.id,
      mode: mode,
      title: title,
      scenarioPrompt: _scenarioForMode(mission, mode),
      coachPrompt: _coachPromptForMode(mission, mode),
      turns: [
        SpeakTurn(
          id: 'coach_intro_${mission.id}_${now.millisecondsSinceEpoch}',
          speaker: SpeakSpeaker.coach,
          text: _coachPromptForMode(mission, mode),
          createdAt: now,
        ),
      ],
      transcriptText: null,
      correction: null,
      phase: SpeakSessionPhase.ready,
      attemptCount: 0,
      isSavedToReview: false,
      transcriptConfidenceLow: false,
    );
  }

  String fakeTranscriptForMission({
    required DailyMission mission,
    required LanguageProfile language,
    required SpeakMode mode,
  }) {
    if (mode == SpeakMode.freeTalk) {
      return 'I want to speak better every day but sometimes I stop because I feel nervous.';
    }

    switch (language.code) {
      case 'ja':
        return 'Hajimemashite, Roy desu. Design team de work shite imasu. Yoroshiku.';
      case 'de':
        return 'Ich bin Roy und ich lerne Deutsch fur reisen. Ich mochte sprechen klar.';
      case 'hi':
        return 'Mera naam Roy hai. Main Hindi seekhta hoon kyunki mujhe confident bolna hai.';
      case 'bn':
        return 'Amar naam Roy. Ami Bangla shikte chai karon bondhuder sathe kotha bolte chai.';
      case 'en':
      default:
        if (mission.category == 'College') {
          return 'I missed class because I was not feeling good and I submit assignment today.';
        }
        return 'Hello, my name Roy. I want speak confidently and I am learning every day.';
    }
  }

  Correction fakeCorrectionForSession({
    required DailyMission mission,
    required LanguageProfile language,
    required SpeakMode mode,
    required String transcript,
  }) {
    switch (language.code) {
      case 'ja':
        return Correction(
          id: 'correction_${mission.id}_${mode.name}_ja',
          originalText: transcript,
          correctedText:
              'Hajimemashite. Roy desu. Design team de hataraite imasu. Yoroshiku onegaishimasu.',
          naturalText:
              'Hajimemashite, Roy desu. Design team de hataraite imasu. Yoroshiku onegaishimasu.',
          explanation:
              'Use hataraite imasu for "I work" and add yoroshiku onegaishimasu for a polite closing.',
          focusArea: 'Polite endings',
          confidenceScore: 58,
          pronunciationScore: 62,
          grammarScore: 54,
          fluencyScore: 57,
          coachNote:
              'Good first attempt. Keep the sentence endings softer and slower.',
        );
      case 'de':
        return Correction(
          id: 'correction_${mission.id}_${mode.name}_de',
          originalText: transcript,
          correctedText:
              'Ich bin Roy und ich lerne Deutsch zum Reisen. Ich mochte klar sprechen.',
          naturalText:
              'Hallo, ich bin Roy. Ich lerne Deutsch zum Reisen und mochte klarer sprechen.',
          explanation:
              'Use zum Reisen for purpose, and keep the verb near the end in mochte klar sprechen.',
          focusArea: 'German word order',
          confidenceScore: 61,
          pronunciationScore: 58,
          grammarScore: 60,
          fluencyScore: 59,
          coachNote:
              'Your structure is understandable. Repeat with a little more pause after each sentence.',
        );
      case 'hi':
        return Correction(
          id: 'correction_${mission.id}_${mode.name}_hi',
          originalText: transcript,
          correctedText:
              'Mera naam Roy hai. Main Hindi seekh raha hoon kyunki mujhe atmavishvas ke saath bolna hai.',
          naturalText:
              'Mera naam Roy hai. Main Hindi seekh raha hoon, aur main atmavishvas se bolna chahta hoon.',
          explanation:
              'Use seekh raha hoon for an ongoing action and make the confidence phrase more natural.',
          focusArea: 'Ongoing action',
          confidenceScore: 63,
          pronunciationScore: 66,
          grammarScore: 61,
          fluencyScore: 62,
          coachNote:
              'This was clear. Now make the rhythm smoother by grouping words together.',
        );
      case 'bn':
        return Correction(
          id: 'correction_${mission.id}_${mode.name}_bn',
          originalText: transcript,
          correctedText:
              'Amar naam Roy. Ami Bangla shikhte chai, karon ami bondhuder sathe kotha bolte chai.',
          naturalText:
              'Amar naam Roy. Ami Bangla shikhchi, karon bondhuder sathe bhalo kore kotha bolte chai.',
          explanation:
              'Use shikhte chai for "want to learn" and keep the reason in one smooth sentence.',
          focusArea: 'Reason sentence',
          confidenceScore: 60,
          pronunciationScore: 59,
          grammarScore: 57,
          fluencyScore: 58,
          coachNote:
              'Nice warmth. Repeat once with a clearer pause after your name.',
        );
      case 'en':
      default:
        return Correction(
          id: 'correction_${mission.id}_${mode.name}_en',
          originalText: transcript,
          correctedText: mission.category == 'College'
              ? 'I missed class because I was not feeling well, and I will submit the assignment today.'
              : 'Hello, my name is Roy. I want to speak confidently, and I am learning every day.',
          naturalText: mission.category == 'College'
              ? 'I am sorry I missed class yesterday. I was not feeling well, and I will submit the assignment today.'
              : 'Hi, I am Roy. I am practicing every day because I want to speak with confidence.',
          explanation: mission.category == 'College'
              ? 'Use "was not feeling well" and "will submit" to make the reason and next action clear.'
              : 'Add "is" after my name and "to" before speak. The natural version sounds less translated.',
          focusArea: mission.category == 'College'
              ? 'Reason + next action'
              : 'Basic sentence structure',
          confidenceScore: 64,
          pronunciationScore: 68,
          grammarScore: 63,
          fluencyScore: 65,
          coachNote:
              'You are understandable. Repeat slowly and finish the last word instead of rushing.',
        );
    }
  }

  List<ReviewItem> loadReviewItems() => const [];

  String _scenarioForMode(DailyMission mission, SpeakMode mode) {
    switch (mode) {
      case SpeakMode.roleplay:
        return '${mission.scenario} The coach will answer like the other person.';
      case SpeakMode.shadowing:
        return 'Listen to the natural version, then shadow it with the same rhythm.';
      case SpeakMode.pronunciationDrill:
        return 'Focus on the weak sound in today\'s mission before the full answer.';
      case SpeakMode.fearBreaker:
        return 'A low-pressure speaking ladder for nervous days.';
      case SpeakMode.freeTalk:
        return 'Speak freely about your day. The coach will correct one useful sentence.';
      case SpeakMode.dailyMission:
        return mission.scenario;
    }
  }

  String _coachPromptForMode(DailyMission mission, SpeakMode mode) {
    switch (mode) {
      case SpeakMode.roleplay:
        return mission.coachPrompt;
      case SpeakMode.shadowing:
        return 'Repeat this idea naturally: ${mission.successCue}';
      case SpeakMode.pronunciationDrill:
        return 'Say each target phrase twice, then answer the mission.';
      case SpeakMode.fearBreaker:
        return 'Start with one word. You can build the sentence after that.';
      case SpeakMode.freeTalk:
        return 'Tell me what happened today in simple sentences.';
      case SpeakMode.dailyMission:
        return mission.coachPrompt;
    }
  }

  String _levelLabel(String level) {
    if (level.contains('nothing')) {
      return 'Starter';
    }
    if (level.contains('some words')) {
      return 'A1';
    }
    if (level.contains('understand')) {
      return 'A1 speaking';
    }
    if (level.contains('broken')) {
      return 'A2';
    }
    return level;
  }

  String _focusFor(String goal, String target) {
    final lower = goal.toLowerCase();
    if (lower.contains('college')) {
      return '$target for college confidence';
    }
    if (lower.contains('job')) {
      return '$target for interviews and work';
    }
    if (lower.contains('travel')) {
      return '$target for travel situations';
    }
    if (lower.contains('anime') || lower.contains('culture')) {
      return '$target for culture and conversation';
    }
    return '$target speaking confidence';
  }

  int _initialFluency(String level) {
    if (level.contains('Advanced')) {
      return 560;
    }
    if (level.contains('Intermediate')) {
      return 420;
    }
    if (level.contains('broken')) {
      return 300;
    }
    if (level.contains('understand')) {
      return 245;
    }
    if (level.contains('some words')) {
      return 205;
    }
    return 160;
  }

  int _initialGrammar(String level) {
    if (level.contains('Advanced')) {
      return 76;
    }
    if (level.contains('Intermediate')) {
      return 64;
    }
    if (level.contains('broken')) {
      return 48;
    }
    return 36;
  }

  List<String> _weakSoundsFor(String code, String baselineWeakArea) {
    switch (code) {
      case 'ja':
        return ['r/l rhythm', 'long vowels', baselineWeakArea];
      case 'de':
        return ['ch sound', 'word endings', baselineWeakArea];
      case 'hi':
        return ['retroflex sounds', 'aspiration', baselineWeakArea];
      case 'bn':
        return ['soft b/v', 'sentence rhythm', baselineWeakArea];
      case 'en':
      default:
        return ['word endings', 'v/w clarity', baselineWeakArea];
    }
  }

  String _scriptModeFor(String code) {
    switch (code) {
      case 'ja':
        return 'Kana + romaji support';
      case 'hi':
        return 'Devanagari + transliteration';
      case 'bn':
        return 'Bangla script + transliteration';
      case 'de':
      case 'en':
      default:
        return 'Latin script';
    }
  }
}
