import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/core/error/failure.dart';
import 'package:isef01_second_brain_frontend/features/settings/data/oauth/google_calendar_oauth_connector.dart';
import 'package:isef01_second_brain_frontend/features/settings/data/oauth/onenote_oauth_connector.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/entities/service_connection.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/repositories/settings_repository.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/usecases/connect_service_usecase.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/usecases/disconnect_service_usecase.dart';
import 'package:isef01_second_brain_frontend/features/settings/presentation/bloc/settings_state.dart';

@lazySingleton
class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(
    this._repository,
    this._connect,
    this._disconnect,
    this._googleCalendarConnector,
    this._oneNoteConnector,
  ) : super(const SettingsInitial());

  final SettingsRepository _repository;
  final ConnectServiceUseCase _connect;
  final DisconnectServiceUseCase _disconnect;
  final GoogleCalendarOAuthConnector _googleCalendarConnector;
  final OneNoteOAuthConnector _oneNoteConnector;

  Future<void> loadConnections() async {
    emit(const SettingsLoading());
    final (connections, failure) = await _repository.getConnections();
    if (failure != null) {
      emit(SettingsError(message: failure.message));
    } else {
      emit(SettingsLoaded(connections!));
    }
  }

  Future<Failure?> storeCredential(
    ServiceType service,
    Map<String, dynamic> credentials,
  ) async {
    final current = _currentConnections;
    emit(SettingsConnecting(connections: current, activeService: service));

    final failure = await _connect(service, credentials);
    if (failure != null) {
      emit(SettingsError(message: failure.message, connections: current));
      return failure;
    }

    await loadConnections();
    return null;
  }

  Future<Failure?> startConnection(ServiceType service) async {
    final current = _currentConnections;
    emit(SettingsConnecting(connections: current, activeService: service));

    final failure = await switch (service) {
      ServiceType.googleCalendar => _googleCalendarConnector.start(),
      ServiceType.oneNote => _oneNoteConnector.start(),
      _ => Future.value(
        const ValidationFailure(
          'Fuer diesen Dienst ist noch kein Connect-Flow verfuegbar.',
        ),
      ),
    };

    if (failure != null) {
      emit(SettingsError(message: failure.message, connections: current));
    }
    return failure;
  }

  Future<Failure?> completeConnectionCallback(
    ServiceType service,
    Uri callbackUri,
  ) async {
    final current = _currentConnections;
    emit(SettingsConnecting(connections: current, activeService: service));

    switch (service) {
      case ServiceType.googleCalendar:
        final oauthFailure = await _googleCalendarConnector.complete(
          callbackUri,
        );
        if (oauthFailure != null) {
          emit(
            SettingsError(message: oauthFailure.message, connections: current),
          );
          return oauthFailure;
        }
      case ServiceType.oneNote:
        final (bundle, oauthFailure) = await _oneNoteConnector.complete(
          callbackUri,
        );
        if (oauthFailure != null) {
          emit(
            SettingsError(message: oauthFailure.message, connections: current),
          );
          return oauthFailure;
        }
        final storeFailure = await _connect(service, bundle!.toJson());
        if (storeFailure != null) {
          emit(
            SettingsError(message: storeFailure.message, connections: current),
          );
          return storeFailure;
        }
      default:
        const failure = ValidationFailure(
          'Fuer diesen Dienst ist noch kein Connect-Flow verfuegbar.',
        );
        emit(SettingsError(message: failure.message, connections: current));
        return failure;
    }

    await loadConnections();
    return null;
  }

  Future<Failure?> deleteCredential(ServiceType service) async {
    final current = _currentConnections;
    emit(SettingsConnecting(connections: current, activeService: service));

    final failure = await _disconnect(service);
    if (failure != null) {
      emit(SettingsError(message: failure.message, connections: current));
      return failure;
    }

    await loadConnections();
    return null;
  }

  List<ServiceConnection> get _currentConnections => switch (state) {
    SettingsLoaded(:final connections) => connections,
    SettingsConnecting(:final connections) => connections,
    SettingsError(:final connections) => connections ?? [],
    _ => [],
  };
}
