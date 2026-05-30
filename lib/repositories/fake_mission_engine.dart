import '../models/models.dart';

class FakeMissionEngine {
  const FakeMissionEngine();

  List<PlanDay> generateSevenDayPlan(OnboardingProfile profile) {
    final target = profile.targetLanguageName;
    final goal = profile.learningGoal.toLowerCase();
    final isJob = goal.contains('job') || goal.contains('business');
    final isCollege = goal.contains('college') || goal.contains('exam');
    final isTravel = goal.contains('travel') || goal.contains('abroad');

    final secondDay = isJob
        ? 'Explain your work routine'
        : isCollege
        ? 'Talk about your class routine'
        : 'Talk about your daily routine';
    final thirdDay = isTravel
        ? 'Ask for directions'
        : isCollege
        ? 'Explain why you missed class'
        : 'Order food confidently';
    final fourthDay = isJob
        ? 'Answer an interview warm-up'
        : isTravel
        ? 'Ask for help at a station'
        : 'Ask for help politely';

    return [
      PlanDay(
        day: 1,
        title: 'Introduce yourself',
        scenario: 'Start a clear first conversation in $target.',
      ),
      PlanDay(day: 2, title: secondDay, scenario: 'Speak for 45 seconds.'),
      PlanDay(day: 3, title: thirdDay, scenario: 'Use three clear sentences.'),
      PlanDay(day: 4, title: fourthDay, scenario: 'Ask once, then clarify.'),
      const PlanDay(
        day: 5,
        title: 'Talk about hobbies',
        scenario: 'Make the answer sound natural.',
      ),
      const PlanDay(
        day: 6,
        title: 'Tell a short story',
        scenario: 'Use past, present, and next action.',
      ),
      PlanDay(
        day: 7,
        title: '${profile.currentLevel} conversation test',
        scenario: 'Repeat corrected answers with confidence.',
      ),
    ];
  }

  List<DailyMission> generateMissions({
    required OnboardingProfile profile,
    required LanguageProfile language,
  }) {
    final goal = profile.learningGoal.toLowerCase();
    final target = language.name;

    final preferred = _missionForGoal(goal, language);
    final missions = <DailyMission>[
      preferred,
      _introductionMission(language),
      _dailyRoutineMission(language),
      _officeMission(language),
      _foodMission(language),
      _shoppingMission(language),
      _transportMission(language),
      _doctorMission(language),
      _landlordMission(language),
      _friendMission(language),
      _politeDisagreementMission(language),
      _selfStoryMission(language),
    ];

    final deduped = <DailyMission>[];
    for (final mission in missions) {
      if (!deduped.any((item) => item.id == mission.id)) {
        deduped.add(mission);
      }
    }

    return [
      for (var index = 0; index < deduped.length; index++)
        DailyMission(
          id: '${deduped[index].id}_${language.code}_$index',
          languageCode: language.code,
          title: deduped[index].title,
          description: deduped[index].description,
          scenario: deduped[index].scenario,
          coachPrompt: deduped[index].coachPrompt,
          successCue: deduped[index].successCue,
          targetPhrases: deduped[index].targetPhrases,
          estimatedMinutes: profile.dailyMinutes.clamp(5, 30),
          difficulty: _difficultyFor(profile.currentLevel),
          focusArea: deduped[index].focusArea,
          category: deduped[index].category,
        ),
    ]..sort((a, b) {
      if (a.title.contains(target)) {
        return -1;
      }
      return 0;
    });
  }

  DailyMission _missionForGoal(String goal, LanguageProfile language) {
    if (goal.contains('college') || goal.contains('exam')) {
      return _collegeMission(language);
    }
    if (goal.contains('job') || goal.contains('business')) {
      return _jobMission(language);
    }
    if (goal.contains('travel') || goal.contains('abroad')) {
      return _travelMission(language);
    }
    if (goal.contains('friend') || goal.contains('family')) {
      return _friendMission(language);
    }
    if (goal.contains('anime') || goal.contains('culture')) {
      return _cultureMission(language);
    }
    return _introductionMission(language);
  }

  DailyMission _introductionMission(LanguageProfile language) {
    switch (language.code) {
      case 'ja':
        return DailyMission(
          id: 'mission_intro_polite',
          languageCode: language.code,
          title: 'Introduce yourself politely',
          description: 'Give your name, role, and one reason you are learning.',
          scenario: 'You are meeting a senior at work.',
          coachPrompt: 'Please introduce yourself politely.',
          successCue: 'Say your name, purpose, and one polite closing.',
          targetPhrases: const ['Hajimemashite', 'yoroshiku', 'benkyo'],
          estimatedMinutes: 10,
          difficulty: 'Starter',
          focusArea: 'Polite introduction',
          category: 'Introduction',
        );
      case 'de':
        return DailyMission(
          id: 'mission_intro_de',
          languageCode: language.code,
          title: 'Introduce yourself in a practice session',
          description: 'Say who you are and why you are learning German.',
          scenario: 'You are joining a small German class practice session.',
          coachPrompt: 'Introduce yourself in three clear sentences.',
          successCue: 'Use name, city, and learning purpose.',
          targetPhrases: const ['Ich heisse', 'ich lerne', 'freut mich'],
          estimatedMinutes: 10,
          difficulty: 'Starter',
          focusArea: 'Sentence order',
          category: 'Introduction',
        );
      case 'hi':
        return DailyMission(
          id: 'mission_intro_hi',
          languageCode: language.code,
          title: 'Start a simple Hindi introduction',
          description: 'Introduce yourself without translating word by word.',
          scenario: 'You are meeting a Hindi-speaking colleague.',
          coachPrompt: 'Tell me your name and what you do.',
          successCue: 'Keep the sentence short and natural.',
          targetPhrases: const [
            'mera naam',
            'main seekh raha hoon',
            'dhanyavaad',
          ],
          estimatedMinutes: 10,
          difficulty: 'Starter',
          focusArea: 'Natural self-introduction',
          category: 'Introduction',
        );
      case 'bn':
        return DailyMission(
          id: 'mission_intro_bn',
          languageCode: language.code,
          title: 'Start a simple friendly conversation',
          description: 'Say hello, introduce yourself, and ask one question.',
          scenario:
              'You are meeting a Bengali-speaking friend for the first time.',
          coachPrompt: 'Start the conversation in a warm, simple way.',
          successCue: 'Use greeting, name, and one follow-up question.',
          targetPhrases: const ['nomoskar', 'amar naam', 'kemon acho'],
          estimatedMinutes: 10,
          difficulty: 'Starter',
          focusArea: 'Friendly opening',
          category: 'Friend conversation',
        );
      case 'en':
      default:
        return DailyMission(
          id: 'mission_intro_en',
          languageCode: language.code,
          title: 'Introduce yourself with confidence',
          description: 'Say your name, background, and one goal clearly.',
          scenario: 'You are meeting a new classmate after orientation.',
          coachPrompt: 'Introduce yourself in three clear sentences.',
          successCue: 'Speak slowly and end with one confident goal.',
          targetPhrases: const ['my name is', 'I am learning', 'I want to'],
          estimatedMinutes: 10,
          difficulty: 'Starter',
          focusArea: 'Speaking confidence',
          category: 'Introduction',
        );
    }
  }

  DailyMission _collegeMission(LanguageProfile language) {
    return DailyMission(
      id: 'mission_college',
      languageCode: language.code,
      title: 'Explain why you missed class',
      description: 'Give a polite reason and say what you will do next.',
      scenario: 'You are talking to your professor after class.',
      coachPrompt:
          'Tell me why you missed yesterday\'s class in 3 clear sentences.',
      successCue: 'Use reason, apology, and next action.',
      targetPhrases: _phrases(language.code, [
        'I missed class',
        'I am sorry',
        'I will submit',
      ]),
      estimatedMinutes: 10,
      difficulty: 'Starter',
      focusArea: 'Clear explanation',
      category: 'College',
    );
  }

  DailyMission _jobMission(LanguageProfile language) {
    return DailyMission(
      id: 'mission_job',
      languageCode: language.code,
      title: 'Answer an interview warm-up',
      description: 'Explain your background and why you fit the role.',
      scenario: 'You are in the first two minutes of a job interview.',
      coachPrompt: 'Tell me about yourself and your current goal.',
      successCue: 'Use a calm opening, one strength, and one goal.',
      targetPhrases: _phrases(language.code, [
        'I have experience',
        'my strength is',
        'I want to grow',
      ]),
      estimatedMinutes: 10,
      difficulty: 'Starter',
      focusArea: 'Work introduction',
      category: 'Job interview',
    );
  }

  DailyMission _officeMission(LanguageProfile language) {
    return DailyMission(
      id: 'mission_office',
      languageCode: language.code,
      title: 'Give a quick office update',
      description: 'Say what is done, what is blocked, and what happens next.',
      scenario: 'Your manager asks for a short update in a stand-up meeting.',
      coachPrompt: 'Give a calm three-sentence update about your work.',
      successCue: 'Use done, blocked, and next action.',
      targetPhrases: _phrases(language.code, [
        'I finished',
        'I am working on',
        'next I will',
      ]),
      estimatedMinutes: 10,
      difficulty: 'Starter',
      focusArea: 'Work clarity',
      category: 'Office',
    );
  }

  DailyMission _travelMission(LanguageProfile language) {
    if (language.code == 'de') {
      return DailyMission(
        id: 'mission_station_de',
        languageCode: language.code,
        title: 'Ask for directions at a station',
        description: 'Find your platform and confirm where to go.',
        scenario:
            'You are at a train station and need help finding your platform.',
        coachPrompt: 'Ask for the platform and repeat the direction back.',
        successCue: 'Use question, place, and thanks.',
        targetPhrases: const ['Wo ist', 'der Bahnsteig', 'danke'],
        estimatedMinutes: 10,
        difficulty: 'Starter',
        focusArea: 'Travel question',
        category: 'Travel',
      );
    }

    return DailyMission(
      id: 'mission_travel',
      languageCode: language.code,
      title: 'Ask for directions at a station',
      description: 'Ask where to go and confirm the next step.',
      scenario: 'You are at a station and need help finding your platform.',
      coachPrompt: 'Ask for help and repeat the answer politely.',
      successCue: 'Use a clear question and one confirmation.',
      targetPhrases: _phrases(language.code, [
        'where is',
        'platform',
        'thank you',
      ]),
      estimatedMinutes: 10,
      difficulty: 'Starter',
      focusArea: 'Public transport',
      category: 'Public transport',
    );
  }

  DailyMission _dailyRoutineMission(LanguageProfile language) {
    return DailyMission(
      id: 'mission_routine',
      languageCode: language.code,
      title: 'Talk about your daily routine',
      description: 'Describe morning, work/study, and evening in order.',
      scenario: 'Your coach asks what a normal weekday looks like.',
      coachPrompt: 'Speak for 45 seconds about your daily routine.',
      successCue: 'Use first, then, and after that.',
      targetPhrases: _phrases(language.code, ['first', 'then', 'after that']),
      estimatedMinutes: 10,
      difficulty: 'Starter',
      focusArea: 'Sequence and flow',
      category: 'Daily routine',
    );
  }

  DailyMission _foodMission(LanguageProfile language) {
    return DailyMission(
      id: 'mission_food',
      languageCode: language.code,
      title: 'Order food politely',
      description: 'Ask for an item, confirm price, and say thanks.',
      scenario: 'You are ordering food from a small counter.',
      coachPrompt: 'Order one item and ask one follow-up question.',
      successCue: 'Sound polite, not robotic.',
      targetPhrases: _phrases(language.code, [
        'I would like',
        'how much',
        'please',
      ]),
      estimatedMinutes: 10,
      difficulty: 'Starter',
      focusArea: 'Polite requests',
      category: 'Food ordering',
    );
  }

  DailyMission _shoppingMission(LanguageProfile language) {
    if (language.code == 'hi') {
      return DailyMission(
        id: 'mission_shopping_hi',
        languageCode: language.code,
        title: 'Ask price and bargain politely',
        description:
            'Ask the price, react politely, and request a small discount.',
        scenario: 'You are buying something from a local shopkeeper.',
        coachPrompt: 'Ask the price and bargain politely in three short lines.',
        successCue: 'Keep your tone respectful and clear.',
        targetPhrases: const ['kitna hai', 'thoda kam', 'dhanyavaad'],
        estimatedMinutes: 10,
        difficulty: 'Starter',
        focusArea: 'Polite bargaining',
        category: 'Shopping',
      );
    }

    return DailyMission(
      id: 'mission_shopping',
      languageCode: language.code,
      title: 'Ask the price politely',
      description: 'Ask for the price and confirm whether you want to buy.',
      scenario: 'You are at a small shop and need to ask about an item.',
      coachPrompt: 'Ask the price, clarify one detail, and say thanks.',
      successCue: 'Use one polite question and one clear decision.',
      targetPhrases: _phrases(language.code, [
        'how much',
        'too expensive',
        'thank you',
      ]),
      estimatedMinutes: 10,
      difficulty: 'Starter',
      focusArea: 'Shopping questions',
      category: 'Shopping',
    );
  }

  DailyMission _transportMission(LanguageProfile language) {
    return DailyMission(
      id: 'mission_transport',
      languageCode: language.code,
      title: 'Ask for the right bus or train',
      description: 'Confirm route, stop, and timing.',
      scenario: 'You are asking someone which public transport to take.',
      coachPrompt: 'Ask for the route and repeat the answer back.',
      successCue: 'Ask one question and confirm one detail.',
      targetPhrases: _phrases(language.code, [
        'which bus',
        'how long',
        'this stop',
      ]),
      estimatedMinutes: 10,
      difficulty: 'Starter',
      focusArea: 'Clarifying questions',
      category: 'Public transport',
    );
  }

  DailyMission _doctorMission(LanguageProfile language) {
    return DailyMission(
      id: 'mission_doctor',
      languageCode: language.code,
      title: 'Explain a simple health problem',
      description: 'Say what hurts, when it started, and what you need.',
      scenario: 'You are speaking to a doctor at a clinic.',
      coachPrompt: 'Explain your problem in three clear sentences.',
      successCue: 'Use body part, time, and request.',
      targetPhrases: _phrases(language.code, [
        'I have pain',
        'since yesterday',
        'what should I do',
      ]),
      estimatedMinutes: 10,
      difficulty: 'Starter',
      focusArea: 'Clear symptoms',
      category: 'Doctor visit',
    );
  }

  DailyMission _landlordMission(LanguageProfile language) {
    return DailyMission(
      id: 'mission_landlord',
      languageCode: language.code,
      title: 'Report a room problem',
      description: 'Explain the issue and ask when it can be fixed.',
      scenario: 'You are talking to your landlord or roommate about a repair.',
      coachPrompt: 'Explain the problem and ask for a clear next step.',
      successCue: 'Be direct, polite, and specific.',
      targetPhrases: _phrases(language.code, [
        'there is a problem',
        'can you fix it',
        'when is possible',
      ]),
      estimatedMinutes: 10,
      difficulty: 'Starter',
      focusArea: 'Polite request',
      category: 'Landlord / roommate',
    );
  }

  DailyMission _friendMission(LanguageProfile language) {
    return DailyMission(
      id: 'mission_friend',
      languageCode: language.code,
      title: 'Start a friendly conversation',
      description: 'Greet someone and ask about their day.',
      scenario: 'You are meeting a new friend after class.',
      coachPrompt: 'Start the conversation and ask one natural question.',
      successCue: 'Keep it warm and simple.',
      targetPhrases: _phrases(language.code, [
        'how are you',
        'nice to meet you',
        'today',
      ]),
      estimatedMinutes: 10,
      difficulty: 'Starter',
      focusArea: 'Warm openings',
      category: 'Friend conversation',
    );
  }

  DailyMission _cultureMission(LanguageProfile language) {
    return DailyMission(
      id: 'mission_culture',
      languageCode: language.code,
      title: 'Talk about a show or song you like',
      description: 'Explain what you like and why.',
      scenario: 'A friend asks what you enjoy watching or listening to.',
      coachPrompt: 'Tell me about one piece of culture you like.',
      successCue: 'Use because and one feeling word.',
      targetPhrases: _phrases(language.code, ['I like', 'because', 'it feels']),
      estimatedMinutes: 10,
      difficulty: 'Starter',
      focusArea: 'Personal opinion',
      category: 'Self-story',
    );
  }

  DailyMission _politeDisagreementMission(LanguageProfile language) {
    return DailyMission(
      id: 'mission_disagreement',
      languageCode: language.code,
      title: 'Disagree without sounding rude',
      description: 'Say your view, explain why, and keep the tone calm.',
      scenario:
          'A classmate or colleague suggests something you do not agree with.',
      coachPrompt: 'Disagree politely and give one reason.',
      successCue: 'Use a soft opening before your opinion.',
      targetPhrases: _phrases(language.code, [
        'I understand',
        'I think',
        'maybe we can',
      ]),
      estimatedMinutes: 10,
      difficulty: 'Starter',
      focusArea: 'Polite disagreement',
      category: 'Polite disagreement',
    );
  }

  DailyMission _selfStoryMission(LanguageProfile language) {
    return DailyMission(
      id: 'mission_story',
      languageCode: language.code,
      title: 'Tell a short story about yourself',
      description: 'Share one real moment with beginning, middle, and end.',
      scenario: 'Your coach asks for a simple personal story.',
      coachPrompt: 'Tell a short story in 5 sentences.',
      successCue: 'Do not rush. Make the timeline clear.',
      targetPhrases: _phrases(language.code, [
        'one day',
        'after that',
        'finally',
      ]),
      estimatedMinutes: 10,
      difficulty: 'Starter',
      focusArea: 'Story flow',
      category: 'Self-story',
    );
  }

  List<String> _phrases(String code, List<String> english) {
    switch (code) {
      case 'hi':
        return const ['kripya', 'kitna hai', 'dhanyavaad'];
      case 'bn':
        return const ['doya kore', 'koto daam', 'dhonnobad'];
      case 'ja':
        return const ['sumimasen', 'onegaishimasu', 'arigato'];
      case 'de':
        return const ['bitte', 'wie viel', 'danke'];
      case 'en':
      default:
        return english;
    }
  }

  String _difficultyFor(String level) {
    if (level.toLowerCase().contains('advanced')) {
      return 'Advanced';
    }
    if (level.toLowerCase().contains('intermediate')) {
      return 'Intermediate';
    }
    if (level.toLowerCase().contains('broken')) {
      return 'A2';
    }
    return 'Starter';
  }
}
