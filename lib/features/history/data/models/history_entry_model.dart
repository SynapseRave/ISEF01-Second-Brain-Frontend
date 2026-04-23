import 'package:isef01_second_brain_frontend/features/history/domain/entities/history_entry.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/entities/paginated_history.dart';

class HistoryEntryModel {
  const HistoryEntryModel({
    required this.id,
    required this.prompt,
    required this.conversationId,
    required this.createdAt,
    this.response,
    this.tool,
    this.model,
  });

  factory HistoryEntryModel.fromJson(Map<String, dynamic> json) =>
      HistoryEntryModel(
        id: json['id'] as int,
        prompt: json['prompt'] as String,
        response: json['response'] as String?,
        conversationId: json['conversation_id'] as String,
        tool: json['tool'] as String?,
        model: json['model'] as String?,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  final int id;
  final String prompt;
  final String? response;
  final String conversationId;
  final String? tool;
  final String? model;
  final DateTime createdAt;

  HistoryEntry toEntity() => HistoryEntry(
    id: id,
    prompt: prompt,
    response: response,
    conversationId: conversationId,
    tool: tool,
    model: model,
    createdAt: createdAt,
  );
}

class PaginatedHistoryModel {
  const PaginatedHistoryModel({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.pages,
  });

  factory PaginatedHistoryModel.fromJson(Map<String, dynamic> json) =>
      PaginatedHistoryModel(
        items: (json['items'] as List<dynamic>)
            .map((e) => HistoryEntryModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        total: json['total'] as int,
        page: json['page'] as int,
        pageSize: json['page_size'] as int,
        pages: json['pages'] as int,
      );

  final List<HistoryEntryModel> items;
  final int total;
  final int page;
  final int pageSize;
  final int pages;

  PaginatedHistory toEntity() => PaginatedHistory(
    items: items.map((m) => m.toEntity()).toList(),
    total: total,
    page: page,
    pageSize: pageSize,
    pages: pages,
  );
}
