import 'package:web/web.dart' as web;

void clearCallbackUrl() {
  web.window.history.replaceState(null, '', '/');
}
