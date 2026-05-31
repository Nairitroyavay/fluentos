# Backend Readiness

FluentOS is a global speaking-first language app. The current build is still a mock/local Flutter frontend that demonstrates the product loop: onboarding, one active language, daily missions, mock speaking, correction, repetition, review, progress, profile, and premium preview.

## Current frontend status

- Flutter app with Riverpod, GoRouter, SharedPreferences, fake auth, full onboarding, Today, Speak, Review, Progress, Profile, and premium preview.
- Local persistence stores demo auth state, onboarding, user profile, missions, review items, progress, settings, quota, and entitlement placeholders.
- Repository contracts now exist under `lib/data/contracts`.
- Fake implementations now exist under `lib/data/fake`.
- Backend mode is `mockLocal` in `lib/core/config/app_environment.dart`.

## Mock/local today

- Authentication is fake and local.
- AI speech, transcription, correction, review creation, mission generation, quota, and entitlement are mocked.
- No audio is captured or stored.
- SharedPreferences is the only persistence layer.

## Future Firebase

- Firebase Auth: real user identity.
- Firestore: user profile, language profiles, missions, sessions, review items, progress snapshots, private settings, usage, subscriptions, templates, config, and feedback.
- Firebase App Check: client integrity signal for Cloudflare and Firebase access.
- Firebase Storage only if explicit future audio consent is added.

## Future Cloudflare

- Cloudflare Workers will be the only client-facing API for AI calls.
- Workers will verify auth/App Check, enforce quota, call AI providers, normalize responses, and record trusted usage.
- The client must not call AI vendors directly.

## Future AI provider

- First backend version uses a chained flow: STT, correction/scenario engine, optional TTS.
- Provider choice stays behind Cloudflare.
- Candidate providers: OpenAI or Google Speech for global STT, Azure Speech for pronunciation assessment, Sarvam for Indian language STT/TTS, OpenAI/Azure/Google for global TTS.

## Future payment provider

- Payment SDK is not connected yet.
- Subscription entitlement will later be synced from the payment provider through backend-controlled records.
- Pricing will be localized by region later.

## Must stay client-side

- UI state, navigation, selected tabs, temporary speak-session phase, local display preferences, and offline mock/demo behavior.
- Client may cache backend data, but backend remains authoritative for identity, entitlement, quota, and AI usage.

## Must never be trusted from client

- AI usage seconds.
- Subscription tier or premium entitlement.
- Quota bypass decisions.
- Fluency/scoring records that unlock paid or trusted features.
- Provider request costs.
- Any future moderation or safety decision.

## Backend start checklist

- App runs locally.
- `flutter analyze` passes.
- `flutter test` passes.
- Debug APK builds.
- Onboarding persists.
- Review persists.
- Progress persists.
- Repository interfaces exist.
- API contracts exist.
- Firestore schema exists.
- Privacy/consent model exists.
- Quota model exists.
- No map/social/dating route exists.

## Future analytics events

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

Recommended event payloads should include `userId`, `languageProfileId`, `region`, `baseLanguageCode`, `targetLanguageCode`, `missionId`, `sessionId`, `tier`, `backendMode`, `clientTraceId`, and event-specific status fields. Do not add Firebase Analytics until backend work begins.
