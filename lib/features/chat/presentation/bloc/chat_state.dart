import 'package:isef01_second_brain_frontend/features/chat/domain/entities/message.dart';

class ChatState {
  const ChatState({
    this.messages = const [],
    this.streamingContent = '',
    this.isStreaming = false,
    this.statusMessage,
    this.error,
    this.conversationId,
  });

  final List<Message> messages;
  final String streamingContent;
  final bool isStreaming;
  final String? statusMessage;
  final String? error;
  final String? conversationId;

  ChatState copyWith({
    List<Message>? messages,
    String? streamingContent,
    bool? isStreaming,
    String? statusMessage,
    String? error,
    String? conversationId,
    bool clearStatus = false,
    bool clearError = false,
    bool clearStreaming = false,
  }) =>
      ChatState(
        messages: messages ?? this.messages,
        streamingContent: clearStreaming ? '' : (streamingContent ?? this.streamingContent),
        isStreaming: isStreaming ?? this.isStreaming,
        statusMessage: clearStatus ? null : (statusMessage ?? this.statusMessage),
        error: clearError ? null : (error ?? this.error),
        conversationId: conversationId ?? this.conversationId,
      );
}
