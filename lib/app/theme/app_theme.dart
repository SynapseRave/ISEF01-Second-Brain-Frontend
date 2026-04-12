import 'package:flutter/material.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_colors.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_typography.dart';

/// Zentrale Theme-Konfiguration (Material 3).
///
/// Verwende [AppTheme.light] und [AppTheme.dark] — wählt der [ThemeCubit].
abstract final class AppTheme {
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: AppColors.indigo500,
          onPrimary: AppColors.white,
          primaryContainer: Color(0xFF312E81),
          onPrimaryContainer: AppColors.indigo500,
          secondary: AppColors.violet600,
          onSecondary: AppColors.white,
          secondaryContainer: Color(0xFF1E1B4B),
          onSecondaryContainer: AppColors.slate300,
          tertiary: AppColors.info,
          onTertiary: AppColors.white,
          tertiaryContainer: Color(0xFF1E3A5F),
          onTertiaryContainer: AppColors.info,
          error: AppColors.error,
          onError: AppColors.white,
          errorContainer: Color(0xFF7F1D1D),
          onErrorContainer: AppColors.errorLight,
          surface: AppColors.slate800,
          onSurface: AppColors.slate100,
          surfaceContainerHighest: AppColors.slate950,
          onSurfaceVariant: AppColors.slate400,
          outline: AppColors.slate700,
          outlineVariant: Color(0xFF1E293B),
          shadow: Colors.black,
          scrim: Colors.black,
          inverseSurface: AppColors.slate100,
          onInverseSurface: AppColors.slate900,
          inversePrimary: AppColors.indigo600,
        ),
        scaffoldBackgroundColor: AppColors.slate950,
        textTheme: TextTheme(
          displayLarge: AppTypography.h1.copyWith(color: AppColors.slate100),
          displayMedium: AppTypography.h2.copyWith(color: AppColors.slate100),
          displaySmall: AppTypography.h3.copyWith(color: AppColors.slate100),
          headlineMedium: AppTypography.h4.copyWith(color: AppColors.slate100),
          bodyLarge: AppTypography.bodyBase.copyWith(color: AppColors.slate300),
          bodyMedium: AppTypography.bodySm.copyWith(color: AppColors.slate300),
          bodySmall: AppTypography.bodyXs.copyWith(color: AppColors.slate400),
          labelLarge: AppTypography.labelSm.copyWith(color: AppColors.slate300),
          labelSmall: AppTypography.labelXs.copyWith(color: AppColors.slate400),
        ),
        cardTheme: const CardThemeData(
          color: AppColors.slate800,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            side: BorderSide(color: AppColors.slate700),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.slate700,
          thickness: 1,
          space: 1,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.slate800,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.slate700),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.slate700),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.indigo500, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          hintStyle: AppTypography.bodyBase.copyWith(
            color: AppColors.slate600,
          ),
        ),
      );

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: AppColors.indigo600,
          onPrimary: AppColors.white,
          primaryContainer: AppColors.infoLight,
          onPrimaryContainer: AppColors.indigo600,
          secondary: AppColors.violet600,
          onSecondary: AppColors.white,
          secondaryContainer: AppColors.slate100,
          onSecondaryContainer: AppColors.slate700,
          tertiary: AppColors.info,
          onTertiary: AppColors.white,
          tertiaryContainer: AppColors.infoLight,
          onTertiaryContainer: AppColors.info,
          error: AppColors.error,
          onError: AppColors.white,
          errorContainer: AppColors.errorLight,
          onErrorContainer: AppColors.error,
          surface: AppColors.white,
          onSurface: AppColors.slate900,
          surfaceContainerHighest: AppColors.slate100,
          onSurfaceVariant: AppColors.slate500,
          outline: AppColors.slate300,
          outlineVariant: AppColors.slate200,
          shadow: Colors.black,
          scrim: Colors.black,
          inverseSurface: AppColors.slate900,
          onInverseSurface: AppColors.white,
          inversePrimary: AppColors.indigo500,
        ),
        scaffoldBackgroundColor: AppColors.background,
        textTheme: const TextTheme(
          displayLarge: AppTypography.h1,
          displayMedium: AppTypography.h2,
          displaySmall: AppTypography.h3,
          headlineMedium: AppTypography.h4,
          bodyLarge: AppTypography.bodyBase,
          bodyMedium: AppTypography.bodySm,
          bodySmall: AppTypography.bodyXs,
          labelLarge: AppTypography.labelSm,
          labelSmall: AppTypography.labelXs,
        ),
        cardTheme: const CardThemeData(
          color: AppColors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            side: BorderSide(color: AppColors.slate200),
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.slate200,
          thickness: 1,
          space: 1,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.slate300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.slate300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.indigo600, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          hintStyle: AppTypography.bodyBase.copyWith(
            color: AppColors.slate400,
          ),
        ),
      );
}
