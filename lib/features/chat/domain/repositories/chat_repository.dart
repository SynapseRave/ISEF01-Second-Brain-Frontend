import 'package:isef01_second_brain_frontend/core/error/failure.dart';

abstract interface class ChatRepository {
  /// Sendet eine Nachricht und streamt die Antwort token-by-token.
  Stream<String> sendMessage(String content);
  Future<Failure?> clearHistory();
}
