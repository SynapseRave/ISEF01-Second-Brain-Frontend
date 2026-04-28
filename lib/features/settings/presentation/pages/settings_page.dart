import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:isef01_second_brain_frontend/app/router.dart';
import 'package:isef01_second_brain_frontend/core/auth/platform/pkce_storage_stub.dart'
    if (dart.library.js_interop) 'package:isef01_second_brain_frontend/core/auth/platform/pkce_storage_web.dart';
import 'package:isef01_second_brain_frontend/core/design_system/design_system.dart';
import 'package:isef01_second_brain_frontend/core/widgets/app_loading_indicator.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/entities/service_connection.dart';
import 'package:isef01_second_brain_frontend/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:isef01_second_brain_frontend/features/settings/presentation/bloc/settings_state.dart';
import 'package:isef01_second_brain_frontend/features/settings/presentation/widgets/api_key_input_dialog.dart';
import 'package:isef01_second_brain_frontend/features/settings/presentation/widgets/service_connection_card.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _handledOAuthFallback = false;
  static const _googleVerifierStorageKey = 'google_calendar_pkce_verifier';
  static const _googleStateStorageKey = 'google_calendar_oauth_state';
  static const _oneNoteVerifierStorageKey = 'onenote_pkce_verifier';
  static const _oneNoteStateStorageKey = 'onenote_oauth_state';

  static const _oauthServices = {
    ServiceType.googleCalendar,
    ServiceType.oneNote,
  };

  static const _disabledServices = {ServiceType.oneNote};

  static const _supportedServices = [
    ServiceType.googleCalendar,
    ServiceType.oneNote,
    ServiceType.notion,
    ServiceType.todoist,
    ServiceType.obsidian,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _handleOAuthFallback());
  }

  Future<void> _handleOAuthFallback() async {
    if (_handledOAuthFallback || !mounted) return;

    final uri = Uri.base;
    final service = switch (uri.path) {
      AppRoutes.googleCalendarCallback => ServiceType.googleCalendar,
      AppRoutes.oneNoteCallback => ServiceType.oneNote,
      _ => null,
    };

    if (service == null) return;
    if (!uri.queryParameters.containsKey('code') &&
        !uri.queryParameters.containsKey('error')) {
      return;
    }
    if (!_hasPendingPkceState(service)) {
      return;
    }

    _handledOAuthFallback = true;
    final failure = await context.read<SettingsCubit>().completeConnectionCallback(
      service,
      uri,
    );
    if (!mounted) return;

    final message = failure?.message ?? '${_labelFor(service)} verbunden.';
    AppToast.show(
      context,
      message: message,
      type: failure == null ? ToastType.success : ToastType.error,
    );
    context.go(AppRoutes.settings);
  }

  bool _hasPendingPkceState(ServiceType service) {
    final (verifierKey, stateKey) = switch (service) {
      ServiceType.googleCalendar => (
        _googleVerifierStorageKey,
        _googleStateStorageKey,
      ),
      ServiceType.oneNote => (
        _oneNoteVerifierStorageKey,
        _oneNoteStateStorageKey,
      ),
      _ => ('', ''),
    };

    if (verifierKey.isEmpty || stateKey.isEmpty) {
      return false;
    }

    return pkceRead(verifierKey) != null || pkceRead(stateKey) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listenWhen: (_, current) => current is SettingsError,
        listener: (context, state) {
          if (state is SettingsError) {
            AppToast.show(
              context,
              message: state.message,
              type: ToastType.error,
            );
          }
        },
        builder: (context, state) {
          final connections = _connectionsFrom(state);
          final activeService = switch (state) {
            SettingsConnecting(:final activeService) => activeService,
            _ => null,
          };

          if ((state is SettingsInitial || state is SettingsLoading) &&
              connections.isEmpty) {
            return const AppLoadingIndicator();
          }

          if (state is SettingsError && connections.isEmpty) {
            return AppErrorView(
              message: state.message,
              onRetry: () => context.read<SettingsCubit>().loadConnections(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.px24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Integrationen', style: AppTypography.h2),
                    const SizedBox(height: AppSpacing.px8),
                    Text(
                      'Verbinde deine Dienste, damit der AI Assistent auf Kalender, '
                      'Notizen und Aufgaben zugreifen kann.',
                      style: AppTypography.bodyBase.copyWith(
                        color: AppColors.slate500,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.px24),
                    ..._supportedServices.map((service) {
                      final connection = _connectionFor(service, connections);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.px16),
                        child: ServiceConnectionCard(
                          service: service,
                          connection: connection,
                          description: _descriptionFor(service),
                          isBusy: activeService == service,
                          isDisabled: _disabledServices.contains(service),
                          disabledHint: _disabledServices.contains(service)
                              ? _disabledHintFor(service)
                              : null,
                          onConnect: () => _onConnect(context, service),
                          onDisconnect: () async {
                            final confirmed = await AppConfirmDialog.show(
                              context,
                              title: '${_labelFor(service)} trennen',
                              message:
                                  'Die gespeicherten Credentials werden im Backend entfernt. '
                                  'Der Dienst muss danach neu verbunden werden.',
                              confirmLabel: 'Trennen',
                              cancelLabel: 'Abbrechen',
                            );
                            if (confirmed == true && context.mounted) {
                              final failure = await context
                                  .read<SettingsCubit>()
                                  .deleteCredential(service);
                              if (failure == null && context.mounted) {
                                AppToast.show(
                                  context,
                                  message:
                                      '${_labelFor(service)} wurde getrennt.',
                                  type: ToastType.success,
                                );
                              }
                            }
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onConnect(BuildContext context, ServiceType service) async {
    if (_oauthServices.contains(service)) {
      context.read<SettingsCubit>().startConnection(service);
      return;
    }

    final credentials = await ApiKeyInputDialog.show(context, service);
    if (credentials == null || credentials.isEmpty) return;
    if (!context.mounted) return;

    final failure = await context.read<SettingsCubit>().storeCredential(
      service,
      credentials,
    );

    if (failure == null && context.mounted) {
      AppToast.show(
        context,
        message: '${_labelFor(service)} wurde erfolgreich verbunden.',
        type: ToastType.success,
      );
    }
  }

  static List<ServiceConnection> _connectionsFrom(SettingsState state) =>
      switch (state) {
        SettingsLoaded(:final connections) => connections,
        SettingsConnecting(:final connections) => connections,
        SettingsError(:final connections) => connections ?? const [],
        _ => const [],
      };

  static ServiceConnection _connectionFor(
    ServiceType service,
    List<ServiceConnection> connections,
  ) {
    for (final connection in connections) {
      if (connection.service == service) return connection;
    }
    return ServiceConnection(
      service: service,
      status: ConnectionStatus.disconnected,
    );
  }

  static String _labelFor(ServiceType service) => switch (service) {
    ServiceType.googleCalendar => 'Google Calendar',
    ServiceType.oneNote => 'Microsoft OneNote',
    ServiceType.notion => 'Notion',
    ServiceType.todoist => 'Todoist',
    ServiceType.obsidian => 'Obsidian',
  };

  static String _disabledHintFor(ServiceType service) => switch (service) {
    ServiceType.oneNote =>
      'Microsoft OAuth-App nicht konfiguriert. '
          'MICROSOFT_CLIENT_ID fehlt - Integration derzeit nicht verfuegbar.',
    _ => 'Diese Integration ist derzeit nicht verfuegbar.',
  };

  static String _descriptionFor(ServiceType service) => switch (service) {
    ServiceType.googleCalendar =>
      'Zugriff auf Google-Kalendertermine. '
          'Access- und Refresh-Token werden sicher im Backend gespeichert.',
    ServiceType.oneNote =>
      'Zugriff auf OneNote-Notizbuecher ueber Microsoft Graph. '
          'Access- und Refresh-Token werden sicher im Backend gespeichert.',
    ServiceType.notion =>
      'Zugriff auf Notion-Seiten und Datenbanken. '
          'Benoetigt einen Notion Integration Token (Settings -> My integrations).',
    ServiceType.todoist =>
      'Zugriff auf Todoist-Aufgaben und Projekte. '
          'Benoetigt den API Token aus den Todoist-Einstellungen unter Integrationen.',
    ServiceType.obsidian =>
      'Zugriff auf dein lokales Obsidian-Vault ueber das Local REST API Plugin. '
          'Das Plugin muss in Obsidian installiert und aktiviert sein.',
  };
}
