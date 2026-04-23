import 'package:isef01_second_brain_frontend/features/history/domain/entities/history_entry.dart';

sealed class HistoryState {
  const HistoryState();
}

final class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

final class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

final class HistoryLoaded extends HistoryState {
  const HistoryLoaded({
    required this.entries,
    required this.currentPage,
    required this.totalPages,
    this.isLoadingMore = false,
  });

  final List<HistoryEntry> entries;
  final int currentPage;
  final int totalPages;
  final bool isLoadingMore;

  bool get hasMore => currentPage < totalPages;

  HistoryLoaded copyWith({
    List<HistoryEntry>? entries,
    int? currentPage,
    int? totalPages,
    bool? isLoadingMore,
  }) =>
      HistoryLoaded(
        entries: entries ?? this.entries,
        currentPage: currentPage ?? this.currentPage,
        totalPages: totalPages ?? this.totalPages,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}

final class HistoryError extends HistoryState {
  const HistoryError(this.message);
  final String message;
}
