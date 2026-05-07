import 'package:flutter/material.dart';
import 'package:isef01_second_brain_frontend/core/design_system/design_system.dart';

/// Suchseite: Dienstübergreifende Suche — in der aktuellen Version nicht verfügbar.
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.px24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.slate100,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  ),
                  child: const Icon(
                    Icons.search_off_rounded,
                    size: 32,
                    color: AppColors.slate400,
                  ),
                ),
                const SizedBox(height: AppSpacing.px20),
                Text(
                  'Suche nicht verfügbar',
                  style: AppTypography.h3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.px8),
                Text(
                  'Die dienstübergreifende Suche wird in einer zukünftigen Version bereitgestellt.',
                  style: AppTypography.bodyBase.copyWith(
                    color: AppColors.slate500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
