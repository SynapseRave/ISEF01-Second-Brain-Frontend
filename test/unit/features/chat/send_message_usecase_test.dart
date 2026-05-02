import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:isef01_second_brain_frontend/features/chat/data/models/sse_event_model.dart';
import 'package:isef01_second_brain_frontend/features/chat/domain/repositories/chat_repository.dart';
import 'package:isef01_second_brain_frontend/features/chat/domain/usecases/send_message_usecase.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late SendMessageUseCase useCase;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    useCase = SendMessageUseCase(mockRepository);
  });

  group('SendMessageUseCase', () {
    test('delegiert an Repository und gibt Stream zurück', () {
      final tEvents = [
        const SseChunkEvent('Hallo'),
        const SseDoneEvent(1),
      ];
      when(
        () => mockRepository.sendMessage(any(), conversationId: any(named: 'conversationId')),
      ).thenAnswer((_) => Stream.fromIterable(tEvents));

      final stream = useCase('Hallo Welt', conversationId: 'conv-1');

      expect(stream, emitsInOrder([isA<SseChunkEvent>(), isA<SseDoneEvent>()]));
      verify(
        () => mockRepository.sendMessage('Hallo Welt', conversationId: 'conv-1'),
      ).called(1);
    });

    test('ohne conversationId wird null weitergegeben', () {
      when(
        () => mockRepository.sendMessage(any(), conversationId: any(named: 'conversationId')),
      ).thenAnswer((_) => const Stream.empty());

      useCase('prompt');

      verify(
        () => mockRepository.sendMessage('prompt', conversationId: null),
      ).called(1);
    });
  });
}
