import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/entities/dashboard_item.dart';

/// Interface: Der Cubit kennt nur dieses, nie die konkrete Impl.
abstract interface class DashboardRepository {
  Future<({List<DashboardItem> items, Failure? failure})> getDashboardItems();
}
