// ignore_for_file: prefer_initializing_formals

import '../../models/models.dart';
import '../../repositories/fake_mission_engine.dart';

class MissionEngine {
  final FakeMissionEngine _fakeEngine;

  const MissionEngine({
    FakeMissionEngine fakeEngine = const FakeMissionEngine(),
  }) : _fakeEngine = fakeEngine;

  List<PlanDay> generateSevenDayPlan(OnboardingProfile profile) {
    return _fakeEngine.generateSevenDayPlan(profile);
  }

  List<DailyMission> generateMissions({
    required OnboardingProfile profile,
    required LanguageProfile language,
  }) {
    return _fakeEngine.generateMissions(profile: profile, language: language);
  }
}
