import 'package:flutter/material.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_colors.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_spacing.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_typography.dart';

/// Leerer Zustand für Notizen, Todos oder Kalender-Widgets.
///
/// Zeigt ein Icon, einen Titel und eine optionale Beschreibung.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.description,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? description;

  /// Optionaler Button unterhalb der Beschreibung.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.px24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36, color: AppColors.slate300),
            const SizedBox(height: AppSpacing.px12),
            Text(
              title,
              style: AppTypography.labelSm.copyWith(color: AppColors.slate400),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: AppSpacing.px4),
              Text(
                description!,
                style: AppTypography.bodyXs.copyWith(color: AppColors.slate400),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppSpacing.px16),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
