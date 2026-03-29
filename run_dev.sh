#!/bin/sh
# Startet die App im Dev-Modus mit lokalen Umgebungsvariablen.
#
# Verwendung:
#   chmod +x run_dev.sh   (einmalig, nur auf Unix/Mac nötig)
#   ./run_dev.sh
#
# Werte hier anpassen wenn lokale Ports abweichen.

flutter run -d chrome \
  --dart-define=API_BASE_URL=http://localhost:8080 \
  --dart-define=KEYCLOAK_URL=http://localhost:8180 \
  --dart-define=KEYCLOAK_REALM=second-brain \
  --dart-define=KEYCLOAK_CLIENT_ID=frontend
