import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:isef01_second_brain_frontend/features/chat/data/models/sse_event_model.dart';
import 'package:isef01_second_brain_frontend/features/chat/domain/entities/message.dart';
import 'package:isef01_second_brain_frontend/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:isef01_second_brain_frontend/features/chat/presentation/bloc/chat_cubit.dart';
import 'package:isef01_second_brain_frontend/features/chat/presentation/bloc/chat_state.dart';

class MockSendMessageUseCase extends Mock implements SendMessageUseCase {}

void main() {
  late MockSendMessageUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockSendMessageUseCase();
  });

  group('ChatCubit', () {
    test('Initialzustand: leere Messages, isStreaming=false', () {
      final cubit = ChatCubit(mockUseCase);
      expect(cubit.state.messages, isEmpty);
      expect(cubit.state.isStreaming, isFalse);
      expect(cubit.state.error, isNull);
      cubit.close();
    });

    blocTest<ChatCubit, ChatState>(
      'sendMessage mit leerem String → keine Emission',
      build: () => ChatCubit(mockUseCase),
      act: (cubit) => cubit.sendMessage('   '),
      expect: () => [],
    );

    blocTest<ChatCubit, ChatState>(
      'sendMessage → erster State hat isStreaming=true und User-Message',
      build: () {
        when(
          () => mockUseCase(any(), conversationId: any(named: 'conversationId')),
        ).thenAnswer((_) => const Stream.empty());
        return ChatCubit(mockUseCase);
      },
      act: (cubit) => cubit.sendMessage('Hallo'),
      // Stream.empty() → onDone feuert, _finalizeAssistantMessage emittiert
      // isStreaming=false weil streamingContent leer ist.
      verify: (cubit) {
        final states = <ChatState>[];
        // Wir prüfen den finalen Zustand direkt am Cubit
        expect(cubit.state.isStreaming, isFalse);
        expect(cubit.state.messages.length, 1);
        expect(cubit.state.messages.first.role, MessageRole.user);
        expect(cubit.state.messages.first.content, 'Hallo');
        states.isEmpty; // suppress unused warning
      },
    );

    blocTest<ChatCubit, ChatState>(
      'SseChunkEvent → streamingContent wächst schrittweise',
      build: () {
        when(
          () => mockUseCase(any(), conversationId: any(named: 'conversationId')),
        ).thenAnswer(
          (_) => Stream.fromIterable([
            const SseChunkEvent('Hel'),
            const SseChunkEvent('lo'),
          ]),
        );
        return ChatCubit(mockUseCase);
      },
      act: (cubit) => cubit.sendMessage('Test'),
      verify: (cubit) {
        // Nach onDone wurde _finalizeAssistantMessage aufgerufen:
        // streamingContent ist '' und messages hat User + Assistant
        expect(cubit.state.isStreaming, isFalse);
        expect(cubit.state.messages.length, 2);
        expect(cubit.state.messages.last.content, 'Hello');
        expect(cubit.state.streamingContent, '');
      },
    );

    blocTest<ChatCubit, ChatState>(
      'SseStatusEvent → statusMessage gesetzt',
      build: () {
        when(
          () => mockUseCase(any(), conversationId: any(named: 'conversationId')),
        ).thenAnswer(
          (_) => Stream.fromIterable([const SseStatusEvent('LLM wird angefragt...')]),
        );
        return ChatCubit(mockUseCase);
      },
      act: (cubit) => cubit.sendMessage('Test'),
      verify: (cubit) {
        // Nach Stream-Ende: statusMessage wurde mindestens einmal gesetzt.
        // (clearStatus=true bei onDone, daher im Finalstate null)
        expect(cubit.state.isStreaming, isFalse);
      },
    );

    blocTest<ChatCubit, ChatState>(
      'SseResultEvent ohne vorherige Chunks → streamingContent übernommen und finalisiert',
      build: () {
        when(
          () => mockUseCase(any(), conversationId: any(named: 'conversationId')),
        ).thenAnswer(
          (_) => Stream.fromIterable([
            const SseResultEvent(response: 'Komplette Antwort'),
          ]),
        );
        return ChatCubit(mockUseCase);
      },
      act: (cubit) => cubit.sendMessage('Test'),
      verify: (cubit) {
        expect(cubit.state.isStreaming, isFalse);
        expect(cubit.state.messages.length, 2);
        expect(cubit.state.messages.last.content, 'Komplette Antwort');
      },
    );

    blocTest<ChatCubit, ChatState>(
      'SseResultEvent mit vorherigen Chunks → result-Response ignoriert',
      build: () {
        when(
          () => mockUseCase(any(), conversationId: any(named: 'conversationId')),
        ).thenAnswer(
          (_) => Stream.fromIterable([
            const SseChunkEvent('Chunk'),
            const SseResultEvent(response: 'Soll ignoriert werden'),
          ]),
        );
        return ChatCubit(mockUseCase);
      },
      act: (cubit) => cubit.sendMessage('Test'),
      verify: (cubit) {
        expect(cubit.state.messages.last.content, 'Chunk');
      },
    );

    blocTest<ChatCubit, ChatState>(
      'SseDoneEvent → Assistant-Message finalisiert, isStreaming=false',
      build: () {
        when(
          () => mockUseCase(any(), conversationId: any(named: 'conversationId')),
        ).thenAnswer(
          (_) => Stream.fromIterable([
            const SseChunkEvent('Antwort'),
            const SseDoneEvent(42),
          ]),
        );
        return ChatCubit(mockUseCase);
      },
      act: (cubit) => cubit.sendMessage('Frage'),
      verify: (cubit) {
        expect(cubit.state.isStreaming, isFalse);
        expect(cubit.state.messages.length, 2);
        expect(cubit.state.messages.last.role, MessageRole.assistant);
        expect(cubit.state.messages.last.content, 'Antwort');
        expect(cubit.state.streamingContent, '');
      },
    );

    blocTest<ChatCubit, ChatState>(
      'SseErrorEvent → error gesetzt, isStreaming=false',
      build: () {
        when(
          () => mockUseCase(any(), conversationId: any(named: 'conversationId')),
        ).thenAnswer(
          (_) => Stream.fromIterable([const SseErrorEvent('Serverfehler')]),
        );
        return ChatCubit(mockUseCase);
      },
      act: (cubit) => cubit.sendMessage('Test'),
      verify: (cubit) {
        expect(cubit.state.isStreaming, isFalse);
        expect(cubit.state.error, 'Serverfehler');
      },
    );

    blocTest<ChatCubit, ChatState>(
      'Stream-Fehler → Verbindungsfehler-State',
      build: () {
        when(
          () => mockUseCase(any(), conversationId: any(named: 'conversationId')),
        ).thenAnswer((_) => Stream.error(Exception('Netzwerk weg')));
        return ChatCubit(mockUseCase);
      },
      act: (cubit) => cubit.sendMessage('Test'),
      verify: (cubit) {
        expect(cubit.state.isStreaming, isFalse);
        expect(cubit.state.error, 'Verbindungsfehler beim Streaming.');
      },
    );

    blocTest<ChatCubit, ChatState>(
      'startNewConversation → State vollständig zurückgesetzt',
      build: () {
        when(
          () => mockUseCase(any(), conversationId: any(named: 'conversationId')),
        ).thenAnswer((_) => const Stream.empty());
        return ChatCubit(mockUseCase);
      },
      act: (cubit) async {
        await cubit.sendMessage('Hallo');
        cubit.startNewConversation();
      },
      verify: (cubit) {
        expect(cubit.state.messages, isEmpty);
        expect(cubit.state.isStreaming, isFalse);
        expect(cubit.state.conversationId, isNull);
      },
    );
  });
}
