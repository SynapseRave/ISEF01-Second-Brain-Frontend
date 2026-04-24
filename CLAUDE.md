# CLAUDE.md — Second Brain Frontend

## Project Overview

Flutter/Dart frontend for the **Second Brain Multi-App Interface** — a unified "Single Point of Entry" for notes, todos, and calendar events across multiple external services.

**Target integrations:** Notion, Todoist, Obsidian, OneNote, Calendar
**Auth:** Keycloak (Authorization Code Flow)
**Platforms:** Web (primary), Desktop, Mobile (cross-platform via Flutter)

---

## Common Commands

```bash
# Run (web)
flutter run -d chrome

# Run with specific environment
flutter run -d chrome --dart-define=ENV=dev

# Build web
flutter build web

# Analyze (lint)
flutter analyze

# Format
dart format lib/ test/

# Tests
flutter test

# Tests with coverage
flutter test --coverage

# Add dependency
flutter pub add <package>

# Get dependencies
flutter pub get
```

---

## Architecture

Feature-first folder structure under `lib/`:

```
lib/
├── main.dart                  # Entry point
├── app/
│   ├── app.dart               # Root widget, router setup
│   ├── router.dart            # GoRouter configuration
│   └── theme/                 # AppTheme, colors, typography
├── core/
│   ├── auth/                  # Keycloak OIDC client, token management
│   ├── api/                   # HTTP client (Dio), interceptors, error handling
│   ├── error/                 # Failure types, error mapping
│   └── utils/                 # Shared utilities
└── features/
    ├── dashboard/             # Dashboard: notes/todos/calendar widgets
    ├── chat/                  # Chat interface, streaming responses
    ├── history/               # Input history, pagination
    └── settings/              # Service connections (Notion, Todoist, etc.)
```

Each feature follows this internal structure:
```
features/<feature>/
├── data/
│   ├── datasources/           # Remote API calls
│   ├── models/                # DTOs + JSON serialization
│   └── repositories/         # Repository implementations
├── domain/
│   ├── entities/              # Pure domain models
│   ├── repositories/         # Abstract repository interfaces
│   └── usecases/              # Single-responsibility use cases
└── presentation/
    ├── bloc/                  # BLoC/Cubit state management
    ├── pages/                 # Full screens
    └── widgets/               # Feature-specific widgets
```

---

## State Management

Use **flutter_bloc** (BLoC/Cubit pattern):
- Cubits for simple local state (form state, toggles)
- BLoCs for complex event-driven flows (auth, data fetching)
- No `setState` outside of purely local widget concerns

---

## Dependency Injection

Use **get_it** + **injectable** for service registration and injection.
Register dependencies in `lib/core/di/injection.dart`.

---

## API Client

Built on **Dio**. The client lives in `lib/core/api/`:
- Base URL and timeouts come from `--dart-define` env vars
- Auth interceptor attaches Bearer tokens from Keycloak
- Refresh interceptor handles 401 → silent refresh → retry
- All errors map to typed `Failure` objects before reaching the UI

---

## Auth (Keycloak)

Flow: **Authorization Code Flow + PKCE**
- Use `flutter_appauth` or `openid_client` for the OIDC flow
- Access token stored in memory only; refresh token in secure storage (`flutter_secure_storage`)
- Silent refresh runs before token expiry
- Route guards via GoRouter `redirect` callback — check auth state from `AuthCubit`
- On expired session or missing role: redirect to login, show contextual error

---

## Routing

Use **go_router**:
- Routes defined in `lib/app/router.dart`
- Protected routes use `redirect` to check `AuthCubit` state
- Named routes for deep linking support

---

## Environment Config

Pass config via `--dart-define` at build time:

```bash
flutter run --dart-define=API_BASE_URL=http://localhost:8080 \
            --dart-define=KEYCLOAK_URL=http://localhost:8180 \
            --dart-define=KEYCLOAK_REALM=second-brain \
            --dart-define=KEYCLOAK_CLIENT_ID=frontend
```

Read in code via:
```dart
const apiBaseUrl = String.fromEnvironment('API_BASE_URL');
```

Never put secrets in the source code or `.env` files committed to git.

---

## Code Conventions

- **Dart style:** follow `flutter_lints` + `dart format` (line length 80)
- **Naming:** `snake_case` files, `PascalCase` classes, `camelCase` variables
- **Immutability:** prefer `const` constructors and `final` fields
- **No print:** use a proper logger (`logger` package) — `avoid_print` lint is enforced
- **Null safety:** full sound null safety — no `!` without explicit justification
- **Separation:** domain entities must not depend on Flutter or Dio; keep them pure Dart
- **Single responsibility:** one use case per class, one purpose per file

---

## Testing

| Layer | Tool | Location |
|---|---|---|
| Unit (use cases, cubits) | `flutter_test` + `mocktail` | `test/unit/` |
| Widget | `flutter_test` | `test/widget/` |
| Integration | `integration_test` package | `integration_test/` |

- Mock repository interfaces, never concrete HTTP clients in unit tests
- Widget tests must not require a running backend
- Use `pump` + `pumpAndSettle` correctly — avoid arbitrary `Future.delayed`

---

## UI / Design

- Material 3 (`useMaterial3: true`) as the base
- Responsive layout: `LayoutBuilder` / `AdaptiveLayout` — breakpoints: mobile <600, tablet <1024, desktop ≥1024
- Dashboard uses a widget/section layout: Notes | Todos | Calendar (tab or split)
- Chat window is always accessible (persistent overlay or bottom panel)
- Accessibility: semantic labels on interactive widgets, visible focus states, WCAG AA contrast minimum

---

## External Service Integrations

Each integration lives in its own datasource under the relevant feature:

| Service | Auth method | Credentials |
|---|---|---|
| Google Calendar | OAuth2 PKCE (browser redirect) | `access_token`, `refresh_token`, `expires_at` |
| Microsoft OneNote | OAuth2 PKCE (browser redirect) | `access_token`, `refresh_token`, `expires_at` |
| Notion | API Token (dialog) | `api_token` |
| Todoist | API Token (dialog) | `api_token` |
| Obsidian | Local REST Plugin (dialog) | `api_key`, `base_url` (default: `http://localhost:27123`) |

Connection state per service is managed in `settings` feature via `SettingsCubit`.
OAuth services open a browser redirect; API-key services use `ApiKeyInputDialog`.

## Current Implementation Status (2026-04-24)

**Done:**
- Keycloak PKCE login (Authorization Code Flow + S256)
- OAuth2 flows for Google Calendar and OneNote (PKCE, callback pages)
- API-Key dialog for Notion, Todoist, Obsidian
- Chat input wired: Enter key + Send button → `ChatCubit.sendMessage()`
- Live SSE streaming: chunk events appear token by token
- Typing indicator, status messages, auto-scroll, disabled input while streaming

**Runtime configuration (dart-defines):**
```bash
flutter run -d chrome --web-port=3000 \
  --dart-define=API_BASE_URL=http://localhost:8000 \
  --dart-define=KEYCLOAK_URL=http://localhost:8080 \
  --dart-define=KEYCLOAK_REALM=second-brain \
  --dart-define=KEYCLOAK_CLIENT_ID=frontend \
  --dart-define=GOOGLE_CALENDAR_CLIENT_ID=<your-client-id> \
  --dart-define=MICROSOFT_CLIENT_ID=<your-client-id> \
  --dart-define=MICROSOFT_TENANT_ID=common
```

## SSE Event Protocol

The backend (`POST /api/input/`) streams these event types in order:

| Type | Frontend class | Behaviour |
|---|---|---|
| `status` | `SseStatusEvent` | Status line in chat (e.g. "LLM wird angefragt...") |
| `tool_call` | `SseStatusEvent` | Shown as "service: tool…" status |
| `chunk` | `SseChunkEvent` | Appended live to `streamingContent` |
| `result` | `SseResultEvent` | **Ignored** if chunks were already received (fallback only) |
| `done` | `SseDoneEvent` | Finalises assistant message (`input_id` is a UUID string) |
| `error` | `SseErrorEvent` | Shows error, stops streaming |

## Architecture Notes

**DI container:** `injection.config.dart` is generated code but committed and manually
maintained when `build_runner` is unavailable. Chat feature classes use aliases `_i2001+`.
Run `flutter pub run build_runner build` to regenerate properly.

**OAuth callback routing:** `/settings/connect/callback/*` routes are exempt from the
`AuthLoading → /login` redirect in `router.dart`. This preserves `?code=` and `?state=`
query params across the app reload that happens after the OAuth provider redirect.

---

## Git Workflow

- Branch: `develop` for active work, `main` for releases
- Commit style: `<type>: <short description>` (feat, fix, chore, refactor, test, docs)
- No direct commits to `main`
- PRs require passing `flutter analyze` and `flutter test`
