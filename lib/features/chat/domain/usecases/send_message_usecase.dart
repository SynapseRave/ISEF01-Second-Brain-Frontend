import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/features/chat/data/models/sse_event_model.dart';
import 'package:isef01_second_brain_frontend/features/chat/domain/repositories/chat_repository.dart';

@lazySingleton
class SendMessageUseCase {
  const SendMessageUseCase(this._repository);

  final ChatRepository _repository;

  Stream<SseEvent> call(String prompt, {String? conversationId}) =>
      _repository.sendMessage(prompt, conversationId: conversationId);
}
