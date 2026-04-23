import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/core/api/dio_error_mapper.dart';
import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/settings/data/datasources/settings_remote_datasource.dart';
import 'package:isef01_second_brain_frontend/features/settings/data/models/service_connection_model.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/entities/service_connection.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/repositories/settings_repository.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl(this._datasource);

  final SettingsRemoteDatasource _datasource;

  @override
  Future<(List<ServiceConnection>?, Failure?)> getConnections() async {
    try {
      final models = await _datasource.listCredentials();
      return (models.map((m) => m.toEntity()).toList(), null);
    } on DioException catch (e) {
      return (null, mapDioException(e));
    } catch (_) {
      return (null, const ServerFailure());
    }
  }

  @override
  Future<Failure?> storeCredential(
    ServiceType service,
    Map<String, dynamic> credentials,
  ) async {
    try {
      final serviceStr = serviceTypeToString(service);
      await _datasource.storeCredential(serviceStr, credentials);
      return null;
    } on DioException catch (e) {
      // 409: already exists — fall back to update
      if (e.response?.statusCode == 409) {
        return updateCredential(service, credentials);
      }
      return mapDioException(e);
    } catch (_) {
      return const ServerFailure();
    }
  }

  @override
  Future<Failure?> updateCredential(
    ServiceType service,
    Map<String, dynamic> credentials,
  ) async {
    try {
      await _datasource.updateCredential(serviceTypeToString(service), credentials);
      return null;
    } on DioException catch (e) {
      return mapDioException(e);
    } catch (_) {
      return const ServerFailure();
    }
  }

  @override
  Future<Failure?> deleteCredential(ServiceType service) async {
    try {
      await _datasource.deleteCredential(serviceTypeToString(service));
      return null;
    } on DioException catch (e) {
      return mapDioException(e);
    } catch (_) {
      return const ServerFailure();
    }
  }
}
