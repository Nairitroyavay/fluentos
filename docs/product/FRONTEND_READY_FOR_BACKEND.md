# Frontend Ready For Backend

## 1. Current Frontend Status

FluentOS is frontend-ready for backend Phase 1. The app runs in `mockLocal` mode with Flutter, Riverpod, GoRouter, SharedPreferences persistence, fake auth, repository contracts, fake repository implementations, and mock product flows.

## 2. Completed Screens

Splash, Auth, Onboarding, Home/MainShell, Today, Speak, Review, Progress, Profile, and Premium Preview are implemented. Onboarding includes welcome, region/country, base language, target language, goal, level, speaking confidence, daily time, voice baseline, generated 7-day plan, and one-language focus.

## 3. Completed Mock Flows

- Fake sign-in, sign-out, and reset demo data.
- Region, base language, target language, onboarding profile, active language, missions, reviews, progress, and settings persistence.
- Mission -> speak -> correct -> repeat -> review -> progress.
- Coming-soon language blocking.
- One active language rule for free users.
- Premium preview without a payment SDK.

## 4. Remaining Known Limitations

- No real backend, Firebase, Cloudflare, AI, payment, analytics, push, or remote config.
- Speech, correction, quota, entitlement, and mission generation are mock/local only.
- No audio is captured or stored.
- Physical-device QA depends on an attached Android device.

## 5. Backend Start Order

1. Firebase project setup
2. Firebase Auth
3. Firestore user profile
4. Firestore onboarding profile
5. Firestore language profiles
6. Firestore missions/review/progress sync
7. App Check
8. Cloudflare Worker skeleton
9. Limited AI correction endpoint
10. Quota enforcement
11. Payment later

## 6. What Not To Build Yet

Do not start AI first. Do not start payment first. Do not add map, social, dating, chat, voice rooms, nearby users, meetups, Firebase Storage audio retention, or social discovery.

## 7. Final Backend Start Checklist

- `flutter pub get` passes.
- `flutter analyze` passes.
- `flutter test` passes.
- Android debug APK builds.
- Route guards work.
- Local persistence works after restart.
- Repository contracts are clean enough to swap fake implementations for Firebase/Cloudflare implementations.
- Global-first copy is documented.
- No Firebase, Cloudflare, real AI, payment SDK, map, social, dating, chat, or meetup feature is in the frontend.
