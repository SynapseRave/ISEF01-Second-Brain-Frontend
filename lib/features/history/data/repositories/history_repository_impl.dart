import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/entities/history_entry.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  @override
  Future<({List<HistoryEntry> entries, Failure? failure})> getHistory({
    int page = 1,
  }) async => (entries: <HistoryEntry>[], failure: null);

  @override
  Future<Failure?> deleteEntry(String id) async => null;
}
