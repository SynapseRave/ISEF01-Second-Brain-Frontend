import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/entities/history_entry.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/repositories/history_repository.dart';

class GetHistoryUseCase {
  const GetHistoryUseCase(this._repository);
  final HistoryRepository _repository;

  Future<({List<HistoryEntry> entries, Failure? failure})> call({
    int page = 1,
  }) => _repository.getHistory(page: page);
}
