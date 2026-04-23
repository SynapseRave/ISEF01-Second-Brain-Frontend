import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/entities/service_connection.dart';

abstract interface class SettingsRepository {
  Future<(List<ServiceConnection>?, Failure?)> getConnections();

  Future<Failure?> storeCredential(
    ServiceType service,
    Map<String, dynamic> credentials,
  );

  Future<Failure?> updateCredential(
    ServiceType service,
    Map<String, dynamic> credentials,
  );

  Future<Failure?> deleteCredential(ServiceType service);
}
