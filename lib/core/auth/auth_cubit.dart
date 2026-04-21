import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:isef01_second_brain_frontend/core/auth/auth_repository.dart';
import 'package:isef01_second_brain_frontend/core/auth/auth_state.dart';

@lazySingleton
class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository) : super(const AuthInitial());

  final AuthRepository _authRepository;

  Timer? _refreshTimer;
  StreamSubscription<bool>? _authSubscription;

  /// Beim App-Start aufrufen. Behandelt zwei Szenarien:
  /// 1. Keycloak-Callback in der URL → Token-Austausch abschließen.
  /// 2. Kein Callback → bestehende Session via Refresh Token wiederherstellen.
  Future<void> initialize() async {
    emit(const AuthLoading());

    _authSubscription = _authRepository.authStateChanges.listen((isAuth) {
      if (!isAuth && state is! AuthLoading) {
        _refreshTimer?.cancel();
        emit(const AuthUnauthenticated());
      }
    });

    // Szenario 1: App wurde nach Keycloak-Redirect neu geladen.
    if (_authRepository.hasAuthCallback) {
      final failure = await _authRepository.login();
      if (failure == null) {
        emit(const AuthAuthenticated());
        _scheduleRefresh();
      } else {
        // Fehler sichtbar machen — LoginPage zeigt ihn als SnackBar.
        emit(AuthError(failure.message));
      }
      return;
    }

    // Szenario 2: Normaler App-Start — Session aus Refresh Token wiederherstellen.
    final token = await _authRepository.getAccessToken();
    if (token != null) {
      emit(const AuthAuthenticated());
      _scheduleRefresh();
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  /// Startet den Keycloak Login-Flow (leitet Browser zu Keycloak weiter).
  Future<void> login() async {
    emit(const AuthLoading());
    final failure = await _authRepository.login();
    if (failure != null) {
      emit(AuthError(failure.message));
    } else {
      emit(const AuthAuthenticated());
      _scheduleRefresh();
    }
  }

  Future<void> logout() async {
    _refreshTimer?.cancel();
    await _authRepository.logout();
    emit(const AuthUnauthenticated());
  }

  Future<String?> getAccessToken() => _authRepository.getAccessToken();

  void _scheduleRefresh() {
    _refreshTimer?.cancel();
    final expiry = _authRepository.tokenExpiry;
    if (expiry == null) return;

    final delay =
        expiry.difference(DateTime.now()) - const Duration(seconds: 60);
    if (delay.isNegative) {
      _silentRefresh();
      return;
    }
    _refreshTimer = Timer(delay, _silentRefresh);
  }

  Future<void> _silentRefresh() async {
    final success = await _authRepository.refreshToken();
    if (success) _scheduleRefresh();
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    _authSubscription?.cancel();
    return super.close();
  }
}
