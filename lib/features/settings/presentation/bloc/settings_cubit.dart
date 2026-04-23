import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/entities/service_connection.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/usecases/connect_service_usecase.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/usecases/disconnect_service_usecase.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/repositories/settings_repository.dart';
import 'package:isef01_second_brain_frontend/features/settings/presentation/bloc/settings_state.dart';

@lazySingleton
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(
    this._repository,
    this._connect,
    this._disconnect,
  ) : super(const SettingsInitial());

  final SettingsRepository _repository;
  final ConnectServiceUseCase _connect;
  final DisconnectServiceUseCase _disconnect;

  Future<void> loadConnections() async {
    emit(const SettingsLoading());
    final (connections, failure) = await _repository.getConnections();
    if (failure != null) {
      emit(SettingsError(message: failure.message));
    } else {
      emit(SettingsLoaded(connections!));
    }
  }

  Future<void> storeCredential(
    ServiceType service,
    Map<String, dynamic> credentials,
  ) async {
    final current = _currentConnections;
    emit(SettingsConnecting(connections: current, activeService: service));

    final failure = await _connect(service, credentials);
    if (failure != null) {
      emit(SettingsError(message: failure.message, connections: current));
    } else {
      await loadConnections();
    }
  }

  Future<void> deleteCredential(ServiceType service) async {
    final current = _currentConnections;
    emit(SettingsConnecting(connections: current, activeService: service));

    final failure = await _disconnect(service);
    if (failure != null) {
      emit(SettingsError(message: failure.message, connections: current));
    } else {
      await loadConnections();
    }
  }

  List<ServiceConnection> get _currentConnections => switch (state) {
    SettingsLoaded(:final connections) => connections,
    SettingsConnecting(:final connections) => connections,
    SettingsError(:final connections) => connections ?? [],
    _ => [],
  };
}
