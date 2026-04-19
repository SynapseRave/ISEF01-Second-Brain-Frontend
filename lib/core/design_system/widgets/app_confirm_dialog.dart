import 'package:flutter/material.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_colors.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_spacing.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_typography.dart';
import 'package:isef01_second_brain_frontend/core/design_system/widgets/app_button.dart';

/// Wiederverwendbarer Bestätigungs-Dialog, z. B. für Delete-Flows.
///
/// Gibt `true` zurück wenn bestätigt, `false` oder `null` wenn abgebrochen.
///
/// Verwendung:
/// ```dart
/// final confirmed = await AppConfirmDialog.show(
///   context,
///   title: 'Eintrag löschen',
///   message: 'Diese Aktion kann nicht rückgängig gemacht werden.',
/// );
/// if (confirmed == true) { ... }
/// ```
class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Löschen',
    this.cancelLabel = 'Abbrechen',
    this.isDestructive = true,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;

  /// Wenn `true`, wird der Bestätigen-Button rot dargestellt.
  final bool isDestructive;

  /// Öffnet den Dialog und gibt die Nutzerentscheidung zurück.
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Löschen',
    String cancelLabel = 'Abbrechen',
    bool isDestructive = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => AppConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.px24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isDestructive
                      ? Icons.delete_outline_rounded
                      : Icons.help_outline_rounded,
                  color: isDestructive ? AppColors.error : AppColors.indigo600,
                  size: 22,
                ),
                const SizedBox(width: AppSpacing.px8),
                Expanded(child: Text(title, style: AppTypography.h4)),
              ],
            ),
            const SizedBox(height: AppSpacing.px12),
            Text(message, style: AppTypography.bodySm),
            const SizedBox(height: AppSpacing.px24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  label: cancelLabel,
                  variant: AppButtonVariant.secondary,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                const SizedBox(width: AppSpacing.px8),
                AppButton(
                  label: confirmLabel,
                  variant: AppButtonVariant.primary,
                  isDestructive: isDestructive,
                  onPressed: () => Navigator.of(context).pop(true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
