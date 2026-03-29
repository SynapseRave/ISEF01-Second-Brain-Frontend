import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/entities/service_connection.dart';

abstract interface class SettingsRepository {
  Future<List<ServiceConnection>> getConnections();
  Future<Failure?> connect(ServiceType service);
  Future<Failure?> disconnect(ServiceType service);
}
