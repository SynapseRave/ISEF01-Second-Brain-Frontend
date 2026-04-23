import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/entities/paginated_history.dart';

abstract interface class HistoryRepository {
  Future<(PaginatedHistory?, Failure?)> getHistory({
    int page = 1,
    int pageSize = 20,
  });

  Future<Failure?> deleteEntry(int id);
}
