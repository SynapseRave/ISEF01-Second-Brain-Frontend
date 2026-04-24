import 'package:flutter/material.dart';
import 'package:isef01_second_brain_frontend/core/design_system/design_system.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/entities/service_connection.dart';

class ServiceConnectionCard extends StatelessWidget {
  const ServiceConnectionCard({
    super.key,
    required this.service,
    required this.connection,
    required this.description,
    required this.isBusy,
    required this.onConnect,
    required this.onDisconnect,
  });

  final ServiceType service;
  final ServiceConnection connection;
  final String description;
  final bool isBusy;
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  @override
  Widget build(BuildContext context) {
    final isConnected = connection.status == ConnectionStatus.connected;
    final effectiveStatus = isBusy
        ? ConnectionStatus.connecting
        : connection.status;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.px20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ServiceAvatar(service: service, size: 40),
              const SizedBox(width: AppSpacing.px12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_labelFor(service), style: AppTypography.h4),
                    const SizedBox(height: AppSpacing.px6),
                    Text(
                      description,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.slate500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.px12),
              ConnectionStatusBadge(status: effectiveStatus),
            ],
          ),
          if (connection.updatedAt != null) ...[
            const SizedBox(height: AppSpacing.px16),
            Text(
              'Zuletzt aktualisiert: ${_formatDateTime(connection.updatedAt!)}',
              style: AppTypography.body11.copyWith(color: AppColors.slate500),
            ),
          ],
          const SizedBox(height: AppSpacing.px20),
          Row(
            children: [
              AppButton(
                label: isConnected ? 'Erneut verbinden' : 'Verbinden',
                icon: isConnected ? Icons.refresh_rounded : Icons.link_rounded,
                size: AppButtonSize.medium,
                onPressed: isBusy ? null : onConnect,
              ),
              if (isConnected) ...[
                const SizedBox(width: AppSpacing.px8),
                AppButton(
                  label: 'Trennen',
                  icon: Icons.link_off_rounded,
                  variant: AppButtonVariant.secondary,
                  isDestructive: true,
                  onPressed: isBusy ? null : onDisconnect,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  static String _labelFor(ServiceType service) => switch (service) {
    ServiceType.googleCalendar => 'Google Calendar',
    ServiceType.oneNote => 'Microsoft OneNote',
    ServiceType.notion => 'Notion',
    ServiceType.todoist => 'Todoist',
    ServiceType.obsidian => 'Obsidian',
  };

  static String _formatDateTime(DateTime value) {
    final local = value.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year.toString();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day.$month.$year, $hour:$minute';
  }
}
