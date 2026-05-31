# Subscription And Quotas

Do not add a payment SDK yet.

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

FluentOS is global, so pricing will be localized by region later.

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
