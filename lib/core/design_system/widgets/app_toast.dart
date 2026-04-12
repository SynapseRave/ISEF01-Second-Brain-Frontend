import 'package:flutter/material.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_colors.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_spacing.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_typography.dart';
import 'package:isef01_second_brain_frontend/core/design_system/widgets/app_status_indicator.dart';

enum ToastType { success, error, info, loading }

/// Zeigt eine Toast-Benachrichtigung über [ScaffoldMessenger].
///
/// Verwendung:
/// ```dart
/// AppToast.show(context, message: 'Gespeichert', type: ToastType.success);
/// ```
class AppToast {
  const AppToast._();

  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: _ToastContent(message: message, type: type),
          backgroundColor: Colors.transparent,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          duration: duration,
          margin: const EdgeInsets.all(AppSpacing.px16),
          padding: EdgeInsets.zero,
        ),
      );
  }
}

class _ToastContent extends StatelessWidget {
  const _ToastContent({required this.message, required this.type});

  final String message;
  final ToastType type;

  @override
  Widget build(BuildContext context) {
    final (icon, iconColor, bg, border) = switch (type) {
      ToastType.success => (
          Icons.check_circle_outline,
          AppColors.success,
          AppColors.successLight,
          AppColors.success,
        ),
      ToastType.error => (
          Icons.error_outline,
          AppColors.error,
          AppColors.errorLight,
          AppColors.error,
        ),
      ToastType.info => (
          Icons.info_outline,
          AppColors.slate700,
          AppColors.white,
          AppColors.slate300,
        ),
      ToastType.loading => (
          null,
          AppColors.warning,
          AppColors.warningLight,
          AppColors.warning,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.px16,
        vertical: AppSpacing.px12,
      ),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (type == ToastType.loading)
            const AppSpinner(size: SpinnerSize.small)
          else if (icon != null)
            Icon(icon, size: 16, color: iconColor),
          const SizedBox(width: AppSpacing.px8),
          Flexible(
            child: Text(
              message,
              style: AppTypography.bodySm.copyWith(
                color: type == ToastType.info
                    ? AppColors.slate700
                    : iconColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
