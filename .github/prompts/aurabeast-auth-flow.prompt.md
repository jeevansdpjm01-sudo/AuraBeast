---
name: AuraBeast Auth Flow
description: "Audit and implement a polished Flutter/Firebase login, signup, password-reset, social-login, and verification flow inspired by the clarity of modern music apps."
argument-hint: "Optional requirements, screenshots, or auth behavior to prioritize"
agent: "agent"
---

Improve the AuraBeast authentication experience using the request below:

${input:requirements}

Work in this Flutter/Firebase workspace. Start by tracing the active auth route from [main.dart](../../lib/main.dart), then inspect [auth_page.dart](../../lib/auth_page.dart), [auth_service.dart](../../lib/services/auth_service.dart), and nearby auth tests before editing. There may be overlapping auth implementations; determine which one is reachable and consolidate only when that is necessary.

Goals:
- Create a complete, production-minded flow for login and signup.
- Support email/password authentication, password reset, configured social providers, and phone verification where the existing Firebase service supports them.
- Make verification states explicit: loading, code sent, invalid or expired code, resend, cancellation, success, and provider/configuration failures.
- Keep users informed with clear, non-sensitive errors. Never expose passwords, verification codes, tokens, or raw Firebase internals in the UI.
- Preserve Firebase Auth and Firestore behavior already used by the app. Do not fake successful authentication or bypass Firebase rules.
- Use a polished, responsive music-app visual language with strong hierarchy, accessible contrast, keyboard-friendly forms, sensible autofill/input types, password visibility controls, and disabled states during requests. Take inspiration from Spotify's clarity and flow, but do not copy its branding, assets, or proprietary UI.
- Reuse the app's existing theme and components where practical. Avoid introducing a second competing auth architecture.

Implementation process:
1. State the active route, the smallest root cause or missing behavior, and the files you will change.
2. Make the smallest coherent implementation change. Preserve public service APIs unless a change is required for correctness.
3. Add or update focused widget/service tests for validation, state transitions, and error handling. Avoid tests that require live Firebase credentials.
4. Run `flutter analyze` and the narrowest relevant test command, then fix issues caused by this task.
5. Summarize changed files, user-visible behavior, Firebase-console prerequisites, and validation results. Call out any pre-existing failures separately.

Do not broaden the task into unrelated redesigns or backend migrations. If a Firebase capability is not configured, implement a graceful UI state and document the exact configuration needed.