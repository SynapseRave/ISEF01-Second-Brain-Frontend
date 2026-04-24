import 'package:isef01_second_brain_frontend/features/settings/domain/entities/service_connection.dart';

sealed class SettingsState {
  const SettingsState();
}

final class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

final class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

final class SettingsLoaded extends SettingsState {
  const SettingsLoaded(this.connections);
  final List<ServiceConnection> connections;
}

final class SettingsConnecting extends SettingsState {
  const SettingsConnecting({
    required this.connections,
    required this.activeService,
  });
  final List<ServiceConnection> connections;
  final ServiceType activeService;
}

final class SettingsError extends SettingsState {
  const SettingsError({required this.message, this.connections});
  final String message;
  final List<ServiceConnection>? connections;
}
