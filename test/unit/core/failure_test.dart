import 'package:flutter_test/flutter_test.dart';
import 'package:isef01_second_brain_frontend/core/error/failure.dart';

// Unit Tests prüfen eine einzelne Klasse oder Funktion isoliert —
// kein Netzwerk, kein Flutter-Framework, keine Datenbank.
// Sie sind schnell (< 1 ms) und laufen ohne laufende App.
void main() {
  group('Failure', () {
    test('NetworkFailure hat Default-Nachricht', () {
      const failure = NetworkFailure();
      expect(failure.message, 'Keine Netzwerkverbindung.');
    });

    test('Failure-Typen sind unterscheidbar per switch', () {
      const Failure failure = AuthFailure();

      final result = switch (failure) {
        NetworkFailure() => 'network',
        AuthFailure() => 'auth',
        ServerFailure() => 'server',
        NotFoundFailure() => 'not_found',
        ValidationFailure() => 'validation',
      };

      expect(result, 'auth');
    });
  });
}
