# Cloudflare API Contracts

Do not implement these calls yet. Future app requests must include an auth token. The Cloudflare Worker must verify auth/App Check later. The client must never call an AI vendor directly.

FluentOS is global-first. API payloads must keep `region`, `baseLanguageCode`, and `targetLanguageCode` separate so missions, corrections, review, pricing, and quotas can localize later.

## `POST /v1/speak/transcribe`

Purpose: upload or reference short audio and receive a transcript.

Audio is processed for the request and must not be stored by default.

Request:

```json
{
  "userId": "user_123",
  "languageProfileId": "lang_123",
  "targetLanguageCode": "en",
  "baseLanguageCode": "hi",
  "sessionId": "session_123",
  "audioFormat": "m4a",
  "audioDurationSeconds": 28,
  "clientTraceId": "client_trace_123"
}
```

Response:

```json
{
  "transcriptText": "Hello, my name is Roy.",
  "transcriptConfidence": 0.91,
  "languageDetected": "en",
  "confidenceLow": false,
  "provider": "provider_alias",
  "requestId": "req_123"
}
```

## `POST /v1/speak/correct`

Purpose: correct transcript and generate a natural version.

Request:

```json
{
  "userId": "user_123",
  "languageProfileId": "lang_123",
  "missionId": "mission_123",
  "sessionId": "session_123",
  "mode": "dailyMission",
  "region": "India",
  "baseLanguageCode": "hi",
  "targetLanguageCode": "en",
  "learningGoal": "College",
  "currentLevel": "I know some words",
  "transcriptText": "Hello, my name Roy.",
  "transcriptConfidence": 0.91,
  "userWeakAreas": ["word endings"],
  "correctionStrictness": "balanced"
}
```

Response:

```json
{
  "correctionId": "correction_123",
  "correctedText": "Hello, my name is Roy.",
  "naturalText": "Hi, I am Roy.",
  "explanation": "Add 'is' after 'my name'.",
  "focusArea": "Basic sentence structure",
  "coachNote": "Repeat slowly and finish the last word.",
  "scores": {
    "confidence": 64,
    "pronunciation": 68,
    "grammar": 63,
    "fluency": 65,
    "vocabulary": 58,
    "responseSpeed": 55
  },
  "modelConfidence": 0.86,
  "reviewItemSuggestion": true,
  "requestId": "req_124"
}
```

## `POST /v1/missions/generate`

Purpose: generate daily mission or 7-day plan.

Request fields: `userId`, `userRegion`, `baseLanguageCode`, `targetLanguageCode`, `learningGoal`, `currentLevel`, `speakingConfidence`, `dailyMinutes`, `activeLanguageProfileId`.

Response fields: `missions[]`, `sevenDayPlan[]`, `requestId`.

## `GET /v1/quota/status`

Purpose: check AI usage limits.

Response fields: `tier`, `dailyAiSecondsLimit`, `usedAiSecondsToday`, `monthlyAiSecondsLimit`, `usedAiSecondsThisMonth`, `canStartSession`, `reasonIfBlocked`.

## `POST /v1/quota/record`

Purpose: record AI usage after a session.

Request fields: `userId`, `sessionId`, `secondsUsed`, `provider`, `model`, `requestId`.

Response fields: `updatedQuota`, `success`.

## `POST /v1/feedback/report-correction`

Purpose: let user report a wrong correction.

Request fields: `userId`, `sessionId`, `correctionId`, `reason`, `optionalText`.

Response fields: `success`, `feedbackId`.

## API rules

- Backend starts with Firebase Auth + Firestore. Cloudflare AI APIs come later.
- Cloudflare validates auth/App Check before AI or quota operations.
- Worker enforces quota server-side before vendor calls.
- Worker stores trusted usage records after vendor calls.
- Client-generated scores, tiers, entitlements, and usage seconds are never authoritative.
- Responses must include `requestId` for debugging and support.
- No map, social, dating, chat, nearby-user, voice-room, or meetup endpoint is in MVP.
- Payment APIs come after quota and AI usage behavior are understood.
