import 'dart:async';

import 'package:flutter/foundation.dart';

/// Wandelt einen Stream in ein [ChangeNotifier]-kompatibles [Listenable] um.
/// GoRouter nutzt [refreshListenable] um den redirect-Callback neu auszuführen
/// wenn sich der Auth-State ändert.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
