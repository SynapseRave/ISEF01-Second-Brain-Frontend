import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/entities/service_connection.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/repositories/settings_repository.dart';

class ConnectServiceUseCase {
  const ConnectServiceUseCase(this._repository);
  final SettingsRepository _repository;

  Future<Failure?> call(ServiceType service) => _repository.connect(service);
}
