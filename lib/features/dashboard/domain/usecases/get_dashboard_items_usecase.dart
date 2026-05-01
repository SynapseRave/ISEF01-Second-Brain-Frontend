import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetDashboardItemsUseCase {
  const GetDashboardItemsUseCase(this._repository);

  final DashboardRepository _repository;

  Future<({DashboardData? data, Failure? failure})> call() =>
      _repository.getDashboard();
}
