import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isef01_second_brain_frontend/app/theme/app_theme.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_colors.dart';
import 'package:isef01_second_brain_frontend/core/design_system/tokens/app_typography.dart';
import 'package:isef01_second_brain_frontend/core/theme/theme_cubit.dart';

class SecondBrainApp extends StatelessWidget {
  const SecondBrainApp({super.key, required this.themeCubit});

  final ThemeCubit themeCubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: themeCubit,
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Second Brain',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            home: const _PlaceholderHome(),
          );
        },
      ),
    );
  }
}

/// Temporäre Startseite bis die UI Shell in Phase 1 implementiert wird.
class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ThemeCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Brain'),
        actions: [
          IconButton(
            tooltip: isDark ? 'Hell-Modus' : 'Dunkel-Modus',
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            color: AppColors.indigo600,
            onPressed: cubit.toggle,
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Projekt erfolgreich eingerichtet',
          style: AppTypography.bodyBase,
        ),
      ),
    );
  }
}
