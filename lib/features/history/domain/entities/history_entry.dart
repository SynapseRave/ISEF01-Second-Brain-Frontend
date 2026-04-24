class HistoryEntry {
  const HistoryEntry({
    required this.id,
    required this.prompt,
    required this.createdAt,
    required this.conversationId,
    this.response,
    this.tool,
    this.model,
  });

  final int id;
  final String prompt;
  final String? response;
  final String conversationId;
  final String? tool;
  final String? model;
  final DateTime createdAt;
}
