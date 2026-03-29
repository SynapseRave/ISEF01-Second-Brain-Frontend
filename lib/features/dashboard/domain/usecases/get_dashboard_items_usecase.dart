import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/entities/dashboard_item.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/repositories/dashboard_repository.dart';

/// Ein Use Case = eine fachliche Aktion.
class GetDashboardItemsUseCase {
  const GetDashboardItemsUseCase(this._repository);
  final DashboardRepository _repository;

  Future<({List<DashboardItem> items, Failure? failure})> call() =>
      _repository.getDashboardItems();
}
