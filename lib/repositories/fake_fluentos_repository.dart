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
      userRegion: 'United States',
      baseLanguageCode: 'en',
      targetLanguageCode: 'ja',
      targetCulture: 'Global culture',
      learningGoal: 'Speak with confidence',
      currentLevel: 'I know some words',
      speakingConfidence: 'A little nervous',
      dailyMinutes: 10,
      accentPreference: 'Global clear',
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
        flag: '🌐',
        supportStatus: LanguageSupportStatus.supported,
        canBeBase: true,
        canBeTarget: true,
        scriptName: 'Latin script',
        commonRegions: [
          'United States',
          'United Kingdom',
          'Canada',
          'Australia',
          'Singapore',
          'Global',
        ],
        defaultAccentOptions: [
          'Global clear English',
          'US English',
          'UK English',
          'Indian English',
        ],
      ),
      LanguageOption(
        code: 'hi',
        name: 'Hindi',
        nativeName: 'हिन्दी',
        flag: '🇮🇳',
        supportStatus: LanguageSupportStatus.supported,
        canBeBase: true,
        canBeTarget: true,
        scriptName: 'Devanagari',
        hasTransliteration: true,
        commonRegions: ['India', 'Global diaspora'],
        defaultAccentOptions: ['Standard Hindi', 'Hinglish-aware'],
      ),
      LanguageOption(
        code: 'bn',
        name: 'Bengali',
        nativeName: 'বাংলা',
        flag: '🇧🇩',
        supportStatus: LanguageSupportStatus.supported,
        canBeBase: true,
        canBeTarget: true,
        scriptName: 'Bangla script',
        hasTransliteration: true,
        commonRegions: ['India', 'Bangladesh', 'Global diaspora'],
        defaultAccentOptions: ['Kolkata Bengali', 'Dhaka Bengali'],
      ),
      LanguageOption(
        code: 'ja',
        name: 'Japanese',
        nativeName: '日本語',
        flag: '🇯🇵',
        supportStatus: LanguageSupportStatus.supported,
        canBeBase: true,
        canBeTarget: true,
        scriptName: 'Kana + Kanji',
        hasRomanization: true,
        commonRegions: ['Japan', 'Global culture learners'],
        defaultAccentOptions: ['Tokyo Japanese', 'Beginner clear Japanese'],
      ),
      LanguageOption(
        code: 'de',
        name: 'German',
        nativeName: 'Deutsch',
        flag: '🇩🇪',
        supportStatus: LanguageSupportStatus.supported,
        canBeBase: true,
        canBeTarget: true,
        scriptName: 'Latin script',
        commonRegions: ['Germany', 'Austria', 'Switzerland', 'Europe'],
        defaultAccentOptions: ['Standard German', 'Clear business German'],
      ),
      LanguageOption(
        code: 'es',
        name: 'Spanish',
        nativeName: 'Español',
        flag: '🇪🇸',
        supportStatus: LanguageSupportStatus.supported,
        canBeBase: true,
        canBeTarget: true,
        scriptName: 'Latin script',
        commonRegions: ['Spain', 'Mexico', 'Latin America', 'United States'],
        defaultAccentOptions: [
          'Neutral Spanish',
          'Mexican Spanish',
          'Spain Spanish',
        ],
      ),
      LanguageOption(
        code: 'fr',
        name: 'French',
        nativeName: 'Français',
        flag: '🇫🇷',
        supportStatus: LanguageSupportStatus.supported,
        canBeBase: true,
        canBeTarget: true,
        scriptName: 'Latin script',
        commonRegions: ['France', 'Canada', 'Europe', 'Africa'],
        defaultAccentOptions: ['France French', 'Canadian French'],
      ),
      LanguageOption(
        code: 'ko',
        name: 'Korean',
        nativeName: '한국어',
        flag: '🇰🇷',
        supportStatus: LanguageSupportStatus.supported,
        canBeBase: true,
        canBeTarget: true,
        scriptName: 'Hangul',
        hasRomanization: true,
        commonRegions: ['Korea', 'Global culture learners'],
        defaultAccentOptions: ['Seoul Korean', 'Beginner clear Korean'],
      ),
      LanguageOption(
        code: 'zh',
        name: 'Mandarin Chinese',
        nativeName: '中文',
        flag: '🇨🇳',
        supportStatus: LanguageSupportStatus.preview,
        canBeBase: true,
        canBeTarget: true,
        scriptName: 'Simplified Hanzi',
        hasRomanization: true,
        commonRegions: ['China', 'Taiwan', 'Singapore'],
        defaultAccentOptions: ['Standard Mandarin', 'Pinyin support'],
      ),
      LanguageOption(
        code: 'ar',
        name: 'Arabic',
        nativeName: 'العربية',
        flag: '🇦🇪',
        supportStatus: LanguageSupportStatus.preview,
        canBeBase: true,
        canBeTarget: true,
        scriptName: 'Arabic script',
        hasTransliteration: true,
        commonRegions: ['UAE', 'Saudi Arabia', 'Middle East'],
        defaultAccentOptions: ['Modern Standard Arabic', 'Gulf Arabic preview'],
      ),
      LanguageOption(
        code: 'pt',
        name: 'Portuguese',
        nativeName: 'Português',
        flag: '🇧🇷',
        supportStatus: LanguageSupportStatus.preview,
        canBeBase: true,
        canBeTarget: true,
        scriptName: 'Latin script',
        commonRegions: ['Brazil', 'Portugal'],
        defaultAccentOptions: ['Brazilian Portuguese', 'European Portuguese'],
      ),
      LanguageOption(
        code: 'ta',
        name: 'Tamil',
        nativeName: 'தமிழ்',
        flag: '🇮🇳',
        supportStatus: LanguageSupportStatus.preview,
        canBeBase: true,
        canBeTarget: true,
        scriptName: 'Tamil script',
        hasTransliteration: true,
        commonRegions: ['India', 'Sri Lanka', 'Singapore'],
        defaultAccentOptions: ['Indian Tamil', 'Singapore Tamil preview'],
      ),
      LanguageOption(
        code: 'te',
        name: 'Telugu',
        nativeName: 'తెలుగు',
        flag: '🇮🇳',
        supportStatus: LanguageSupportStatus.preview,
        canBeBase: true,
        canBeTarget: true,
        scriptName: 'Telugu script',
        hasTransliteration: true,
        commonRegions: ['India', 'Global diaspora'],
        defaultAccentOptions: ['Telugu clear speech'],
      ),
      LanguageOption(
        code: 'mr',
        name: 'Marathi',
        nativeName: 'मराठी',
        flag: '🇮🇳',
        supportStatus: LanguageSupportStatus.preview,
        canBeBase: true,
        canBeTarget: true,
        scriptName: 'Devanagari',
        hasTransliteration: true,
        commonRegions: ['India', 'Global diaspora'],
        defaultAccentOptions: ['Marathi clear speech'],
      ),
      LanguageOption(
        code: 'kn',
        name: 'Kannada',
        nativeName: 'ಕನ್ನಡ',
        flag: '🇮🇳',
        supportStatus: LanguageSupportStatus.preview,
        canBeBase: true,
        canBeTarget: true,
        scriptName: 'Kannada script',
        hasTransliteration: true,
        commonRegions: ['India', 'Global diaspora'],
        defaultAccentOptions: ['Kannada clear speech'],
      ),
      LanguageOption(
        code: 'ml',
        name: 'Malayalam',
        nativeName: 'മലയാളം',
        flag: '🇮🇳',
        supportStatus: LanguageSupportStatus.preview,
        canBeBase: true,
        canBeTarget: true,
        scriptName: 'Malayalam script',
        hasTransliteration: true,
        commonRegions: ['India', 'Global diaspora'],
        defaultAccentOptions: ['Malayalam clear speech'],
      ),
      LanguageOption(
        code: 'it',
        name: 'Italian',
        nativeName: 'Italiano',
        flag: '🇮🇹',
        supportStatus: LanguageSupportStatus.preview,
        canBeBase: true,
        canBeTarget: true,
        scriptName: 'Latin script',
        commonRegions: ['Italy', 'Europe'],
        defaultAccentOptions: ['Standard Italian'],
      ),
      LanguageOption(
        code: 'ru',
        name: 'Russian',
        nativeName: 'Русский',
        flag: '🇷🇺',
        supportStatus: LanguageSupportStatus.preview,
        canBeBase: true,
        canBeTarget: true,
        scriptName: 'Cyrillic',
        hasTransliteration: true,
        commonRegions: ['Russia', 'Eastern Europe'],
        defaultAccentOptions: ['Standard Russian'],
      ),
      LanguageOption(
        code: 'th',
        name: 'Thai',
        nativeName: 'ไทย',
        flag: '🇹🇭',
        supportStatus: LanguageSupportStatus.preview,
        canBeBase: true,
        canBeTarget: true,
        scriptName: 'Thai script',
        hasTransliteration: true,
        commonRegions: ['Thailand', 'Southeast Asia'],
        defaultAccentOptions: ['Central Thai preview'],
      ),
      LanguageOption(
        code: 'vi',
        name: 'Vietnamese',
        nativeName: 'Tiếng Việt',
        flag: '🇻🇳',
        supportStatus: LanguageSupportStatus.preview,
        canBeBase: true,
        canBeTarget: true,
        scriptName: 'Latin script',
        commonRegions: ['Vietnam', 'Global diaspora'],
        defaultAccentOptions: ['Northern Vietnamese', 'Southern Vietnamese'],
      ),
      LanguageOption(
        code: 'gu',
        name: 'Gujarati',
        nativeName: 'ગુજરાતી',
        flag: '🇮🇳',
        supportStatus: LanguageSupportStatus.comingSoon,
        canBeBase: true,
        canBeTarget: false,
        scriptName: 'Gujarati script',
        hasTransliteration: true,
        commonRegions: ['India', 'Global diaspora'],
      ),
      LanguageOption(
        code: 'pa',
        name: 'Punjabi',
        nativeName: 'ਪੰਜਾਬੀ',
        flag: '🇮🇳',
        supportStatus: LanguageSupportStatus.comingSoon,
        canBeBase: true,
        canBeTarget: false,
        scriptName: 'Gurmukhi',
        hasTransliteration: true,
        commonRegions: ['India', 'Pakistan', 'Global diaspora'],
      ),
      LanguageOption(
        code: 'or',
        name: 'Odia',
        nativeName: 'ଓଡ଼ିଆ',
        flag: '🇮🇳',
        supportStatus: LanguageSupportStatus.comingSoon,
        canBeBase: true,
        canBeTarget: false,
        scriptName: 'Odia script',
        hasTransliteration: true,
        commonRegions: ['India'],
      ),
      LanguageOption(
        code: 'as',
        name: 'Assamese',
        nativeName: 'অসমীয়া',
        flag: '🇮🇳',
        supportStatus: LanguageSupportStatus.comingSoon,
        canBeBase: true,
        canBeTarget: false,
        scriptName: 'Assamese script',
        hasTransliteration: true,
        commonRegions: ['India'],
      ),
      LanguageOption(
        code: 'ur',
        name: 'Urdu',
        nativeName: 'اردو',
        flag: '🇵🇰',
        supportStatus: LanguageSupportStatus.comingSoon,
        canBeBase: true,
        canBeTarget: false,
        scriptName: 'Perso-Arabic script',
        hasTransliteration: true,
        commonRegions: ['India', 'Pakistan', 'Middle East'],
      ),
      LanguageOption(
        code: 'other',
        name: 'Other',
        nativeName: 'Other',
        flag: '+',
        supportStatus: LanguageSupportStatus.comingSoon,
        canBeBase: true,
        canBeTarget: true,
        scriptName: 'Multiple scripts',
        commonRegions: ['Global'],
        defaultAccentOptions: ['Global clear'],
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
      supportStatus: target.supportStatus,
      baseLanguageCode: profile.baseLanguageCode,
      baseLanguageName: profile.baseLanguageName,
      userRegion: profile.userRegion,
      targetCulture: profile.targetCulture,
      level: _levelLabel(profile.currentLevel),
      focus: _focusFor(profile.learningGoal, target.name),
      goal: profile.learningGoal,
      fluencyScore: _initialFluency(profile.currentLevel),
      confidenceScore: baseline.confidenceScore,
      pronunciationScore: baseline.pronunciationScore,
      weakSounds: _weakSoundsFor(target.code, baseline.firstWeakArea),
      scriptMode: _scriptModeFor(target),
      scriptName: target.scriptName,
      hasRomanization: target.hasRomanization,
      hasTransliteration: target.hasTransliteration,
      supportsTransliteration:
          target.hasTransliteration || target.hasRomanization,
      commonRegions: target.commonRegions,
      defaultAccentOptions: target.defaultAccentOptions,
      accentPreference: profile.accentPreference,
      isActive: true,
    );
  }

  String targetCultureFor(LanguageOption target, String userRegion) {
    switch (target.code) {
      case 'en':
        if (userRegion == 'Japan' ||
            userRegion == 'Germany' ||
            userRegion == 'Brazil' ||
            userRegion == 'India') {
          return 'Global workplace and travel';
        }
        return 'Global English situations';
      case 'ja':
        return 'Japan';
      case 'de':
        return 'Germany and Europe';
      case 'hi':
        return 'India';
      case 'bn':
        return 'Bengali-speaking communities';
      case 'es':
        return userRegion == 'United States'
            ? 'Latin America'
            : 'Spain and Latin America';
      case 'fr':
        return 'France and global Francophone culture';
      case 'ko':
        return 'Korea';
      case 'zh':
        return 'Mandarin-speaking regions';
      case 'ar':
        return 'Middle East';
      case 'pt':
        return 'Brazil and Portugal';
      default:
        return target.commonRegions.isEmpty
            ? 'Global culture'
            : target.commonRegions.first;
    }
  }

  String accentPreferenceFor(LanguageOption target, String userRegion) {
    if (target.defaultAccentOptions.isEmpty) {
      return 'Global clear';
    }
    if (target.code == 'en') {
      switch (userRegion) {
        case 'India':
          return 'Indian English';
        case 'United Kingdom':
          return 'UK English';
        case 'United States':
          return 'US English';
        default:
          return 'Global clear English';
      }
    }
    return target.defaultAccentOptions.first;
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
      case 'es':
        return 'Hola, mi nombre Roy. Quiero hablar Espanol para viajar y conocer personas.';
      case 'fr':
        return 'Bonjour, je suis Roy. Je veux parler francais pour voyager et commander cafe.';
      case 'ko':
        return 'Annyeonghaseyo, Roy imnida. Hanguk-eo baeugo sipeoyo munhwa joahaeyo.';
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
      case 'es':
        return Correction(
          id: 'correction_${mission.id}_${mode.name}_es',
          originalText: transcript,
          correctedText:
              'Hola, mi nombre es Roy. Quiero hablar espanol para viajar y conocer personas.',
          naturalText:
              'Hola, soy Roy. Estoy aprendiendo espanol porque quiero viajar y conocer gente.',
          explanation:
              'Add es after mi nombre and use conocer gente for a more natural ending.',
          focusArea: 'Natural introduction',
          confidenceScore: 62,
          pronunciationScore: 60,
          grammarScore: 59,
          fluencyScore: 61,
          coachNote:
              'Clear message. Repeat with slower vowels and a pause after your name.',
        );
      case 'fr':
        return Correction(
          id: 'correction_${mission.id}_${mode.name}_fr',
          originalText: transcript,
          correctedText:
              'Bonjour, je suis Roy. Je veux parler francais pour voyager et commander un cafe.',
          naturalText:
              'Bonjour, je m appelle Roy. J apprends le francais pour voyager et commander dans un cafe.',
          explanation:
              'Use un cafe for the item, and the natural version sounds more like a real introduction.',
          focusArea: 'French article use',
          confidenceScore: 60,
          pronunciationScore: 58,
          grammarScore: 57,
          fluencyScore: 59,
          coachNote:
              'Good start. Keep the final words soft and do not rush the rhythm.',
        );
      case 'ko':
        return Correction(
          id: 'correction_${mission.id}_${mode.name}_ko',
          originalText: transcript,
          correctedText:
              'Annyeonghaseyo, Roy imnida. Hanguk-eoreul baeugo sipeoyo. Munhwa-reul joahaeyo.',
          naturalText:
              'Annyeonghaseyo, Roy imnida. Hanguk munhwa-reul joahaeseo Hanguk-eoreul baeugo isseoyo.',
          explanation:
              'Use Hanguk-eoreul for Korean language and connect culture as the reason.',
          focusArea: 'Reason sentence',
          confidenceScore: 61,
          pronunciationScore: 59,
          grammarScore: 58,
          fluencyScore: 60,
          coachNote:
              'Nice clear opening. Repeat with a steady pause between the two ideas.',
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
        return _roleplayScenario(mission);
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

  String _roleplayScenario(DailyMission mission) {
    switch (mission.targetLanguageCode) {
      case 'en':
        return mission.category == 'Job interview'
            ? 'Roleplay: job interview in English. The coach is the interviewer.'
            : 'Roleplay: English global workplace meeting. The coach is an international colleague.';
      case 'ja':
        return 'Roleplay: Japanese travel introduction. The coach is someone you meet in Japan.';
      case 'de':
        return 'Roleplay: German train station help. The coach is a station staff member.';
      case 'ko':
        return 'Roleplay: Korean culture conversation. The coach is a new acquaintance at a cultural event.';
      case 'fr':
        return 'Roleplay: French cafe order. The coach is the person at the counter.';
      case 'es':
        return 'Roleplay: Spanish travel help. The coach is a local person helping you.';
      case 'hi':
        return 'Roleplay: Hindi local conversation. The coach is a friendly local speaker.';
      case 'bn':
        return 'Roleplay: Bengali friend conversation. The coach is a new friend.';
      default:
        return '${mission.scenario} The coach will answer like the other person.';
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
      case 'es':
        return ['rolled r', 'vowel clarity', baselineWeakArea];
      case 'fr':
        return ['nasal vowels', 'liaison rhythm', baselineWeakArea];
      case 'ko':
        return ['batchim endings', 'sentence rhythm', baselineWeakArea];
      case 'zh':
        return ['tones', 'initial consonants', baselineWeakArea];
      case 'ar':
        return ['emphatic sounds', 'throat sounds', baselineWeakArea];
      case 'pt':
        return ['nasal vowels', 'word stress', baselineWeakArea];
      case 'en':
      default:
        return ['word endings', 'v/w clarity', baselineWeakArea];
    }
  }

  String _scriptModeFor(LanguageOption target) {
    if (target.hasRomanization && target.hasTransliteration) {
      return '${target.scriptName} + romanization + transliteration';
    }
    if (target.hasRomanization) {
      return '${target.scriptName} + romanization';
    }
    if (target.hasTransliteration) {
      return '${target.scriptName} + transliteration';
    }
    return target.scriptName;
  }
}
