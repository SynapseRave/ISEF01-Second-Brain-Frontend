import 'package:flutter/material.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_colors.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_spacing.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_typography.dart';
import 'package:isef01_second_brain_frontend/features/settings/domain/entities/service_connection.dart';

export 'package:isef01_second_brain_frontend/features/settings/domain/entities/service_connection.dart'
    show ConnectionStatus, ServiceType;

// ── Service Badge ─────────────────────────────────────────────────────────────

/// Farbiges Badge mit Service-Icon-Buchstabe und Name.
class ServiceBadge extends StatelessWidget {
  const ServiceBadge({super.key, required this.service});

  final ServiceType service;

  @override
  Widget build(BuildContext context) {
    final (label, letter, bg) = switch (service) {
      ServiceType.notion => ('Notion', 'N', AppColors.notion),
      ServiceType.todoist => ('Todoist', 'T', AppColors.todoist),
      ServiceType.obsidian => ('Obsidian', 'O', AppColors.obsidian),
      ServiceType.oneNote => ('OneNote', 'O', AppColors.oneNote),
      ServiceType.googleCalendar => ('Google Calendar', 'G', AppColors.googleCalendar),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.px8,
        vertical: AppSpacing.px4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            alignment: Alignment.center,
            child: Text(
              letter,
              style: AppTypography.body10.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.px4),
          Text(
            label,
            style: AppTypography.body11.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Service Avatar (nur Icon, kein Text) ──────────────────────────────────────

/// Quadratischer Avatar-Block mit Buchstabe, z.B. in der Sidebar oder Karte.
class ServiceAvatar extends StatelessWidget {
  const ServiceAvatar({super.key, required this.service, this.size = 32});

  final ServiceType service;
  final double size;

  @override
  Widget build(BuildContext context) {
    final (letter, bg) = switch (service) {
      ServiceType.notion => ('N', AppColors.notion),
      ServiceType.todoist => ('T', AppColors.todoist),
      ServiceType.obsidian => ('O', AppColors.obsidian),
      ServiceType.oneNote => ('O', AppColors.oneNote),
      ServiceType.googleCalendar => ('G', AppColors.googleCalendar),
    };

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: AppTypography.labelSm.copyWith(
          color: AppColors.white,
          fontSize: size * 0.4,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ── Priority Badge ────────────────────────────────────────────────────────────

enum Priority { high, medium, low, none }

/// Badge für Aufgaben-Priorität (Hoch / Mittel / Niedrig / Keine).
class PriorityBadge extends StatelessWidget {
  const PriorityBadge({super.key, required this.priority});

  final Priority priority;

  @override
  Widget build(BuildContext context) {
    final (label, dotColor, bg) = switch (priority) {
      Priority.high => ('Hoch', AppColors.error, AppColors.errorLight),
      Priority.medium => ('Mittel', AppColors.warning, AppColors.warningLight),
      Priority.low => ('Niedrig', AppColors.info, AppColors.infoLight),
      Priority.none => ('Keine', AppColors.slate400, AppColors.slate100),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.px8,
        vertical: AppSpacing.px4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.px4),
          Text(
            label,
            style: AppTypography.body11.copyWith(
              color: dotColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Connection Status Badge ────────────────────────────────────────────────────

/// Badge für den Verbindungsstatus eines Dienstes.
class ConnectionStatusBadge extends StatelessWidget {
  const ConnectionStatusBadge({super.key, required this.status});

  final ConnectionStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, icon, textColor, bg) = switch (status) {
      ConnectionStatus.connected => (
        'Verbunden',
        Icons.check_circle_outline,
        AppColors.success,
        AppColors.successLight,
      ),
      ConnectionStatus.disconnected => (
        'Getrennt',
        Icons.wifi_off,
        AppColors.slate500,
        AppColors.slate100,
      ),
      ConnectionStatus.error => (
        'Fehler',
        Icons.error_outline,
        AppColors.error,
        AppColors.errorLight,
      ),
      ConnectionStatus.connecting => (
        'Verbindet...',
        Icons.sync,
        AppColors.warning,
        AppColors.warningLight,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.px8,
        vertical: AppSpacing.px4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: textColor),
          const SizedBox(width: AppSpacing.px4),
          Text(
            label,
            style: AppTypography.body11.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tag Chip ──────────────────────────────────────────────────────────────────

/// Hashtag-Chip, z.B. #meeting, #planning.
class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.tag, this.onTap});

  final String tag;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final label = tag.startsWith('#') ? tag : '#$tag';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.px10,
          vertical: AppSpacing.px4,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.slate200),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Text(
          label,
          style: AppTypography.body11.copyWith(color: AppColors.slate600),
        ),
      ),
    );
  }
}

// ── Live Status Badge ─────────────────────────────────────────────────────────

enum LiveStatus { now, soon, pinned }

/// Badge für Zeitstatus von Terminen (Jetzt / Gleich / Angepinnt).
class LiveStatusBadge extends StatelessWidget {
  const LiveStatusBadge({super.key, required this.status});

  final LiveStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, icon, textColor, bg) = switch (status) {
      LiveStatus.now => ('Jetzt', null, AppColors.white, AppColors.info),
      LiveStatus.soon => (
        'Gleich',
        null,
        AppColors.warning,
        AppColors.warningLight,
      ),
      LiveStatus.pinned => (
        'Angepinnt',
        Icons.push_pin,
        AppColors.violet600,
        AppColors.slate100,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.px8,
        vertical: AppSpacing.px4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 11, color: textColor),
            const SizedBox(width: AppSpacing.px4),
          ],
          Text(
            label,
            style: AppTypography.body11.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
