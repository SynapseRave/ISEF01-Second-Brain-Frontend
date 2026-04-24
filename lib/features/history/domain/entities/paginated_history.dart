import 'package:isef01_second_brain_frontend/features/history/domain/entities/history_entry.dart';

class PaginatedHistory {
  const PaginatedHistory({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.pages,
  });

  final List<HistoryEntry> items;
  final int total;
  final int page;
  final int pageSize;
  final int pages;

  bool get hasMore => page < pages;
}
