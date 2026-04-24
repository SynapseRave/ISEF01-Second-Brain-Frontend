import 'package:isef01_second_brain_frontend/features/chat/data/models/sse_event_model.dart';

abstract interface class ChatRepository {
  /// Sendet einen Prompt und streamt die Backend-Antwort als SSE-Events.
  Stream<SseEvent> sendMessage(String prompt, {String? conversationId});
}
