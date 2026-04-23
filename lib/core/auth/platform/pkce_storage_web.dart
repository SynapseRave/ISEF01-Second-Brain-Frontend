import 'package:web/web.dart' as web;

// localStorage statt sessionStorage: sessionStorage überlebt Cross-Origin-
// Redirects (localhost:3000 → Keycloak → localhost:3000) in manchen Chrome-
// Konfigurationen nicht zuverlässig. localStorage persistiert sicher über
// den Redirect hinweg. Der Verifier wird nach dem Token-Austausch sofort
// gelöscht, daher kein dauerhaftes Sicherheitsrisiko.
void pkceWrite(String key, String value) =>
    web.window.localStorage.setItem(key, value);

String? pkceRead(String key) {
  final value = web.window.localStorage.getItem(key);
  return value == null || value.isEmpty ? null : value;
}

void pkceDelete(String key) => web.window.localStorage.removeItem(key);
