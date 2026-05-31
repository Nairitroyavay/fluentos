import '../models/models.dart';

class FakeMissionEngine {
  const FakeMissionEngine();

  List<PlanDay> generateSevenDayPlan(OnboardingProfile profile) {
    final region = profile.userRegion;
    final base = profile.baseLanguageName;
    final target = profile.targetLanguageName;
    final goal = profile.learningGoal.toLowerCase();
    final confidence = profile.speakingConfidence.toLowerCase();
    final isNervous =
        confidence.contains('shy') || confidence.contains('nervous');
    final minutes = profile.dailyMinutes;

    if (region == 'United States' &&
        profile.baseLanguageCode == 'en' &&
        profile.targetLanguageCode == 'ja') {
      return const [
        PlanDay(
          day: 1,
          title: 'Introduce yourself politely',
          scenario: 'Start a polite first conversation in Japan.',
        ),
        PlanDay(
          day: 2,
          title: 'Talk about your hobbies',
          scenario: 'Share one interest and ask one question.',
        ),
        PlanDay(
          day: 3,
          title: 'Order food in Japanese',
          scenario: 'Ask for one item and say thanks.',
        ),
        PlanDay(
          day: 4,
          title: 'Ask for directions',
          scenario: 'Find a station exit or platform.',
        ),
        PlanDay(
          day: 5,
          title: 'Talk about anime/culture',
          scenario: 'Explain what you like and why.',
        ),
        PlanDay(
          day: 6,
          title: 'Tell a short personal story',
          scenario: 'Use simple past and present ideas.',
        ),
        PlanDay(
          day: 7,
          title: 'Beginner conversation test',
          scenario: 'Repeat corrected answers with confidence.',
        ),
      ];
    }

    if (profile.baseLanguageCode == 'ja' &&
        profile.targetLanguageCode == 'en') {
      return const [
        PlanDay(
          day: 1,
          title: 'Introduce yourself at work',
          scenario: 'Speak to an international colleague.',
        ),
        PlanDay(
          day: 2,
          title: 'Talk about your daily routine',
          scenario: 'Explain your weekday in order.',
        ),
        PlanDay(
          day: 3,
          title: 'Ask a colleague for help',
          scenario: 'Make one clear request.',
        ),
        PlanDay(
          day: 4,
          title: 'Explain a small problem',
          scenario: 'Describe the issue and next step.',
        ),
        PlanDay(
          day: 5,
          title: 'Join a short meeting conversation',
          scenario: 'Give one update and one question.',
        ),
        PlanDay(
          day: 6,
          title: 'Give a 60-second self-introduction',
          scenario: 'Summarize role, work, and goal.',
        ),
        PlanDay(
          day: 7,
          title: 'Global workplace conversation test',
          scenario: 'Handle a short work exchange.',
        ),
      ];
    }

    if (region == 'India' &&
        profile.baseLanguageCode == 'hi' &&
        profile.targetLanguageCode == 'en') {
      return const [
        PlanDay(
          day: 1,
          title: 'Introduce yourself confidently',
          scenario: 'Say your name, background, and goal.',
        ),
        PlanDay(
          day: 2,
          title: 'Explain your daily routine',
          scenario: 'Speak in a clear sequence.',
        ),
        PlanDay(
          day: 3,
          title: 'Talk to a professor/manager',
          scenario: 'Ask for help with respect and clarity.',
        ),
        PlanDay(
          day: 4,
          title: 'Ask for help politely',
          scenario: 'Make one request and explain why.',
        ),
        PlanDay(
          day: 5,
          title: 'Answer a job/college question',
          scenario: 'Give a direct answer without freezing.',
        ),
        PlanDay(
          day: 6,
          title: 'Tell your life story in simple English',
          scenario: 'Use five clear sentences.',
        ),
        PlanDay(
          day: 7,
          title: 'Full confidence speaking test',
          scenario: 'Repeat corrected answers naturally.',
        ),
      ];
    }

    final isJob =
        goal.contains('job') ||
        goal.contains('business') ||
        goal.contains('interview');
    final isCollege = goal.contains('college') || goal.contains('exam');
    final isTravel = goal.contains('travel') || goal.contains('abroad');
    final isCulture =
        goal.contains('anime') ||
        goal.contains('culture') ||
        goal.contains('movies');

    final first = isJob
        ? 'Introduce yourself for work'
        : isTravel
        ? 'Introduce yourself while traveling'
        : isCulture
        ? 'Introduce yourself through culture'
        : 'Introduce yourself clearly';
    final third = isCollege
        ? 'Ask a professor or manager for help'
        : isTravel
        ? 'Ask for directions'
        : 'Order food politely';
    final fifth = isCulture
        ? 'Talk about culture or media'
        : isJob
        ? 'Answer a work question'
        : 'Share one opinion politely';
    final seventh = isNervous
        ? 'Low-pressure conversation test'
        : '$target conversation test';

    return [
      PlanDay(
        day: 1,
        title: first,
        scenario: 'Built for a $base speaker learning $target from $region.',
      ),
      PlanDay(
        day: 2,
        title: 'Talk about your daily routine',
        scenario: 'Speak for ${minutes.clamp(5, 30)} minutes in short turns.',
      ),
      PlanDay(
        day: 3,
        title: third,
        scenario: 'Use a clear request and one reason.',
      ),
      const PlanDay(
        day: 4,
        title: 'Explain a small problem',
        scenario: 'Say what happened and what you need.',
      ),
      PlanDay(
        day: 5,
        title: fifth,
        scenario: 'Sound natural, not translated word by word.',
      ),
      const PlanDay(
        day: 6,
        title: 'Tell a short personal story',
        scenario: 'Use beginning, middle, and next action.',
      ),
      PlanDay(
        day: 7,
        title: seventh,
        scenario: 'Repeat corrected answers with confidence.',
      ),
    ];
  }

  List<DailyMission> generateMissions({
    required OnboardingProfile profile,
    required LanguageProfile language,
  }) {
    final context = _MissionContext(profile: profile, language: language);
    final first = _regionAwareMission(context);
    final missions = language.supportStatus == LanguageSupportStatus.preview
        ? [
            first,
            _introductionMission(context),
            _dailyRoutineMission(context),
            _travelMission(context),
            _foodMission(context),
            _selfStoryMission(context),
          ]
        : [
            first,
            _introductionMission(context),
            _dailyRoutineMission(context),
            _collegeMission(context),
            _jobMission(context),
            _officeMission(context),
            _travelMission(context),
            _shoppingMission(context),
            _foodMission(context),
            _transportMission(context),
            _doctorMission(context),
            _landlordMission(context),
            _friendMission(context),
            _cultureMission(context),
            _businessPitchMission(context),
            _immigrationMission(context),
            _politeDisagreementMission(context),
            _selfStoryMission(context),
          ];

    final deduped = <DailyMission>[];
    for (final mission in missions) {
      if (!deduped.any((item) => item.id == mission.id)) {
        deduped.add(mission);
      }
    }

    return [
      for (var index = 0; index < deduped.length; index++)
        deduped[index]
            .copyWith(isCompleted: false)
            ._withId(
              '${deduped[index].id}_${context.regionSlug}_${context.baseCode}_${context.targetCode}_$index',
            ),
    ];
  }

  DailyMission _regionAwareMission(_MissionContext context) {
    final goal = context.goal;

    if (context.region == 'United States' &&
        context.baseCode == 'en' &&
        context.targetCode == 'ja' &&
        (goal.contains('travel') ||
            goal.contains('culture') ||
            goal.contains('anime'))) {
      return _mission(
        context,
        id: 'mission_us_en_ja_intro',
        title: 'Introduce yourself politely in Japan',
        description:
            'Start a polite first conversation with a clear reason for learning.',
        scenario: 'You are meeting someone at a Japanese language meetup.',
        coachPrompt:
            'Introduce yourself politely and say why you are learning Japanese.',
        successCue: 'Use greeting, name, learning reason, and a polite close.',
        targetPhrases: const [
          'Hajimemashite',
          'nihongo o benkyo shite imasu',
          'yoroshiku onegaishimasu',
        ],
        focusArea: 'Polite introduction',
        category: 'Introduction',
      );
    }

    if (context.region == 'Japan' &&
        context.baseCode == 'ja' &&
        context.targetCode == 'en' &&
        (goal.contains('job') || goal.contains('business'))) {
      return _mission(
        context,
        id: 'mission_jp_ja_en_workplace',
        title: 'Introduce yourself in a global workplace',
        description: 'Explain your role without overcomplicating the sentence.',
        scenario: 'You are speaking to an international colleague in English.',
        coachPrompt:
            'Explain your role and what you are working on in 3 clear sentences.',
        successCue: 'Use role, current work, and one collaboration detail.',
        targetPhrases: const ['I work on', 'my role is', 'right now I am'],
        focusArea: 'Global workplace clarity',
        category: 'Office',
      );
    }

    if (context.region == 'India' &&
        context.baseCode == 'hi' &&
        context.targetCode == 'en' &&
        goal.contains('college')) {
      return _mission(
        context,
        id: 'mission_in_hi_en_extension',
        title: 'Ask your professor for an assignment extension',
        description:
            'Explain a missed deadline politely and ask for more time.',
        scenario: 'You missed a deadline and need to explain politely.',
        coachPrompt: 'Explain your situation and ask for an extension clearly.',
        successCue: 'Use apology, reason, request, and deadline.',
        targetPhrases: const [
          'I am sorry',
          'could I get an extension',
          'I will submit',
        ],
        focusArea: 'Polite academic request',
        category: 'College',
      );
    }

    if (context.region == 'Germany' &&
        context.baseCode == 'de' &&
        context.targetCode == 'en' &&
        goal.contains('business')) {
      return _mission(
        context,
        id: 'mission_de_de_en_pitch',
        title: 'Introduce your startup idea',
        description:
            'Pitch a simple idea with problem, solution, and next step.',
        scenario: 'You are speaking to an international investor.',
        coachPrompt: 'Explain your idea in 60 seconds.',
        successCue: 'Use problem, customer, solution, and traction.',
        targetPhrases: const [
          'the problem is',
          'our solution helps',
          'we are building',
        ],
        focusArea: 'Business pitch',
        category: 'Business pitch',
      );
    }

    if (context.region == 'Brazil' &&
        context.baseCode == 'pt' &&
        context.targetCode == 'en' &&
        goal.contains('travel')) {
      return _mission(
        context,
        id: 'mission_br_pt_en_airport',
        title: 'Ask for help at an airport',
        description: 'Find your gate and explain the problem politely.',
        scenario:
            'You are at an international airport and need help finding your gate.',
        coachPrompt: 'Ask for help politely and explain your problem.',
        successCue: 'Use excuse me, gate, flight, and thank you.',
        targetPhrases: const ['excuse me', 'where is my gate', 'my flight is'],
        focusArea: 'Airport help',
        category: 'Travel',
      );
    }

    if (context.region == 'Korea' &&
        context.baseCode == 'ko' &&
        context.targetCode == 'ja' &&
        (goal.contains('culture') || goal.contains('anime'))) {
      return _mission(
        context,
        id: 'mission_kr_ko_ja_culture',
        title: 'Start a simple Japanese conversation',
        description: 'Open warmly and ask one simple question.',
        scenario: 'You meet a Japanese speaker at a cultural event.',
        coachPrompt:
            'Greet them, introduce yourself, and ask one simple question.',
        successCue: 'Use greeting, name, and one culture question.',
        targetPhrases: const ['konnichiwa', 'watashi wa', 'suki desu ka'],
        focusArea: 'Culture conversation',
        category: 'Culture / anime / media',
      );
    }

    if (context.region == 'France' &&
        context.baseCode == 'fr' &&
        context.targetCode == 'de' &&
        goal.contains('travel')) {
      return _mission(
        context,
        id: 'mission_fr_fr_de_station',
        title: 'Ask for directions at a German train station',
        description: 'Find your platform and confirm the train time.',
        scenario: 'You are at a train station in Germany.',
        coachPrompt: 'Ask where your platform is and confirm the train time.',
        successCue: 'Use platform, time, and thank you.',
        targetPhrases: const ['Wo ist', 'der Bahnsteig', 'um wie viel Uhr'],
        focusArea: 'Train station question',
        category: 'Public transport',
      );
    }

    if (context.region == 'India' &&
        context.baseCode == 'bn' &&
        context.targetCode == 'en' &&
        goal.contains('job')) {
      return _mission(
        context,
        id: 'mission_in_bn_en_interview',
        title: 'Tell me about yourself',
        description:
            'Give a natural interview answer with background and goal.',
        scenario: 'You are in a job interview.',
        coachPrompt:
            'Answer "Tell me about yourself" in a natural and confident way.',
        successCue: 'Use present role, one strength, and career direction.',
        targetPhrases: const [
          'I have experience in',
          'my strength is',
          'I am looking for',
        ],
        focusArea: 'Interview confidence',
        category: 'Job interview',
      );
    }

    return _missionForGoal(context);
  }

  DailyMission _missionForGoal(_MissionContext context) {
    final goal = context.goal;
    if (goal.contains('college') || goal.contains('exam')) {
      return _collegeMission(context);
    }
    if (goal.contains('job') || goal.contains('interview')) {
      return _jobMission(context);
    }
    if (goal.contains('business')) {
      return _businessPitchMission(context);
    }
    if (goal.contains('travel') || goal.contains('abroad')) {
      return _travelMission(context);
    }
    if (goal.contains('friend') || goal.contains('family')) {
      return _friendMission(context);
    }
    if (goal.contains('anime') ||
        goal.contains('culture') ||
        goal.contains('movies')) {
      return _cultureMission(context);
    }
    return _introductionMission(context);
  }

  DailyMission _introductionMission(_MissionContext context) {
    final target = context.targetName;
    return _mission(
      context,
      id: 'mission_intro',
      title: 'Introduce yourself in $target',
      description:
          'Give your name, background, and one reason you are learning.',
      scenario: 'You are meeting someone in a real first conversation.',
      coachPrompt: 'Introduce yourself in three clear sentences.',
      successCue: 'Use name, location or role, and learning purpose.',
      targetPhrases: _phrases(context.targetCode, [
        'my name is',
        'I am learning',
        'nice to meet you',
      ]),
      focusArea: 'Natural self-introduction',
      category: 'Introduction',
    );
  }

  DailyMission _dailyRoutineMission(_MissionContext context) {
    return _mission(
      context,
      id: 'mission_routine',
      title: 'Talk about your daily routine',
      description: 'Describe morning, work or study, and evening in order.',
      scenario:
          'Your coach asks what a normal weekday looks like in ${context.region}.',
      coachPrompt: 'Speak about your daily routine for 45 seconds.',
      successCue: 'Use first, then, and after that.',
      targetPhrases: _phrases(context.targetCode, [
        'first',
        'then',
        'after that',
      ]),
      focusArea: 'Sequence and flow',
      category: 'Daily routine',
    );
  }

  DailyMission _collegeMission(_MissionContext context) {
    return _mission(
      context,
      id: 'mission_college',
      title: 'Ask for academic help',
      description: 'Explain a study problem and ask for help politely.',
      scenario:
          'You are talking to a professor, tutor, or manager after a missed task.',
      coachPrompt:
          'Explain your situation and ask for help in 3 clear sentences.',
      successCue: 'Use reason, request, and next action.',
      targetPhrases: _phrases(context.targetCode, [
        'I need help',
        'could you explain',
        'I will submit',
      ]),
      focusArea: 'Clear academic request',
      category: 'College',
    );
  }

  DailyMission _jobMission(_MissionContext context) {
    return _mission(
      context,
      id: 'mission_job',
      title: 'Answer an interview warm-up',
      description: 'Explain your background and why you fit the role.',
      scenario: 'You are in the first two minutes of a job interview.',
      coachPrompt: 'Tell me about yourself and your current goal.',
      successCue: 'Use a calm opening, one strength, and one goal.',
      targetPhrases: _phrases(context.targetCode, [
        'I have experience',
        'my strength is',
        'I want to grow',
      ]),
      focusArea: 'Work introduction',
      category: 'Job interview',
    );
  }

  DailyMission _officeMission(_MissionContext context) {
    return _mission(
      context,
      id: 'mission_office',
      title: 'Give a quick office update',
      description: 'Say what is done, what is blocked, and what happens next.',
      scenario: 'You are speaking in a global workplace stand-up.',
      coachPrompt: 'Give a calm three-sentence update about your work.',
      successCue: 'Use done, blocked, and next action.',
      targetPhrases: _phrases(context.targetCode, [
        'I finished',
        'I am working on',
        'next I will',
      ]),
      focusArea: 'Work clarity',
      category: 'Office',
    );
  }

  DailyMission _travelMission(_MissionContext context) {
    final title = context.targetCode == 'de'
        ? 'Ask for directions at a German train station'
        : context.targetCode == 'ja'
        ? 'Ask for help while traveling in Japan'
        : 'Ask for help while traveling';

    return _mission(
      context,
      id: 'mission_travel',
      title: title,
      description: 'Ask where to go and confirm the next step.',
      scenario: 'You are traveling and need help finding the right place.',
      coachPrompt: 'Ask for help politely and repeat the answer back.',
      successCue: 'Use a clear question, place, and thanks.',
      targetPhrases: _phrases(context.targetCode, [
        'where is',
        'I need help',
        'thank you',
      ]),
      focusArea: 'Travel question',
      category: 'Travel',
    );
  }

  DailyMission _shoppingMission(_MissionContext context) {
    return _mission(
      context,
      id: 'mission_shopping',
      title: 'Ask the price politely',
      description: 'Ask for the price and confirm whether you want to buy.',
      scenario: 'You are at a small shop and need to ask about an item.',
      coachPrompt: 'Ask the price, clarify one detail, and say thanks.',
      successCue: 'Use one polite question and one clear decision.',
      targetPhrases: _phrases(context.targetCode, [
        'how much',
        'too expensive',
        'thank you',
      ]),
      focusArea: 'Shopping questions',
      category: 'Shopping',
    );
  }

  DailyMission _foodMission(_MissionContext context) {
    return _mission(
      context,
      id: 'mission_food',
      title: 'Order food politely',
      description: 'Ask for an item, confirm price, and say thanks.',
      scenario: 'You are ordering food in a cafe or small restaurant.',
      coachPrompt: 'Order one item and ask one follow-up question.',
      successCue: 'Sound polite, not robotic.',
      targetPhrases: _phrases(context.targetCode, [
        'I would like',
        'how much',
        'please',
      ]),
      focusArea: 'Polite requests',
      category: 'Food ordering',
    );
  }

  DailyMission _transportMission(_MissionContext context) {
    return _mission(
      context,
      id: 'mission_transport',
      title: 'Ask for the right bus or train',
      description: 'Confirm route, stop, and timing.',
      scenario: 'You are asking someone which public transport to take.',
      coachPrompt: 'Ask for the route and repeat the answer back.',
      successCue: 'Ask one question and confirm one detail.',
      targetPhrases: _phrases(context.targetCode, [
        'which bus',
        'how long',
        'this stop',
      ]),
      focusArea: 'Clarifying questions',
      category: 'Public transport',
    );
  }

  DailyMission _doctorMission(_MissionContext context) {
    return _mission(
      context,
      id: 'mission_doctor',
      title: 'Explain a simple health problem',
      description: 'Say what hurts, when it started, and what you need.',
      scenario: 'You are speaking to a doctor at a clinic.',
      coachPrompt: 'Explain your problem in three clear sentences.',
      successCue: 'Use body part, time, and request.',
      targetPhrases: _phrases(context.targetCode, [
        'I have pain',
        'since yesterday',
        'what should I do',
      ]),
      focusArea: 'Clear symptoms',
      category: 'Doctor visit',
    );
  }

  DailyMission _landlordMission(_MissionContext context) {
    return _mission(
      context,
      id: 'mission_landlord',
      title: 'Report a room problem',
      description: 'Explain the issue and ask when it can be fixed.',
      scenario: 'You are talking to your landlord or roommate about a repair.',
      coachPrompt: 'Explain the problem and ask for a clear next step.',
      successCue: 'Be direct, polite, and specific.',
      targetPhrases: _phrases(context.targetCode, [
        'there is a problem',
        'can you fix it',
        'when is possible',
      ]),
      focusArea: 'Polite request',
      category: 'Landlord / roommate',
    );
  }

  DailyMission _friendMission(_MissionContext context) {
    return _mission(
      context,
      id: 'mission_friend',
      title: 'Start a friendly conversation',
      description: 'Greet someone and ask about their day.',
      scenario: 'You are meeting a new friend after class, work, or travel.',
      coachPrompt: 'Start the conversation and ask one natural question.',
      successCue: 'Keep it warm and simple.',
      targetPhrases: _phrases(context.targetCode, [
        'how are you',
        'nice to meet you',
        'today',
      ]),
      focusArea: 'Warm openings',
      category: 'Friend conversation',
    );
  }

  DailyMission _cultureMission(_MissionContext context) {
    return _mission(
      context,
      id: 'mission_culture',
      title: 'Talk about culture, anime, or media',
      description: 'Explain what you like and why.',
      scenario:
          'A friend asks what you enjoy watching, reading, or listening to.',
      coachPrompt:
          'Tell me about one piece of culture you like and ask one question.',
      successCue: 'Use because and one feeling word.',
      targetPhrases: _phrases(context.targetCode, [
        'I like',
        'because',
        'what do you like',
      ]),
      focusArea: 'Personal opinion',
      category: 'Culture / anime / media',
    );
  }

  DailyMission _businessPitchMission(_MissionContext context) {
    return _mission(
      context,
      id: 'mission_business_pitch',
      title: 'Pitch an idea in 60 seconds',
      description: 'Explain a problem, solution, and next step.',
      scenario:
          'You are speaking to an international classmate, teammate, or investor.',
      coachPrompt: 'Explain your idea in 60 seconds with a clear structure.',
      successCue: 'Use problem, solution, and next step.',
      targetPhrases: _phrases(context.targetCode, [
        'the problem is',
        'my idea is',
        'the next step is',
      ]),
      focusArea: 'Business pitch',
      category: 'Business pitch',
    );
  }

  DailyMission _immigrationMission(_MissionContext context) {
    return _mission(
      context,
      id: 'mission_moving_abroad',
      title: 'Explain why you are moving abroad',
      description: 'Share your reason, plan, and one concern.',
      scenario:
          'You are talking to an immigration officer, advisor, or new neighbor.',
      coachPrompt: 'Explain why you are moving and what you plan to do next.',
      successCue: 'Use reason, timeline, and one clear plan.',
      targetPhrases: _phrases(context.targetCode, [
        'I am moving because',
        'my plan is',
        'I will stay',
      ]),
      focusArea: 'Moving abroad',
      category: 'Immigration / moving abroad',
    );
  }

  DailyMission _politeDisagreementMission(_MissionContext context) {
    return _mission(
      context,
      id: 'mission_disagreement',
      title: 'Disagree without sounding rude',
      description: 'Say your view, explain why, and keep the tone calm.',
      scenario:
          'A classmate or colleague suggests something you do not agree with.',
      coachPrompt: 'Disagree politely and give one reason.',
      successCue: 'Use a soft opening before your opinion.',
      targetPhrases: _phrases(context.targetCode, [
        'I understand',
        'I think',
        'maybe we can',
      ]),
      focusArea: 'Polite disagreement',
      category: 'Polite disagreement',
    );
  }

  DailyMission _selfStoryMission(_MissionContext context) {
    return _mission(
      context,
      id: 'mission_story',
      title: 'Tell a short story about yourself',
      description: 'Share one real moment with beginning, middle, and end.',
      scenario: 'Your coach asks for a simple personal story.',
      coachPrompt: 'Tell a short story in 5 sentences.',
      successCue: 'Do not rush. Make the timeline clear.',
      targetPhrases: _phrases(context.targetCode, [
        'one day',
        'after that',
        'finally',
      ]),
      focusArea: 'Story flow',
      category: 'Self-story',
    );
  }

  DailyMission _mission(
    _MissionContext context, {
    required String id,
    required String title,
    required String description,
    required String scenario,
    required String coachPrompt,
    required String successCue,
    required List<String> targetPhrases,
    required String focusArea,
    required String category,
  }) {
    final prefix =
        context.language.supportStatus == LanguageSupportStatus.preview
        ? 'Preview track: '
        : '';

    return DailyMission(
      id: id,
      region: context.region,
      baseLanguageCode: context.baseCode,
      targetLanguageCode: context.targetCode,
      languageCode: context.targetCode,
      title: '$prefix$title',
      description: description,
      scenario: scenario,
      coachPrompt: coachPrompt,
      successCue: successCue,
      targetPhrases: targetPhrases,
      estimatedMinutes: context.profile.dailyMinutes.clamp(5, 30),
      difficulty: _difficultyFor(context.profile.currentLevel),
      focusArea: focusArea,
      category: category,
    );
  }

  List<String> _phrases(String code, List<String> english) {
    switch (code) {
      case 'hi':
        return const ['kripya', 'mujhe madad chahiye', 'dhanyavaad'];
      case 'bn':
        return const ['doya kore', 'amar sahajyo dorkar', 'dhonnobad'];
      case 'ja':
        return const ['sumimasen', 'onegaishimasu', 'arigato'];
      case 'de':
        return const ['bitte', 'wo ist', 'danke'];
      case 'es':
        return const ['por favor', 'necesito ayuda', 'gracias'];
      case 'fr':
        return const ['s il vous plait', 'j ai besoin d aide', 'merci'];
      case 'ko':
        return const ['annyeonghaseyo', 'dowajuseyo', 'gamsahamnida'];
      case 'zh':
        return const ['qing', 'wo xuyao bangzhu', 'xiexie'];
      case 'ar':
        return const ['min fadlik', 'ahtaj musaada', 'shukran'];
      case 'pt':
        return const ['por favor', 'preciso de ajuda', 'obrigado'];
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

class _MissionContext {
  final OnboardingProfile profile;
  final LanguageProfile language;

  const _MissionContext({required this.profile, required this.language});

  String get region => profile.userRegion;
  String get regionSlug => region.toLowerCase().replaceAll(' ', '_');
  String get baseCode => profile.baseLanguageCode;
  String get targetCode => profile.targetLanguageCode;
  String get targetName => profile.targetLanguageName;
  String get goal => profile.learningGoal.toLowerCase();
}

extension on DailyMission {
  DailyMission _withId(String nextId) {
    return DailyMission(
      id: nextId,
      region: region,
      baseLanguageCode: baseLanguageCode,
      targetLanguageCode: targetLanguageCode,
      languageCode: languageCode,
      title: title,
      description: description,
      scenario: scenario,
      coachPrompt: coachPrompt,
      successCue: successCue,
      targetPhrases: targetPhrases,
      estimatedMinutes: estimatedMinutes,
      difficulty: difficulty,
      focusArea: focusArea,
      category: category,
      isCompleted: isCompleted,
    );
  }
}
