import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/entities/paginated_history.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/repositories/history_repository.dart';

class GetHistoryUseCase {
  const GetHistoryUseCase(this._repository);
  final HistoryRepository _repository;

  Future<(PaginatedHistory?, Failure?)> call({int page = 1}) =>
      _repository.getHistory(page: page);
}
