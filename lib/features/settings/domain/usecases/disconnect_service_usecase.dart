import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/entities/service_connection.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/repositories/settings_repository.dart';

@lazySingleton
class DisconnectServiceUseCase {
  const DisconnectServiceUseCase(this._repository);

  final SettingsRepository _repository;

  Future<Failure?> call(ServiceType service) =>
      _repository.deleteCredential(service);
}
