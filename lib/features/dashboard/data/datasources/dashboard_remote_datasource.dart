import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/data/models/dashboard_response_model.dart';

abstract interface class DashboardRemoteDatasource {
  Future<DashboardResponseModel> getDashboard();
}

@LazySingleton(as: DashboardRemoteDatasource)
class DashboardRemoteDatasourceImpl implements DashboardRemoteDatasource {
  const DashboardRemoteDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<DashboardResponseModel> getDashboard() async {
    final response = await _dio.get<Map<String, dynamic>>('/api/dashboard/');
    return DashboardResponseModel.fromJson(response.data!);
  }
}
