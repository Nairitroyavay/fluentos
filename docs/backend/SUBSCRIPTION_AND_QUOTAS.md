# Subscription And Quotas

Do not add a payment SDK yet. FluentOS is global-first, so pricing will be localized by region later after quota and AI usage patterns are understood.

## Tiers

### Free

- 1 active language.
- Limited daily AI speaking seconds.
- Basic correction.
- Review queue.
- Basic progress.

### Pro

- Multiple active languages.
- Higher AI seconds limit.
- Deeper corrections.
- Fear Breaker.
- Weekly reports.

### Pro Plus

- Advanced fluency tests.
- Interview/work/travel packs.
- Downloadable scenario packs.
- Early access to future safe practice features.

Free means one active language at a time. Pro can later unlock multiple active language journeys.

## Quota rules

- Daily AI seconds.
- Monthly AI seconds.
- Max session duration.
- Max correction requests per day.
- Abuse protection.
- Server-side enforcement only.

## Enforcement

- Client can show entitlement state, but cannot grant entitlement.
- Cloudflare/Firebase backend must enforce limits before calling AI vendors.
- Client-reported duration is a hint only.
- Backend records trusted usage after AI work completes.
- Subscription tier and premium entitlement must come from backend/payment sync.
- Backend starts with Firebase Auth + Firestore records before any payment SDK.
- Cloudflare enforces AI quotas later.
- No map, social, dating, chat, nearby, voice-room, or meetup entitlement exists in MVP.
