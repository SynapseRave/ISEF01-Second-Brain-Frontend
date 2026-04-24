import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/core/api/dio_error_mapper.dart';
import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/history/data/datasources/history_remote_datasource.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/entities/paginated_history.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/repositories/history_repository.dart';

@LazySingleton(as: HistoryRepository)
class HistoryRepositoryImpl implements HistoryRepository {
  const HistoryRepositoryImpl(this._datasource);

  final HistoryRemoteDatasource _datasource;

  @override
  Future<(PaginatedHistory?, Failure?)> getHistory({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final model = await _datasource.listInputs(
        page: page,
        pageSize: pageSize,
      );
      return (model.toEntity(), null);
    } on DioException catch (e) {
      return (null, mapDioException(e));
    } catch (_) {
      return (null, const ServerFailure());
    }
  }

  @override
  Future<Failure?> deleteEntry(int id) async {
    try {
      await _datasource.deleteInput(id);
      return null;
    } on DioException catch (e) {
      return mapDioException(e);
    } catch (_) {
      return const ServerFailure();
    }
  }
}
