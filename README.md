# FluentOS

FluentOS is a global speaking-first language app.

FluentOS is a global AI speaking coach that helps anyone become fluent through daily AI conversation, correction, repetition, and review, one active language at a time.

Tagline: Speak one language fluently before you split your focus.

## Current build

- Mock frontend only.
- Local persistence only.
- No backend.
- No real AI.
- No payment.
- No map/social/dating/chat/meetup.

## Backend plan

- Firebase Auth.
- Firestore.
- Firebase App Check.
- Cloudflare Workers.
- AI providers behind Cloudflare.
- Payment later.
- Social much later.

Backend readiness docs live in `docs/backend/`.

## How to run

```sh
flutter pub get
flutter run
```

## How to verify

```sh
flutter analyze
flutter test
flutter build apk --debug --target-platform=android-arm64 --split-per-abi
```
