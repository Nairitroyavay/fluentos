# AI Voice Pipeline Contract

Do not add real AI yet.

## MVP AI pipeline

1. User records short speech in the app.
2. App sends audio to Cloudflare Worker.
3. Worker validates auth and quota.
4. Worker calls STT provider.
5. Worker sends transcript plus mission context to correction model.
6. Worker returns correction to app.
7. App saves session, review, and progress.
8. Worker records usage/quota.

## First architecture

Do not use full real-time voice in the first backend version. Use a chained architecture:

`STT -> correction/scenario engine -> optional TTS`

Provider choice must not be hardcoded in the UI. The backend hides provider selection and returns normalized fields.

## Provider strategy

- Global STT: OpenAI or Google Speech candidate.
- Global pronunciation assessment: Azure Speech candidate.
- Indian language STT/TTS: Sarvam candidate.
- Global TTS: OpenAI, Azure, or Google candidate.

## AI safety

- If transcript confidence is low, return `confidenceLow = true`.
- App should show: "I may have misheard you".
- Never pretend correction is perfect.
- Include `modelConfidence`.
- Allow user feedback on correction.
- Store transcripts only according to consent.
- Store audio only if future explicit audio consent exists.
