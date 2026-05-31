# Events And Analytics Contract

Do not add Firebase Analytics yet.

## Event names

- `onboarding_started`
- `region_selected`
- `base_language_selected`
- `target_language_selected`
- `onboarding_completed`
- `mission_started`
- `speak_recording_started`
- `transcript_received`
- `correction_received`
- `repeat_attempt_started`
- `session_completed`
- `review_item_created`
- `review_item_mastered`
- `premium_preview_opened`
- `second_language_blocked`
- `quota_blocked`
- `correction_reported`

## Common payload

- `userId`
- `languageProfileId`
- `region`
- `baseLanguageCode`
- `targetLanguageCode`
- `missionId`
- `sessionId`
- `tier`
- `backendMode`
- `clientTraceId`

## Rules

- Events are product analytics only, not source of truth.
- Do not send raw audio.
- Do not send transcript text unless consent and policy allow it.
- Never use analytics to enforce quota or entitlement.
