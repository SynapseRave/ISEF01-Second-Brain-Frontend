import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/features/settings/data/models/service_connection_model.dart';

abstract interface class SettingsRemoteDatasource {
  Future<List<ServiceConnectionModel>> listCredentials();

  Future<ServiceConnectionModel> storeCredential(
    String service,
    Map<String, dynamic> credentials,
  );

  Future<ServiceConnectionModel> updateCredential(
    String service,
    Map<String, dynamic> credentials,
  );

  Future<void> deleteCredential(String service);
}

@LazySingleton(as: SettingsRemoteDatasource)
class SettingsRemoteDatasourceImpl implements SettingsRemoteDatasource {
  const SettingsRemoteDatasourceImpl(this._dio);

  final Dio _dio;

  static const _base = '/api/credential/applications';

  @override
  Future<List<ServiceConnectionModel>> listCredentials() async {
    final response = await _dio.get<List<dynamic>>('$_base/');
    return response.data!
        .map((e) => ServiceConnectionModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ServiceConnectionModel> storeCredential(
    String service,
    Map<String, dynamic> credentials,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_base/',
      data: {'service': service, 'credentials': credentials},
    );
    return ServiceConnectionModel.fromJson(response.data!);
  }

  @override
  Future<ServiceConnectionModel> updateCredential(
    String service,
    Map<String, dynamic> credentials,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '$_base/$service',
      data: {'credentials': credentials},
    );
    return ServiceConnectionModel.fromJson(response.data!);
  }

  @override
  Future<void> deleteCredential(String service) async {
    await _dio.delete<void>('$_base/$service');
  }
}
