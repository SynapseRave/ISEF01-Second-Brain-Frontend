import 'package:flutter/material.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_colors.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_spacing.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_typography.dart';

/// Konsistentes Textfeld des Second Brain Design Systems.
///
/// Zeigt optionales Label, Prefix-Icon, Fehlermeldung und Hilfstext an.
///
/// Verwendung:
/// ```dart
/// AppTextField(
///   label: 'E-Mail',
///   hint: 'name@example.com',
///   prefixIcon: Icons.email_outlined,
///   errorText: formError,
///   onChanged: (v) => setState(() => email = v),
/// )
/// ```
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.helperText,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.obscureText = false,
    this.enabled = true,
    this.autofocus = false,
    this.maxLines = 1,
    this.keyboardType,
    this.textInputAction,
  });

  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final String? helperText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool obscureText;
  final bool enabled;
  final bool autofocus;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.labelSm.copyWith(
              color: enabled ? AppColors.slate700 : AppColors.slate400,
            ),
          ),
          const SizedBox(height: AppSpacing.px6),
        ],
        TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          obscureText: obscureText,
          enabled: enabled,
          autofocus: autofocus,
          maxLines: obscureText ? 1 : maxLines,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: AppTypography.bodyBase.copyWith(
            color: enabled ? AppColors.slate900 : AppColors.slate400,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 18, color: AppColors.slate400)
                : null,
            suffixIcon: suffixIcon,
            errorText: null, // Wir rendern den Fehler selbst unten
            filled: true,
            fillColor: enabled
                ? Theme.of(context).inputDecorationTheme.fillColor
                : AppColors.slate100,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: BorderSide(
                color: hasError ? AppColors.error : AppColors.slate300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: BorderSide(
                color: hasError ? AppColors.error : AppColors.indigo600,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              borderSide: const BorderSide(color: AppColors.slate200),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.px12,
              vertical: AppSpacing.px10,
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.px4),
          Row(
            children: [
              const Icon(Icons.error_outline, size: 13, color: AppColors.error),
              const SizedBox(width: AppSpacing.px4),
              Flexible(
                child: Text(
                  errorText!,
                  style: AppTypography.body11.copyWith(color: AppColors.error),
                ),
              ),
            ],
          ),
        ] else if (helperText != null) ...[
          const SizedBox(height: AppSpacing.px4),
          Text(
            helperText!,
            style: AppTypography.body11.copyWith(color: AppColors.slate500),
          ),
        ],
      ],
    );
  }
}
