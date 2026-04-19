import 'package:flutter/material.dart';
import 'package:isef01_second_brain_frontend/app/shell/widgets/shell_bottom_nav.dart';
import 'package:isef01_second_brain_frontend/app/shell/widgets/shell_sidebar.dart';
import 'package:isef01_second_brain_frontend/core/design_system/design_system.dart';

/// Persistente App-Shell mit responsivem Layout.
///
/// Desktop (≥ 1024 px): Sidebar links, Haupt-Inhalt rechts.
/// Tablet  (600–1023 px): Sidebar links (kollabiert), Haupt-Inhalt rechts.
/// Mobile  (< 600 px): BottomNavigationBar unten, Haupt-Inhalt oben.
///
/// Der Chat ist kein Shell-Overlay — er ist fester Bestandteil der
/// [DashboardPage] und damit immer sichtbar wenn das Dashboard aktiv ist.
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _sidebarCollapsed = false;

  void _toggleSidebar() =>
      setState(() => _sidebarCollapsed = !_sidebarCollapsed);

  @override
  Widget build(BuildContext context) {
    if (AppBreakpoints.isMobile(context)) {
      return _MobileLayout(child: widget.child);
    }

    final autoCollapse = AppBreakpoints.isTablet(context);

    return _DesktopLayout(
      sidebarCollapsed: autoCollapse || _sidebarCollapsed,
      onToggleSidebar: autoCollapse ? () {} : _toggleSidebar,
      child: widget.child,
    );
  }
}

// ── Desktop / Tablet Layout ───────────────────────────────────────────────────

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.sidebarCollapsed,
    required this.onToggleSidebar,
    required this.child,
  });

  final bool sidebarCollapsed;
  final VoidCallback onToggleSidebar;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          ShellSidebar(
            collapsed: sidebarCollapsed,
            onToggleCollapse: onToggleSidebar,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

// ── Mobile Layout ─────────────────────────────────────────────────────────────

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: child,
      bottomNavigationBar: const ShellBottomNav(),
    );
  }
}
