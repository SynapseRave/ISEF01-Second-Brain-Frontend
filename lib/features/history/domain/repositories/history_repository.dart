import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/entities/history_entry.dart';

abstract interface class HistoryRepository {
  Future<({List<HistoryEntry> entries, Failure? failure})> getHistory({
    int page = 1,
  });
  Future<Failure?> deleteEntry(String id);
}
