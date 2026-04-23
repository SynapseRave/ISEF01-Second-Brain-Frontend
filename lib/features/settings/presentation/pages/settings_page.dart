import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isef01_second_brain_frontend/core/design_system/design_system.dart';
import 'package:isef01_second_brain_frontend/core/widgets/app_loading_indicator.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/entities/service_connection.dart';
import 'package:isef01_second_brain_frontend/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:isef01_second_brain_frontend/features/settings/presentation/bloc/settings_state.dart';
import 'package:isef01_second_brain_frontend/features/settings/presentation/widgets/api_key_input_dialog.dart';
import 'package:isef01_second_brain_frontend/features/settings/presentation/widgets/service_connection_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  /// OAuth-basierte Dienste öffnen den Browser-Flow.
  static const _oauthServices = {
    ServiceType.googleCalendar,
    ServiceType.oneNote,
  };

  /// Alle unterstützten Dienste in Anzeigereihenfolge.
  static const _supportedServices = [
    ServiceType.googleCalendar,
    ServiceType.oneNote,
    ServiceType.notion,
    ServiceType.todoist,
    ServiceType.obsidian,
  ];

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

  /// Verbindungsflow starten — OAuth für Calendar/OneNote, Dialog für die anderen.
  Future<void> _onConnect(BuildContext context, ServiceType service) async {
    if (_oauthServices.contains(service)) {
      context.read<SettingsCubit>().startConnection(service);
      return;
    }

    // API-Key-Dienst: Dialog öffnen und Credentials einsammeln
    final credentials = await ApiKeyInputDialog.show(context, service);
    if (credentials == null || credentials.isEmpty) return;
    if (!context.mounted) return;

    final failure = await context
        .read<SettingsCubit>()
        .storeCredential(service, credentials);

    if (failure == null && context.mounted) {
      AppToast.show(
        context,
        message: '${_labelFor(service)} wurde erfolgreich verbunden.',
        type: ToastType.success,
      );
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

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

  static String _descriptionFor(ServiceType service) => switch (service) {
    ServiceType.googleCalendar =>
      'Zugriff auf Google-Kalendertermine. '
      'Access- und Refresh-Token werden sicher im Backend gespeichert.',
    ServiceType.oneNote =>
      'Zugriff auf OneNote-Notizbücher über Microsoft Graph. '
      'Access- und Refresh-Token werden sicher im Backend gespeichert.',
    ServiceType.notion =>
      'Zugriff auf Notion-Seiten und Datenbanken. '
      'Benötigt einen Notion Integration Token (Settings → My integrations).',
    ServiceType.todoist =>
      'Zugriff auf Todoist-Aufgaben und Projekte. '
      'Benötigt den API Token aus den Todoist-Einstellungen unter Integrationen.',
    ServiceType.obsidian =>
      'Zugriff auf dein lokales Obsidian-Vault über das Local REST API Plugin. '
      'Das Plugin muss in Obsidian installiert und aktiviert sein.',
  };
}
