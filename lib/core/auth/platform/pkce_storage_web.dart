import 'package:web/web.dart' as web;

void pkceWrite(String key, String value) =>
    web.window.sessionStorage.setItem(key, value);

String? pkceRead(String key) {
  final value = web.window.sessionStorage.getItem(key);
  return value == null || value.isEmpty ? null : value;
}

void pkceDelete(String key) => web.window.sessionStorage.removeItem(key);
