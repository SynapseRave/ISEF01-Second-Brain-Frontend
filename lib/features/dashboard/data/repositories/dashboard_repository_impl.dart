import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/entities/dashboard_item.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/repositories/dashboard_repository.dart';

/// Konvertiert API-Exceptions in Failure-Typen.
/// TODO(phase-5): Datasource injizieren, echte Daten laden.
class DashboardRepositoryImpl implements DashboardRepository {
  @override
  Future<({List<DashboardItem> items, Failure? failure})>
      getDashboardItems() async => (items: <DashboardItem>[], failure: null);
}
