import '../../models/models.dart';

abstract class SpeakRepository {
  Future<SpeakSession> createSession(DailyMission mission, SpeakMode mode);
  Future<TranscriptResult> transcribeMockOrRemote(SpeakSession session);
  Future<Correction> correctTranscript(CorrectionRequest request);
  Future<void> saveSession(String userId, SpeakSession session);
}
