/// Basis-Klasse fuer alle Fehlertypen.
/// Repositories werfen keine Exceptions an die UI — sie geben Failures zurueck.
sealed class Failure {
  const Failure(this.message);
  final String message;
}

final class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Keine Netzwerkverbindung.']);
}

final class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Nicht authentifiziert.']);
}

final class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Serverfehler.']);
}

final class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Ressource nicht gefunden.']);
}

final class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Ungueltige Eingabe.']);
}
