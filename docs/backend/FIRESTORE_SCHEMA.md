# Firestore Schema Plan

Do not add the Firestore SDK yet. This is the planned schema for the first backend implementation.

## `users/{userId}`

- Purpose: private user profile and current app identity.
- Fields: `id`, `name`, `email`, `userRegion`, `baseLanguageCode`, `activeLanguageProfileId`, `subscriptionTier`, `hasCompletedOnboarding`, `consentSettings`, `createdAt`, `updatedAt`.
- Indexes: none beyond document ID for MVP.
- Owner: user reads/writes safe profile fields; server writes trusted entitlement-related fields.
- Retention: until account deletion.
- Sensitivity: high, personal data.

## `users/{userId}/languageProfiles/{languageProfileId}`

- Purpose: one language journey configuration and scores.
- Fields: `id`, `userId`, `baseLanguageCode`, `baseLanguageName`, `targetLanguageCode`, `targetLanguageName`, `targetCulture`, `userRegion`, `level`, `goal`, `fluencyScore`, `confidenceScore`, `pronunciationScore`, `weakSounds`, `scriptMode`, `accentPreference`, `isActive`, `createdAt`, `updatedAt`.
- Indexes: `isActive`, `targetLanguageCode`, `updatedAt`.
- Owner: user writes preferences; server may write trusted scores later.
- Retention: until account deletion or user removes language profile.
- Sensitivity: medium/high learning profile.

## `users/{userId}/dailyMissions/{missionId}`

- Purpose: scheduled speaking missions.
- Fields: `id`, `userId`, `languageProfileId`, `region`, `baseLanguageCode`, `targetLanguageCode`, `title`, `description`, `scenario`, `coachPrompt`, `successCue`, `targetPhrases`, `estimatedMinutes`, `difficulty`, `focusArea`, `isCompleted`, `scheduledDate`, `completedAt`, `createdAt`.
- Indexes: `languageProfileId + scheduledDate`, `languageProfileId + isCompleted`.
- Owner: server generates, user marks completion through trusted flow.
- Retention: keep while language profile exists.
- Sensitivity: medium learning data.

## `users/{userId}/speakSessions/{sessionId}`

- Purpose: one speaking attempt and correction context.
- Fields: `id`, `userId`, `missionId`, `languageProfileId`, `mode`, `phase`, `title`, `scenario`, `coachPrompt`, `turns`, `transcriptText`, `transcriptConfidence`, `transcriptConfidenceLow`, `correction`, `attemptCount`, `durationSeconds`, `isSavedToReview`, `createdAt`, `completedAt`.
- Indexes: `languageProfileId + createdAt`, `missionId`.
- Owner: client creates local session; server records trusted AI response and usage later.
- Retention: configurable; default keep transcript only if consent allows.
- Sensitivity: high because transcripts may contain personal speech.

## `users/{userId}/reviewItems/{reviewItemId}`

- Purpose: saved corrections and phrases for spaced review.
- Fields: `id`, `userId`, `languageProfileId`, `missionId`, `sessionId`, `correction`, `region`, `baseLanguageCode`, `targetLanguageCode`, `missionTitle`, `isMastered`, `isSavedPhrase`, `reviewedCount`, `nextReviewAt`, `dateAdded`, `createdAt`, `updatedAt`.
- Indexes: `languageProfileId + nextReviewAt`, `languageProfileId + isMastered`, `isSavedPhrase`.
- Owner: user reads/writes review state; server may create suggestions.
- Retention: until user deletes item/account.
- Sensitivity: high learning/transcript-derived data.

## `users/{userId}/fluencySnapshots/{snapshotId}`

- Purpose: score history and weekly progress.
- Fields: `id`, `userId`, `languageProfileId`, `date`, `fluencyScore`, `confidenceScore`, `pronunciationScore`, `grammarScore`, `conversationReadiness`, `speakMinutes`, `correctionsSaved`, `completedMissions`, `createdAt`.
- Indexes: `languageProfileId + date`.
- Owner: server writes trusted snapshots; user reads.
- Retention: until account deletion.
- Sensitivity: medium learning analytics.

## `users/{userId}/settings/private`

- Purpose: private app preferences and consent flags.
- Fields: `transliteration`, `strictCorrections`, `notifications`, `highContrast`, `voiceConsent`, `speechSpeed`, `coachTone`, `updatedAt`.
- Indexes: none.
- Owner: user reads/writes.
- Retention: until account deletion.
- Sensitivity: medium.

## `users/{userId}/usage/current`

- Purpose: server-controlled AI quota usage.
- Fields: `dailyAiSecondsLimit`, `monthlyAiSecondsLimit`, `usedAiSecondsToday`, `usedAiSecondsThisMonth`, `maxSessionDurationSeconds`, `maxCorrectionRequestsPerDay`, `correctionRequestsToday`, `quotaDate`, `updatedAt`.
- Indexes: none.
- Owner: server writes; user reads.
- Retention: rolling daily/monthly records.
- Sensitivity: medium operational data.

## `users/{userId}/subscriptions/current`

- Purpose: current entitlement from payment/backend.
- Fields: `tier`, `activeLanguageLimit`, `dailyAiSecondsLimit`, `monthlyAiSecondsLimit`, `canUseAdvancedCorrections`, `canUseFearBreaker`, `canUseWeeklyReports`, `expiresAt`, `updatedAt`.
- Indexes: none.
- Owner: payment/backend writes; user reads.
- Retention: current plus audit history later.
- Sensitivity: high billing/entitlement data.

## Global collections

### `languageOptions/{languageCode}`

- Purpose: available base/target languages.
- Fields: `code`, `name`, `nativeName`, `flag`, `supportStatus`, `canBeBase`, `canBeTarget`, `scriptName`, `hasRomanization`, `hasTransliteration`, `commonRegions`, `defaultAccentOptions`.
- Indexes: `supportStatus`, `canBeTarget`.
- Owner: server/admin writes; client reads.
- Retention: permanent config.
- Sensitivity: public.

### `scenarioTemplates/{templateId}`

- Purpose: reusable scenario prompts.
- Fields: `targetLanguageCode`, `region`, `goal`, `level`, `title`, `scenario`, `coachPrompt`, `targetPhrases`, `difficulty`.
- Indexes: `targetLanguageCode + region`, `goal + level`.
- Owner: server/admin writes; client reads.
- Retention: permanent config.
- Sensitivity: public/read-only.

### `missionTemplates/{templateId}`

- Purpose: seed mission plans and fallbacks.
- Fields: `baseLanguageCode`, `targetLanguageCode`, `region`, `goal`, `title`, `description`, `focusArea`, `estimatedMinutes`.
- Indexes: `targetLanguageCode + region + goal`.
- Owner: server/admin writes; client reads.
- Retention: permanent config.
- Sensitivity: public/read-only.

### `appConfig/public`

- Purpose: app flags, supported backend versions, maintenance messaging.
- Fields: `minimumClientVersion`, `backendMode`, `aiEnabled`, `paymentEnabled`, `supportedLanguages`, `updatedAt`.
- Indexes: none.
- Owner: server/admin writes; client reads.
- Retention: current config.
- Sensitivity: public/read-only.

### `feedback/{feedbackId}`

- Purpose: correction feedback reports.
- Fields: `userId`, `sessionId`, `correctionId`, `reason`, `optionalText`, `createdAt`, `status`.
- Indexes: `userId + createdAt`, `status`.
- Owner: client creates; server/admin reviews.
- Retention: policy-defined moderation/support window.
- Sensitivity: high because it can include transcript/correction text.

## Audio storage

Voice/audio should not be stored by default. If audio storage is added later, it must be explicit consent only, separate from transcript/review consent, with clear retention and deletion controls.
