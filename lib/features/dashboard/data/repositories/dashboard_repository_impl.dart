import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/repositories/dashboard_repository.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl(this._datasource);

  final DashboardRemoteDatasource _datasource;

  @override
  Future<({DashboardData? data, Failure? failure})> getDashboard() async {
    try {
      final model = await _datasource.getDashboard();
      final data = DashboardData(
        nextEvent: model.nextEvent?.toEntity(),
        todos: model.todos.map((t) => t.toEntity()).toList(),
        lastNote: model.lastNote?.toEntity(),
      );
      return (data: data, failure: null);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return (data: null, failure: const AuthFailure());
      }
      return (data: null, failure: ServerFailure(e.message ?? 'Serverfehler.'));
    } catch (_) {
      return (data: null, failure: const ServerFailure());
    }
  }
}
