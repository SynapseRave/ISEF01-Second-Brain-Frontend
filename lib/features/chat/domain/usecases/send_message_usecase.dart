import 'package:isef01_second_brain_frontend/features/chat/domain/repositories/chat_repository.dart';

class SendMessageUseCase {
  const SendMessageUseCase(this._repository);
  final ChatRepository _repository;

  Stream<String> call(String content) => _repository.sendMessage(content);
}
