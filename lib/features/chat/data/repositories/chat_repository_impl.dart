import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:isef01_second_brain_frontend/features/chat/data/models/sse_event_model.dart';
import 'package:isef01_second_brain_frontend/features/chat/domain/repositories/chat_repository.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this._datasource);

  final ChatRemoteDatasource _datasource;

  @override
  Stream<SseEvent> sendMessage(String prompt, {String? conversationId}) =>
      _datasource.sendMessage(prompt, conversationId: conversationId);
}
