import 'package:flutter/material.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_colors.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_spacing.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_typography.dart';
import 'package:isef01_second_brain_frontend/core/design_system/widgets/app_button.dart';

/// Fehlerdarstellung mit Icon, Nachricht und optionalem Retry-Button.
///
/// Verwendung:
/// ```dart
/// AppErrorView(
///   message: 'Verbindung fehlgeschlagen',
///   onRetry: () => cubit.reload(),
/// )
/// ```
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.compact = false,
  });

  final String message;

  /// Wird aufgerufen wenn der Nutzer „Erneut versuchen" drückt.
  /// Wenn `null`, wird kein Button angezeigt.
  final VoidCallback? onRetry;

  /// Kompaktes Layout ohne äußeres Padding — z. B. innerhalb von Cards.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? AppSpacing.px12 : AppSpacing.px24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: compact ? 28 : 40,
              color: AppColors.error,
            ),
            SizedBox(height: compact ? AppSpacing.px8 : AppSpacing.px12),
            Text(
              message,
              style: (compact ? AppTypography.bodySm : AppTypography.bodyBase)
                  .copyWith(color: AppColors.slate700),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: compact ? AppSpacing.px12 : AppSpacing.px16),
              AppButton(
                label: 'Erneut versuchen',
                icon: Icons.refresh,
                variant: AppButtonVariant.secondary,
                size: compact ? AppButtonSize.small : AppButtonSize.medium,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
