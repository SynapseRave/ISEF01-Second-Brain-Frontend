import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/features/history/data/models/history_entry_model.dart';

abstract interface class HistoryRemoteDatasource {
  Future<PaginatedHistoryModel> listInputs({int page = 1, int pageSize = 20});
  Future<void> deleteInput(int id);
}

@LazySingleton(as: HistoryRemoteDatasource)
class HistoryRemoteDatasourceImpl implements HistoryRemoteDatasource {
  const HistoryRemoteDatasourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<PaginatedHistoryModel> listInputs({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/api/input/',
      queryParameters: {'page': page, 'page_size': pageSize},
    );
    return PaginatedHistoryModel.fromJson(response.data!);
  }

  @override
  Future<void> deleteInput(int id) async {
    await _dio.delete<void>('/api/input/$id');
  }
}
