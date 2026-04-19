import 'package:flutter/material.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_colors.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_spacing.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_typography.dart';

enum AppButtonVariant { primary, secondary, ghost }

enum AppButtonSize { small, medium, large }

/// Universeller Button des Second Brain Design Systems.
///
/// Varianten: [AppButtonVariant.primary] (gefüllt), [AppButtonVariant.secondary]
/// (Outline) und [AppButtonVariant.ghost] (transparent / Icon-only).
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isDestructive = false,
    this.isSuccess = false,
  });

  /// Icon-only Ghost-Button ohne Label.
  const AppButton.icon({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = AppButtonSize.medium,
  }) : label = null,
       variant = AppButtonVariant.ghost,
       isDestructive = false,
       isSuccess = false;

  final String? label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isDestructive;
  final bool isSuccess;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;

    return switch (variant) {
      AppButtonVariant.primary => _PrimaryButton(this, isDisabled),
      AppButtonVariant.secondary => _SecondaryButton(this, isDisabled),
      AppButtonVariant.ghost => _GhostButton(this, isDisabled),
    };
  }
}

// ── Sizing helpers ────────────────────────────────────────────────────────────

EdgeInsets _padding(AppButtonSize size, bool iconOnly) {
  if (iconOnly) {
    return switch (size) {
      AppButtonSize.small => const EdgeInsets.all(AppSpacing.px6),
      AppButtonSize.medium => const EdgeInsets.all(AppSpacing.px8),
      AppButtonSize.large => const EdgeInsets.all(AppSpacing.px10),
    };
  }
  return switch (size) {
    AppButtonSize.small => const EdgeInsets.symmetric(
      horizontal: AppSpacing.px12,
      vertical: AppSpacing.px6,
    ),
    AppButtonSize.medium => const EdgeInsets.symmetric(
      horizontal: AppSpacing.px16,
      vertical: AppSpacing.px8,
    ),
    AppButtonSize.large => const EdgeInsets.symmetric(
      horizontal: AppSpacing.px20,
      vertical: AppSpacing.px12,
    ),
  };
}

double _iconSize(AppButtonSize size) => switch (size) {
  AppButtonSize.small => 14,
  AppButtonSize.medium => 16,
  AppButtonSize.large => 18,
};

TextStyle _labelStyle(AppButtonSize size) => switch (size) {
  AppButtonSize.small => AppTypography.labelXs,
  AppButtonSize.medium => AppTypography.labelSm,
  AppButtonSize.large => AppTypography.bodyBase.copyWith(
    fontWeight: FontWeight.w500,
  ),
};

Widget _buttonContent(AppButton btn, Color textColor) {
  final iconOnly = btn.label == null;
  final style = _labelStyle(btn.size).copyWith(color: textColor);

  if (iconOnly && btn.icon != null) {
    return Icon(btn.icon, size: _iconSize(btn.size), color: textColor);
  }
  if (btn.icon != null) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(btn.icon, size: _iconSize(btn.size), color: textColor),
        const SizedBox(width: AppSpacing.px6),
        Text(btn.label!, style: style),
      ],
    );
  }
  return Text(btn.label!, style: style);
}

// ── Primary ───────────────────────────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton(this.btn, this.isDisabled);
  final AppButton btn;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    Color bg;
    if (isDisabled) {
      bg = AppColors.slate200;
    } else if (btn.isDestructive) {
      bg = AppColors.error;
    } else if (btn.isSuccess) {
      bg = AppColors.success;
    } else {
      bg = AppColors.indigo600;
    }

    final textColor = isDisabled ? AppColors.slate400 : AppColors.white;
    final iconOnly = btn.label == null;

    return FilledButton(
      onPressed: btn.onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: bg,
        disabledBackgroundColor: AppColors.slate200,
        padding: _padding(btn.size, iconOnly),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: _buttonContent(btn, textColor),
    );
  }
}

// ── Secondary / Outline ───────────────────────────────────────────────────────

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton(this.btn, this.isDisabled);
  final AppButton btn;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    Color borderColor;
    Color textColor;

    if (isDisabled) {
      borderColor = AppColors.slate200;
      textColor = AppColors.slate400;
    } else if (btn.isDestructive) {
      borderColor = AppColors.error;
      textColor = AppColors.error;
    } else if (btn.isSuccess) {
      borderColor = AppColors.success;
      textColor = AppColors.success;
    } else {
      borderColor = AppColors.slate300;
      textColor = AppColors.slate700;
    }

    final iconOnly = btn.label == null;

    return OutlinedButton(
      onPressed: btn.onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor,
        side: BorderSide(color: borderColor),
        padding: _padding(btn.size, iconOnly),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: _buttonContent(btn, textColor),
    );
  }
}

// ── Ghost / Icon ──────────────────────────────────────────────────────────────

class _GhostButton extends StatelessWidget {
  const _GhostButton(this.btn, this.isDisabled);
  final AppButton btn;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final textColor = isDisabled
        ? AppColors.slate300
        : btn.isDestructive
        ? AppColors.error
        : AppColors.slate500;

    final iconOnly = btn.label == null;

    return TextButton(
      onPressed: btn.onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor,
        padding: _padding(btn.size, iconOnly),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: _buttonContent(btn, textColor),
    );
  }
}
