import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:isef01_second_brain_frontend/core/design_system/design_system.dart';

/// Untere Navigationsleiste für Mobile (< 600 px).
class ShellBottomNav extends StatelessWidget {
  const ShellBottomNav({super.key});

  static const _items = [
    (Icons.grid_view_rounded, 'Dashboard', '/'),
    (Icons.search_rounded, 'Suche', '/search'),
    (Icons.history_rounded, 'Historie', '/history'),
    (Icons.settings_outlined, 'Einstellungen', '/settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;

    int currentIndex = _items.indexWhere(
      (item) => item.$3 == '/' ? location == '/' : location.startsWith(item.$3),
    );
    if (currentIndex == -1) currentIndex = 0;

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.slate200)),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => context.go(_items[i].$3),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.indigo600,
        unselectedItemColor: AppColors.slate400,
        selectedLabelStyle: AppTypography.body10.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: AppTypography.body10,
        backgroundColor: AppColors.white,
        elevation: 0,
        items: _items
            .map(
              (item) => BottomNavigationBarItem(
                icon: Icon(item.$1, size: 22),
                label: item.$2,
              ),
            )
            .toList(),
      ),
    );
  }
}
