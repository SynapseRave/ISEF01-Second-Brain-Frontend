# Second Brain Frontend

Flutter-basiertes Frontend für die Second Brain Multi-App-Oberfläche.

---

## Voraussetzungen

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.10
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- Chrome (für die Web-Entwicklung)

---

## Lokale Entwicklung starten

### 1. Keycloak starten

```bash
docker compose up keycloak
```

Keycloak ist bereit, sobald in den Logs `Running the server in development mode` erscheint.

Admin-UI: `http://localhost:8180` (Benutzername: `admin`, Passwort: `admin`)

### 2. Test-User anlegen

Da der Realm-Export keine User enthält, muss beim **ersten Start** einmalig ein Testbenutzer angelegt werden:

1. `http://localhost:8180` öffnen und als `admin` / `admin` anmelden.
2. Oben links auf den Realm `second-brain` wechseln.
3. **Users → Add user** → Username vergeben → **Create**.
4. Tab **Credentials → Set password** → Passwort setzen → **Temporary: Off** → **Save**.

Dieser Schritt ist nur einmalig nötig. Keycloak speichert die Daten im Docker-Volume `keycloak_data`, das auch nach einem Neustart erhalten bleibt.

### 3. Flutter-App starten

```bash
flutter run -d chrome --web-port=3000
```

Die App ist danach unter `http://localhost:3000` erreichbar.

---

## Realm-Konfiguration aktualisieren

Der Realm `second-brain` wird beim **allerersten** Start aus `keycloak/realm-export.json` importiert. Wenn ihr die JSON-Datei später ändert, greift der Import nicht automatisch erneut — das Volume hat die Daten schon gespeichert.

Um die Änderungen zu übernehmen:

```bash
docker compose down -v   # löscht das keycloak_data Volume (inklusive aller User!)
docker compose up keycloak
```

Danach muss der Test-User erneut angelegt werden (siehe Schritt 2).

---

## Umgebungsvariablen

Konfiguration wird per `--dart-define` übergeben. Standardwerte für die lokale Entwicklung:

| Variable           | Default                    | Beschreibung                        |
|--------------------|----------------------------|-------------------------------------|
| `API_BASE_URL`     | `http://localhost:8080`    | Backend-URL                         |
| `KEYCLOAK_URL`     | `http://localhost:8080`    | Keycloak-Server-URL                 |
| `KEYCLOAK_REALM`   | `second-brain`             | Realm-Name                          |
| `KEYCLOAK_CLIENT_ID` | `frontend`               | Client-ID in Keycloak               |
| `REDIRECT_URI`     | `http://localhost:3000`    | OAuth2 Callback-URL nach dem Login  |
| `GOOGLE_CALENDAR_CLIENT_ID` | `""`             | OAuth Client-ID für Google Calendar |
| `GOOGLE_CALENDAR_REDIRECT_URI` | `""`          | Optional explizite Google Redirect-URI |
| `MICROSOFT_CLIENT_ID` | `""`                    | OAuth Client-ID für Microsoft       |
| `MICROSOFT_TENANT_ID` | `common`                | Microsoft Tenant oder `common`      |
| `MICROSOFT_REDIRECT_URI` | `""`                 | Optional explizite Microsoft Redirect-URI |

Beispiel mit eigenen Werten:

```bash
flutter run -d chrome --web-port=3000 \
  --dart-define=API_BASE_URL=http://mein-backend:8080
```

Wichtig fuer Web-Login mit Keycloak:

- Im Client `frontend` muessen `Valid Redirect URIs` mindestens `http://localhost:3000` und `http://localhost:3000/*` enthalten.
- Unter `Web Origins` muss `http://localhost:3000` erlaubt sein.
- Wenn Keycloak den Realm aus `keycloak/realm-export.json` bereits frueher importiert hat, greifen spaetere JSON-Aenderungen nicht automatisch. Dann den Realm neu importieren oder den Client im Keycloak-Admin-UI manuell anpassen.

Fuer Google Calendar und OneNote:

- Die Frontend-App braucht die jeweiligen OAuth-Client-IDs als `dart-define`, sonst erscheint die Meldung, dass die ID fehlt.
- Bei Docker-Deployments kommen diese Werte ueber `docker-compose.yml` in den Web-Build. Aendere sie z. B. in einer `.env`.
- Die Redirect-URIs muessen in Google Cloud bzw. Azure exakt zu den Callback-Routen passen:
  - Google: `http://localhost:3000/settings/connect/callback/google-calendar`
  - Microsoft: `http://localhost:3000/settings/connect/callback/onenote`

---

## Nützliche Befehle

```bash
# Abhängigkeiten installieren
flutter pub get

# Code-Generierung (Dependency Injection)
dart run build_runner build --delete-conflicting-outputs

# Linting
flutter analyze

# Formatierung
dart format lib/ test/

# Tests
flutter test

# Web-Build
flutter build web
```
