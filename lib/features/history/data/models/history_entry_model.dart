import 'package:isef01_second_brain_frontend/features/history/domain/entities/history_entry.dart';

class HistoryEntryModel {
  const HistoryEntryModel({
    required this.id,
    required this.input,
    required this.response,
    required this.createdAt,
  });

  factory HistoryEntryModel.fromJson(Map<String, dynamic> json) =>
      HistoryEntryModel(
        id: json['id'] as String,
        input: json['input'] as String,
        response: json['response'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  final String id;
  final String input;
  final String response;
  final DateTime createdAt;

  HistoryEntry toEntity() => HistoryEntry(
    id: id,
    input: input,
    response: response,
    createdAt: createdAt,
  );
}
