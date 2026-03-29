import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/entities/service_connection.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/repositories/settings_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  @override
  Future<List<ServiceConnection>> getConnections() async => ServiceType.values
      .map(
        (s) => ServiceConnection(
          service: s,
          status: ConnectionStatus.disconnected,
        ),
      )
      .toList();

  @override
  Future<Failure?> connect(ServiceType service) async => null; // TODO(phase-4)

  @override
  Future<Failure?> disconnect(ServiceType service) async => null;
}
