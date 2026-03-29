class HistoryEntry {
  const HistoryEntry({
    required this.id,
    required this.input,
    required this.response,
    required this.createdAt,
  });
  final String id;
  final String input;
  final String response;
  final DateTime createdAt;
}
