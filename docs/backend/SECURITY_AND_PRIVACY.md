# Security And Privacy

Do not add Firebase, Cloudflare, analytics, payment, maps, social, or dating yet.

## Consent model

`ConsentSettings` fields:

- `voiceProcessingAccepted`
- `saveTranscriptsAccepted`
- `saveAudioAccepted`
- `modelImprovementOptIn`
- `analyticsOptIn`
- `marketingOptIn`
- `acceptedAt`
- `updatedAt`

## Voice and transcripts

- Voice consent must be explicit before real backend voice processing.
- No audio is stored by default.
- Transcript is stored only for review/progress if user consents.
- Correction data can be stored for Review because it powers the core learning loop.
- Audio storage, if ever added, must be separate opt-in consent.
- Profile should clearly say: "Voice is not stored in this demo."

## Data rights

- Export data later.
- Delete account later.
- Opt-in for model improvement only.
- Region-aware privacy later.
- Minors/social features are not supported now.
- No map/social/dating.

## Planned Firestore rules strategy

- User can read/write only own user document.
- User can read/write own language profiles.
- User can read/write own missions.
- User can read/write own reviews.
- User can read own subscription/usage.
- User cannot directly increase entitlement.
- User cannot directly bypass quota.
- Server/Cloudflare writes trusted scoring or usage records later.
- Public config is read-only.
- Templates are read-only from client.

Backend enforcement must not trust client-calculated AI usage, subscription tier, or premium entitlement.

## Backend trust boundary

- Auth identity comes from Firebase Auth later.
- App Check must be verified by Cloudflare/Firebase later.
- AI provider keys live only in backend infrastructure.
- Usage/quota writes are backend-owned.
- Payment entitlement writes are backend/payment-owned.
