import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/features/chat/data/models/sse_event_model.dart';
import 'package:isef01_second_brain_frontend/features/chat/domain/entities/message.dart';
import 'package:isef01_second_brain_frontend/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:isef01_second_brain_frontend/features/chat/presentation/bloc/chat_state.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/entities/history_entry.dart';

String _newUuid() {
  final rng = Random.secure();
  final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
      '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
}

@injectable
class ChatCubit extends Cubit<ChatState> {
  ChatCubit(this._sendMessage) : super(const ChatState());

  final SendMessageUseCase _sendMessage;
  StreamSubscription<SseEvent>? _subscription;

  Future<void> sendMessage(String prompt) async {
    if (state.isStreaming || prompt.trim().isEmpty) return;

    // Ensure a conversation ID exists for the whole session
    final conversationId = state.conversationId ?? _newUuid();

    final userMessage = Message(
      id: _newUuid(),
      role: MessageRole.user,
      content: prompt.trim(),
      createdAt: DateTime.now(),
    );

    emit(
      state.copyWith(
        messages: [...state.messages, userMessage],
        isStreaming: true,
        conversationId: conversationId,
        clearError: true,
        clearStatus: true,
        clearStreaming: true,
      ),
    );

    await _subscription?.cancel();
    _subscription = _sendMessage(
      prompt,
      conversationId: conversationId,
    ).listen(_onEvent, onError: (_) => _onStreamError(), onDone: _onStreamDone);
  }

  void _onEvent(SseEvent event) {
    switch (event) {
      case SseChunkEvent(:final text):
        // Einzelner gestreamter Token → live aufaddieren.
        emit(
          state.copyWith(
            streamingContent: state.streamingContent + text,
            clearStatus: true,
          ),
        );
      case SseStatusEvent(:final message):
        emit(state.copyWith(statusMessage: message));
      case SseResultEvent(:final response):
        // Nur als Fallback nutzen wenn kein Chunk-Streaming stattfand,
        // damit der vollständige Text nicht doppelt erscheint.
        if (state.streamingContent.isNotEmpty) break;
        emit(state.copyWith(streamingContent: response, clearStatus: true));
      case SseDoneEvent():
        _finalizeAssistantMessage();
      case SseErrorEvent(:final message):
        emit(
          state.copyWith(
            isStreaming: false,
            error: message,
            clearStatus: true,
            clearStreaming: true,
          ),
        );
    }
  }

  void _finalizeAssistantMessage() {
    if (state.streamingContent.isEmpty) {
      emit(state.copyWith(isStreaming: false, clearStatus: true));
      return;
    }
    final assistantMessage = Message(
      id: _newUuid(),
      role: MessageRole.assistant,
      content: state.streamingContent,
      createdAt: DateTime.now(),
    );
    emit(
      state.copyWith(
        messages: [...state.messages, assistantMessage],
        isStreaming: false,
        clearStatus: true,
        clearStreaming: true,
      ),
    );
  }

  void _onStreamDone() {
    if (state.isStreaming) _finalizeAssistantMessage();
  }

  void _onStreamError() {
    emit(
      state.copyWith(
        isStreaming: false,
        error: 'Verbindungsfehler beim Streaming.',
        clearStatus: true,
        clearStreaming: true,
      ),
    );
  }

  void loadConversation(String conversationId, List<HistoryEntry> entries) {
    _subscription?.cancel();
    final messages = entries
        .expand<Message>(
          (e) => [
            Message(
              id: e.id.toString(),
              role: MessageRole.user,
              content: e.prompt,
              createdAt: e.createdAt,
            ),
            if (e.response != null)
              Message(
                id: '${e.id}_r',
                role: MessageRole.assistant,
                content: e.response!,
                createdAt: e.createdAt,
              ),
          ],
        )
        .toList();
    emit(ChatState(messages: messages, conversationId: conversationId));
  }

  void startNewConversation() {
    _subscription?.cancel();
    emit(const ChatState());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
