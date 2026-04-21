import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:isef01_second_brain_frontend/core/auth/auth_cubit.dart';
import 'package:isef01_second_brain_frontend/core/design_system/design_system.dart';

/// Navigations-Einträge der Sidebar.
class _NavItem {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
  final IconData icon;
  final String label;
  final String route;
}

const _navItems = [
  _NavItem(icon: Icons.grid_view_rounded, label: 'Dashboard', route: '/'),
  _NavItem(icon: Icons.search_rounded, label: 'Suche', route: '/search'),
  _NavItem(icon: Icons.history_rounded, label: 'Historie', route: '/history'),
  _NavItem(
    icon: Icons.settings_outlined,
    label: 'Einstellungen',
    route: '/settings',
  ),
];

/// Seitliche Navigationsleiste für Desktop (≥ 1024 px).
///
/// Kann über [collapsed] zwischen Voll- und Icon-Only-Modus umgeschaltet werden.
class ShellSidebar extends StatelessWidget {
  const ShellSidebar({
    super.key,
    required this.collapsed,
    required this.onToggleCollapse,
  });

  final bool collapsed;
  final VoidCallback onToggleCollapse;

  static const double _expandedWidth = 240;
  static const double _collapsedWidth = 72;

  @override
  Widget build(BuildContext context) {
    final width = collapsed ? _collapsedWidth : _expandedWidth;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: width,
      decoration: const BoxDecoration(
        color: AppColors.slate950,
        border: Border(right: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Column(
        children: [
          _Logo(collapsed: collapsed),
          const SizedBox(height: AppSpacing.px8),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.px8,
                vertical: AppSpacing.px4,
              ),
              child: Column(
                children: [
                  ..._navItems.map(
                    (item) => _NavTile(item: item, collapsed: collapsed),
                  ),
                  const SizedBox(height: AppSpacing.px16),
                  _ServiceSection(collapsed: collapsed),
                ],
              ),
            ),
          ),
          _LogoutButton(collapsed: collapsed),
          _CollapseButton(collapsed: collapsed, onTap: onToggleCollapse),
        ],
      ),
    );
  }
}

// ── Logo ──────────────────────────────────────────────────────────────────────

class _Logo extends StatelessWidget {
  const _Logo({required this.collapsed});
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.px16,
        AppSpacing.px20,
        AppSpacing.px16,
        AppSpacing.px12,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Icon(
              Icons.psychology_rounded,
              color: AppColors.white,
              size: 20,
            ),
          ),
          if (!collapsed) ...[
            const SizedBox(width: AppSpacing.px10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Second Brain',
                    style: AppTypography.labelSm.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Multi-App Interface',
                    style: AppTypography.body10.copyWith(
                      color: AppColors.slate400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Nav Tile ──────────────────────────────────────────────────────────────────

class _NavTile extends StatelessWidget {
  const _NavTile({required this.item, required this.collapsed});
  final _NavItem item;
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final isActive = item.route == '/'
        ? location == '/'
        : location.startsWith(item.route);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.px2),
      child: _SidebarTile(
        icon: item.icon,
        label: item.label,
        collapsed: collapsed,
        isActive: isActive,
        onTap: () => context.go(item.route),
      ),
    );
  }
}

// ── Generic Sidebar Tile ───────────────────────────────────────────────────────

class _SidebarTile extends StatelessWidget {
  const _SidebarTile({
    required this.icon,
    required this.label,
    required this.collapsed,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool collapsed;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: collapsed ? label : '',
      preferBelow: false,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.px12,
            vertical: AppSpacing.px10,
          ),
          decoration: BoxDecoration(
            color: isActive ? AppColors.indigo600 : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive ? AppColors.white : AppColors.slate400,
              ),
              if (!collapsed) ...[
                const SizedBox(width: AppSpacing.px10),
                Expanded(
                  child: Text(
                    label,
                    style: AppTypography.labelSm.copyWith(
                      color: isActive ? AppColors.white : AppColors.slate300,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Services Section ──────────────────────────────────────────────────────────

class _ServiceSection extends StatelessWidget {
  const _ServiceSection({required this.collapsed});
  final bool collapsed;

  static const _services = [
    (ServiceType.notion, ConnectionStatus.connected),
    (ServiceType.todoist, ConnectionStatus.connected),
    (ServiceType.obsidian, ConnectionStatus.connected),
    (ServiceType.oneNote, ConnectionStatus.error),
    (ServiceType.kalender, ConnectionStatus.connected),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!collapsed)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.px12,
              0,
              AppSpacing.px12,
              AppSpacing.px8,
            ),
            child: Text(
              'DIENSTE',
              style: AppTypography.body10.copyWith(
                color: AppColors.slate500,
                letterSpacing: 0.8,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ..._services.map(
          (s) =>
              _ServiceTile(service: s.$1, status: s.$2, collapsed: collapsed),
        ),
      ],
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.service,
    required this.status,
    required this.collapsed,
  });

  final ServiceType service;
  final ConnectionStatus status;
  final bool collapsed;

  static const _labels = {
    ServiceType.notion: 'Notion',
    ServiceType.todoist: 'Todoist',
    ServiceType.obsidian: 'Obsidian',
    ServiceType.oneNote: 'OneNote',
    ServiceType.kalender: 'Kalender',
  };

  @override
  Widget build(BuildContext context) {
    final label = _labels[service]!;
    final statusIcon = switch (status) {
      ConnectionStatus.connected => Icons.wifi_rounded,
      ConnectionStatus.disconnected => Icons.wifi_off_rounded,
      ConnectionStatus.error => Icons.error_outline_rounded,
      ConnectionStatus.connecting => Icons.sync_rounded,
    };
    final statusColor = switch (status) {
      ConnectionStatus.connected => AppColors.success,
      ConnectionStatus.disconnected => AppColors.slate500,
      ConnectionStatus.error => AppColors.error,
      ConnectionStatus.connecting => AppColors.warning,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.px2),
      child: Tooltip(
        message: collapsed ? label : '',
        child: InkWell(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.px12,
              vertical: AppSpacing.px8,
            ),
            child: Row(
              children: [
                ServiceAvatar(service: service, size: 24),
                if (!collapsed) ...[
                  const SizedBox(width: AppSpacing.px10),
                  Expanded(
                    child: Text(
                      label,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.slate300,
                      ),
                    ),
                  ),
                  Icon(statusIcon, size: 14, color: statusColor),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Logout Button ─────────────────────────────────────────────────────────────

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.collapsed});
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.px8,
        vertical: AppSpacing.px4,
      ),
      child: Tooltip(
        message: collapsed ? 'Abmelden' : '',
        child: InkWell(
          onTap: () => context.read<AuthCubit>().logout(),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.px12,
              vertical: AppSpacing.px10,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.logout_rounded,
                  size: 18,
                  color: AppColors.slate400,
                ),
                if (!collapsed) ...[
                  const SizedBox(width: AppSpacing.px10),
                  Text(
                    'Abmelden',
                    style: AppTypography.bodySm.copyWith(
                      color: AppColors.slate400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Collapse Button ───────────────────────────────────────────────────────────

class _CollapseButton extends StatelessWidget {
  const _CollapseButton({required this.collapsed, required this.onTap});
  final bool collapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.px8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.px12,
            vertical: AppSpacing.px10,
          ),
          child: Row(
            children: [
              Icon(
                collapsed
                    ? Icons.chevron_right_rounded
                    : Icons.chevron_left_rounded,
                size: 18,
                color: AppColors.slate400,
              ),
              if (!collapsed) ...[
                const SizedBox(width: AppSpacing.px10),
                Text(
                  'Einklappen',
                  style: AppTypography.bodySm.copyWith(
                    color: AppColors.slate400,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
