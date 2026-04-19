import 'package:isef01_second_brain_frontend/features/chat/domain/entities/message.dart';

class MessageModel {
  const MessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json['id'] as String,
    role: json['role'] as String,
    content: json['content'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
  );

  final String id;
  final String role;
  final String content;
  final DateTime createdAt;

  Message toEntity() => Message(
    id: id,
    role: role == 'user' ? MessageRole.user : MessageRole.assistant,
    content: content,
    createdAt: createdAt,
  );
}
