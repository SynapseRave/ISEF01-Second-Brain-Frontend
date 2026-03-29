import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  @override
  Stream<String> sendMessage(String content) =>
      const Stream.empty(); // TODO(phase-7)

  @override
  Future<Failure?> clearHistory() async => null;
}
