# Plan — Second Brain Frontend

> Stand: 2026-03-29
> Projekt: ISEF01-Second-Brain-Frontend
> Stack: Flutter/Dart · Keycloak · Dio · flutter_bloc · GoRouter

---

## Legende

| Symbol | Bedeutung |
|--------|-----------|
| `[ ]` | Offen |
| `[x]` | Erledigt |
| `[~]` | In Arbeit |
| `[-]` | Zurückgestellt / optional |

---

## Phase 0 — Fundament & Infrastruktur

> Ziel: Lauffähige Dev-Umgebung, CI, Docker, Test-Grundgerüst

### Anforderung: Entwicklungsumgebung aufbauen

- [x] Flutter-Projekt anlegen inkl. Ordnerstruktur (`lib/core`, `lib/features`, `lib/app`)
- [x] `analysis_options.yaml` mit `flutter_lints` konfiguriert
- [x] Linting-Regeln erweitern: `prefer_single_quotes`, `avoid_print`, `always_use_package_imports`
- [-] `dart format` als Pre-Commit-Hook einrichten (z. B. über `lefthook` oder `git hooks`)
- [x] Lokale Entwicklungsumgebung: Hot-Reload bestätigen (`flutter run -d chrome`)
- [x] Environment-Konzept: `--dart-define` für `API_BASE_URL`, `KEYCLOAK_URL`, `KEYCLOAK_REALM`, `KEYCLOAK_CLIENT_ID`
- [x] `flutter_dotenv` oder Shell-Skript für lokale Dev-Defines einrichten
- [ ] Unit-Test-Struktur anlegen: `test/unit/`, `test/widget/`, `integration_test/`
- [ ] `mocktail` als Test-Dependency hinzufügen

### Anforderung: Docker Container für Web

- [ ] `Dockerfile` für `flutter build web` erstellen
- [ ] Nginx-Konfiguration für SPA-Routing (`try_files $uri /index.html`)
- [ ] `docker-compose.yml` für lokalen Stack (Frontend + ggf. Mock-Backend)
- [ ] `.dockerignore` pflegen

### Anforderung: CI/CD-Pipeline *(neu — fehlte in ursprünglichen Anforderungen)*

> Begründung: Ohne automatisierte Checks hat Codequalität keinen Anker. Notwendig für kollaboratives Arbeiten.

- [ ] GitHub Actions Workflow: `flutter analyze` + `flutter test` bei jedem PR
- [ ] GitHub Actions Workflow: `dart format --output=none --set-exit-if-changed` (Format-Check)
- [ ] Build-Job: `flutter build web` als Smoke-Test
- [ ] Optional: Docker Image bauen + pushen bei Merge auf `main`

---

## Phase 1 — Design System & UI Shell

> Ziel: Visuelles Fundament, Shell-Layout, Navigation

### Anforderung: Design System / Shared Components *(konkretisiert aus "Standard-Komponenten tbd")*

> Begründung: Ohne gemeinsame Basiskomponenten entstehen inkonsistente UIs. Muss vor den Feature-Pages stehen.

- [ ] `AppTheme` definieren: Farben, Typografie, Spacing-Konstanten (Material 3)
- [ ] Dark Mode / Theme-Toggle implementieren *(neu — fehlte komplett)*
  - [ ] `ThemeCubit` für persistierten Theme-Wechsel (`shared_preferences`)
  - [ ] Theme-Toggle in App-Shell einbauen
- [ ] Shared Widget Library unter `lib/core/widgets/`:
  - [ ] `AppLoadingIndicator` (zentriert, overlay-fähig)
  - [ ] `AppErrorView` (Icon + Nachricht + Retry-Button)
  - [ ] `AppEmptyView` (Illustration + Nachricht)
  - [ ] `AppToast` / `SnackbarService` für Action-Feedback *(neu — fehlte)*
  - [ ] `AppConfirmDialog` (wiederverwendbar für Delete-Flows)
  - [ ] `AppButton` (Primary, Secondary, Destructive)
  - [ ] `AppTextField` mit konsistenter Validierungsdarstellung
- [ ] Responsive Breakpoints definieren: mobile `<600`, tablet `<1024`, desktop `≥1024`

### Anforderung: UI Shell / Grundlayout implementieren

- [ ] Responsives Shell-Layout: `NavigationRail` (Desktop) / `BottomNavigationBar` (Mobile)
- [ ] Navigation einrichten: Dashboard, Suche, Historie, Einstellungen
- [ ] `GoRouter` konfigurieren mit Named Routes
- [ ] Route Guards (Platzhalter bis Auth steht — zunächst alle Routen offen)
- [ ] Shell persistiert Chat-Fenster als globales Overlay

### Anforderung: Dependency Injection aufsetzen *(neu — fehlte als explizite Task)*

> Begründung: DI muss früh stehen, alle späteren Features hängen davon ab.

- [ ] `get_it` + `injectable` zu `pubspec.yaml` hinzufügen
- [ ] `lib/core/di/injection.dart` mit `@InjectableInit` anlegen
- [ ] Code-Generierung: `dart run build_runner build` in Workflow dokumentieren
- [ ] `ServiceLocator`-Wrapper für einfachen Zugriff

---

## Phase 2 — Authentifizierung

> Ziel: Keycloak-Login vollständig, Token-Handling, geschützte Routen

### Anforderung: Authentifizierung & Session-Handling (Keycloak)

- [ ] `flutter_appauth` für Authorization Code Flow + PKCE integrieren
- [ ] `AuthRepository` + `AuthCubit` anlegen
- [ ] Login Flow: Redirect zu Keycloak → Callback → Token speichern
- [ ] Token-Handling:
  - [ ] Access Token nur im Memory halten
  - [ ] Refresh Token in `flutter_secure_storage`
  - [ ] Silent Refresh: Timer-basiert vor Ablauf (z. B. 60 s vor Expiry)
- [ ] Dio `AuthInterceptor`: Bearer Token an jeden Request anhängen
- [ ] Dio `RefreshInterceptor`: 401 → silent refresh → Request wiederholen
- [ ] Route Guards via `GoRouter redirect`: alle geschützten Routen prüfen `AuthCubit`
- [ ] Logout Flow: Token revoken → lokalen State leeren → Redirect zu Login
- [ ] Fehlerzustände UX:
  - [ ] Abgelaufene Session → Toast + Redirect zu Login
  - [ ] Fehlende Rollen → `AppErrorView` mit Erklärung

---

## Phase 3 — API Client & Fehlerhandling

> Ziel: Zentraler, robuster HTTP-Client; einheitliches Error-Mapping

### Anforderung: API Client & Datenhandling implementieren

- [ ] `Dio`-Instanz konfigurieren: `BaseURL`, Timeouts (connect 10 s, receive 30 s), Retries
- [ ] Interceptoren verketten: Logging → Auth → Refresh → Error-Mapping
- [ ] Typed `Failure`-Klassen: `NetworkFailure`, `AuthFailure`, `ServerFailure`, `NotFoundFailure`, `ValidationFailure`
- [ ] `Either<Failure, T>` als Repository-Rückgabetyp (via `fpdart` oder `dartz`)
- [ ] Globales Error-Mapping: HTTP-Status → `Failure`-Typ
- [ ] `ApiException` → UI-Fehlermeldung: Mapping-Tabelle definieren und umsetzen
- [ ] Einheitliches Logging aller API-Calls (nur im Debug-Mode)

### Anforderung: Offline- / Connectivity-Handling *(neu — fehlte komplett)*

> Begründung: Externe APIs + Keycloak schlagen bei fehlendem Netz fehl. Ohne Handling entstehen unverständliche Fehler.

- [ ] `connectivity_plus` integrieren
- [ ] `ConnectivityCubit` beobachtet Netzwerkstatus
- [ ] Bei Offline-Status: Banner in App-Shell anzeigen
- [ ] API-Calls bei Offline: sofortige `NetworkFailure` statt Timeout abwarten

---

## Phase 4 — Externe Service-Verbindungen (OAuth-Flows)

> Ziel: Nutzer kann Dienste verbinden/trennen; OAuth-Flows für alle 5 Services

### Anforderung: OAuth-Flows für externe Dienste *(neu — fehlte als eigene Anforderung)*

> Begründung: Jeder Service benötigt einen eigenen OAuth2-Flow im Frontend. Das ist nicht trivial und muss separat geplant werden.

- [ ] **Notion:** OAuth2 Authorization Flow → Access Token speichern
- [ ] **Todoist:** OAuth2 Authorization Flow → Access Token speichern
- [ ] **OneNote (Microsoft):** MSAL / Azure AD OAuth2 Flow (`msal_auth` oder WebView-Flow)
- [ ] **Google Calendar:** Google OAuth2 (`google_sign_in` oder manueller Flow)
- [ ] **Obsidian:** Kein OAuth — URL + API-Key für Local REST Plugin
- [ ] Tokens pro Service in `flutter_secure_storage` (isoliert pro Dienst)
- [ ] `ServiceConnectionRepository` pro Dienst: `connect()`, `disconnect()`, `getStatus()`
- [ ] Fehlerhandling: abgelaufene Service-Tokens → Nutzer zur Neu-Verbindung auffordern

### Anforderung: Einstellungsseite bereitstellen

- [ ] `SettingsPage` erstellen: Liste aller Dienste mit Status-Badge
- [ ] Status-Zustände pro Dienst: `connected` / `disconnected` / `error` / `connecting`
- [ ] „Verbinden"-Button → startet OAuth-Flow des jeweiligen Dienstes
- [ ] „Trennen"-Button → löscht gespeicherten Token + Status zurücksetzen
- [ ] Benutzerspezifische Einstellungen (Sprache, Theme, ggf. Standardziel für Quick Capture)
- [ ] Einstellungen in `shared_preferences` persistieren

---

## Phase 5 — Dashboard

> Ziel: Zentrale Übersicht mit Daten aus verbundenen Diensten

### Anforderung: Dashboard bereitstellen

- [ ] Dashboard-Layout: Tab-basiert oder Split-View (Notizen | Todos | Kalender)
- [ ] Responsiv: Desktop = Split, Mobile = Tabs
- [ ] **Notizen-Widget:**
  - [ ] Liste der letzten Notizen (Notion/OneNote/Obsidian je nach verbunden)
  - [ ] Klick → Detailansicht (read-only + Deep Link zur Quelle)
  - [ ] `NotesCubit` + `GetNotesUseCase`
- [ ] **Todos-Widget:**
  - [ ] Liste offener Todos (Todoist)
  - [ ] Klick → Detailansicht
  - [ ] `TodosCubit` + `GetTodosUseCase`
- [ ] **Kalender-Widget:**
  - [ ] Tages-/Wochenansicht bevorstehender Termine
  - [ ] Klick → Detailansicht
  - [ ] `CalendarCubit` + `GetEventsUseCase`
- [ ] Loading / Empty / Error States pro Widget (Shared Components aus Phase 1)
- [ ] Pull-to-Refresh

---

## Phase 6 — Suche *(neu — fehlte komplett)*

> Ziel: Dienstübergreifende Suche — Kernfunktion eines "Second Brain"

> Begründung: Das Wiederfinden von Informationen ist explizit im Projektziel genannt. Eine Suche fehlt vollständig in den Anforderungen.

### Anforderung: Suche über alle verbundenen Dienste

- [ ] Suchseite mit zentralem Eingabefeld
- [ ] Suchanfrage wird parallel an alle verbundenen Dienste geschickt
- [ ] Ergebnisse nach Typ gruppiert (Notizen, Todos, Termine)
- [ ] Ergebnis-Item zeigt Quelle (Service-Icon + Name)
- [ ] Klick auf Ergebnis → Detailansicht + Deep Link
- [ ] Loading-State pro Dienst (progressive Anzeige sobald ein Dienst antwortet)
- [ ] `SearchCubit` mit Debounce (300 ms)

---

## Phase 7 — Chat & Quick Capture

> Ziel: KI-Chat mit Streaming, automatische Ablage in Zielsysteme

### Anforderung: Chat-Interface implementieren

- [ ] Persistentes Chat-Fenster (immer sichtbar, minimierbar)
- [ ] Chat-Input mit Send-Button + Enter-Shortcut
- [ ] Nachrichtenliste mit User/Assistant-Trennung
- [ ] Streaming-Antwort: Token-by-Token via SSE oder WebSocket
- [ ] Thinking-Indikator: Statusanzeige während Verarbeitung (animierter Indikator)
- [ ] Fehlerfall: Netz-Abbruch während Streaming → Teilantwort + Fehlermeldung

### Anforderung: Quick Capture über Chat

- [ ] Typ-Erkennung: Notiz → Notion/OneNote/Obsidian, Todo → Todoist, Termin → Kalender
- [ ] Automatische Zielsystem-Auswahl (konfigurierbar in Einstellungen)
- [ ] Manuelles Override: Nutzer kann Ziel vor dem Senden wählen *(neu — implizit notwendig)*
- [ ] Nach Erfolg: Cache-Invalidierung → Dashboard aktualisiert sich ohne Reload
- [ ] Bestätigung im Chat: "Gespeichert in Notion" o. ä.

---

## Phase 8 — Historien-Seite

> Ziel: Alle bisherigen Chat-Eingaben abrufbar, löschbar

### Anforderung: User-Input Historie anzeigen

- [ ] `HistoryPage` mit Liste aller bisherigen Inputs
- [ ] Infinite Scroll / Pagination (serverseitige Parameter abstimmen)
- [ ] Listenitem: Kurzvorschau Input + Zeitstempel + Service-Icon
- [ ] Klick → Detailansicht: vollständiger Input + Antwort des Systems
- [ ] Loading / Empty / Error States (Shared Components)

### Anforderung: Löschen einzelner User Inputs

- [ ] Delete-Icon pro Listeneintrag
- [ ] `AppConfirmDialog` vor Löschung
- [ ] Nach Löschen: Liste aktualisiert sich ohne Reload (optimistic update)
- [ ] Fehler beim Löschen: Toast + Rollback

---

## Phase 9 — Deep Links & Accessibility

### Anforderung: Deep Links zu Quellsystemen

- [ ] „In Quelle öffnen"-Button pro Detailansicht (wo sinnvoll)
- [ ] URL-Generierung je Dienst: Notion-Page-URL, Todoist-Task-URL, etc.
- [ ] `url_launcher` zum Öffnen externer Links
- [ ] Fallback wenn kein Deep Link verfügbar: Button ausblenden

### Anforderung: Accessibility-Basics

- [ ] Alle interaktiven Elemente haben `Semantics`-Labels
- [ ] Tastaturbedienung: Tab-Reihenfolge logisch, alle Aktionen per Tastatur erreichbar
- [ ] Sichtbare Focus-States auf allen interaktiven Widgets
- [ ] WCAG AA Kontrast-Mindestanforderungen einhalten (Text auf Background ≥ 4.5:1)
- [ ] Screen-Reader-Test auf zentralen Flows

---

## Phase 10 — PWA & Production-Readiness *(neu — fehlte komplett)*

> Begründung: Web ist primäre Plattform. Ohne PWA-Setup fehlt Installierbarkeit und Offline-Grundlage.

### Anforderung: PWA-Support

- [ ] `manifest.json` konfigurieren: Name, Icons, Theme-Color, `display: standalone`
- [ ] App-Icons in allen PWA-Größen generieren
- [ ] `flutter build web --pwa-strategy=offline-first` evaluieren
- [ ] HTTPS-Voraussetzung in Deployment-Doku festhalten

### Anforderung: Internationalisierung vorbereiten *(optional)*

- [ ] `flutter_localizations` + `intl` hinzufügen
- [ ] ARB-Dateien für DE + EN anlegen (`app_de.arb`, `app_en.arb`)
- [ ] Alle Strings in der App durch lokalisierte Keys ersetzen
- [ ] Sprach-Toggle in Einstellungen

---

## Abhängigkeitsgraph (Phasen-Reihenfolge)

```
Phase 0 (Fundament)
    └── Phase 1 (Design System + Shell)
            └── Phase 2 (Auth)
                    └── Phase 3 (API Client)
                            ├── Phase 4 (Service OAuth + Einstellungen)
                            │       └── Phase 5 (Dashboard)
                            │               └── Phase 6 (Suche)
                            └── Phase 7 (Chat)
                                    └── Phase 8 (Historie)
                                            └── Phase 9 (Deep Links + A11y)
                                                    └── Phase 10 (PWA + i18n)
```

---

## Ergänzte Anforderungen (Zusammenfassung)

Diese Anforderungen fehlten in der ursprünglichen Liste und wurden hinzugefügt:

| # | Anforderung | Begründung |
|---|---|---|
| 1 | **CI/CD-Pipeline** | Ohne automatisierte Checks keine stabile Codebasis im Team |
| 2 | **Design System / Shared Components** | "Standard-Komponenten tbd" konkretisiert — muss vor Feature-Pages stehen |
| 3 | **Dark Mode / Theme-Toggle** | Erwartet von Nutzern, fehlt im Design-Konzept |
| 4 | **Dependency Injection Setup** | get_it/injectable als explizite Task, da alles davon abhängt |
| 5 | **OAuth-Flows für externe Dienste** | Jeder der 5 Dienste braucht einen eigenen OAuth-Flow — nicht trivial |
| 6 | **Suche** | Kernfunktion eines "Second Brain" (Wiederfinden!) — komplett vergessen |
| 7 | **Offline- / Connectivity-Handling** | Externes API + Keycloak schlagen ohne Netz fehl — UX-Gap |
| 8 | **Toast / Notification-System** | Action-Feedback (Save, Delete, Error) fehlt als Konzept |
| 9 | **Manuelles Override für Zielsystem** | Quick Capture automatisch ist gut, aber Nutzer braucht Override-Option |
| 10 | **PWA-Support** | Web ist primär — Installierbarkeit und manifest.json fehlen |

---

## Offene Entscheidungen (TBD)

| Thema | Optionen | Status |
|---|---|---|
| Kalender-Anbindung | Google Calendar OAuth2 vs. CalDAV | Offen |
| Streaming-Protokoll Chat | SSE vs. WebSocket | Offen |
| Suche: lokal vs. serverseitig | Client-seitige Aggregation vs. Backend-Suche | Offen |
| Pagination-Parameter Historie | Cursor-based vs. Offset | Abstimmen mit Backend |
| Obsidian-Anbindung | Local REST Plugin URL konfigurierbar? Oder fest? | Offen |
| E2E-Test-Framework | Playwright (Web) vs. Flutter `integration_test` | Offen |
