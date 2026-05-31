# Testing Checklist

## Current local checks

- `flutter pub get`
- `flutter analyze`
- `flutter test`
- `flutter build apk --debug --target-platform=android-arm64 --split-per-abi`

## Product flow checks

- App launches.
- Splash routes correctly.
- Fake auth works.
- Full onboarding works.
- Region/country is saved.
- Base language is saved.
- Target language is saved.
- Active language is created.
- 7-day plan is created.
- Today mission is region-aware.
- Speak session works.
- Correction appears.
- Repeat attempt works.
- Save to review works.
- Review persists after restart.
- Progress updates.
- Progress persists after restart.
- Profile shows global language journey.
- Second language opens premium preview for free user.
- Reset demo data works.

## Backend readiness checks

- Repository interfaces exist.
- Fake implementations still power the app.
- Backend docs exist.
- Firestore schema plan exists.
- API contracts exist.
- AI pipeline contract exists.
- Subscription/quota contract exists.
- Privacy/consent contract exists.
- No Firebase dependency added.
- No real backend added.
- No real AI added.
- No payment SDK added.
- No map/social/dating added.
