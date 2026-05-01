import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/entities/dashboard_data.dart';

abstract interface class DashboardRepository {
  Future<({DashboardData? data, Failure? failure})> getDashboard();
}
