enum MessageRole { user, assistant }

class Message {
  const Message({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });
  final String id;
  final MessageRole role;
  final String content;
  final DateTime createdAt;
}
