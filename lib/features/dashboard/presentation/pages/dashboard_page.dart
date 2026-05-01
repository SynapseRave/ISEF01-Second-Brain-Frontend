import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isef01_second_brain_frontend/core/design_system/design_system.dart';
import 'package:isef01_second_brain_frontend/core/di/injection.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/presentation/bloc/dashboard_cubit.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/presentation/widgets/chat_panel.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/presentation/widgets/supplementary_panels.dart';

/// Dashboard: Chat als Hauptkomponente, Notizen/Todos/Kalender ergänzend.
///
/// Desktop (≥ 1024 px): Ergänzende Panels links, Chat rechts (Hauptbereich).
/// Tablet  (600–1023 px): Ergänzende Panels als schmale Leiste oben, Chat darunter.
/// Mobile  (< 600 px): Chat nimmt den vollen Bereich ein.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardCubit>()..load(),
      child: Builder(
        builder: (context) {
          if (AppBreakpoints.isDesktop(context)) {
            return const _DesktopDashboard();
          }
          if (AppBreakpoints.isTablet(context)) {
            return const _TabletDashboard();
          }
          return const _MobileDashboard();
        },
      ),
    );
  }
}

// ── Desktop ───────────────────────────────────────────────────────────────────

class _DesktopDashboard extends StatelessWidget {
  const _DesktopDashboard();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(width: 320, child: SupplementaryPanels()),
        VerticalDivider(width: 1, color: AppColors.slate200),
        Expanded(child: ChatPanel()),
      ],
    );
  }
}

// ── Tablet ────────────────────────────────────────────────────────────────────

class _TabletDashboard extends StatelessWidget {
  const _TabletDashboard();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SupplementaryPanelsCompact(),
        Divider(height: 1, color: AppColors.slate200),
        Expanded(child: ChatPanel()),
      ],
    );
  }
}

// ── Mobile ────────────────────────────────────────────────────────────────────

class _MobileDashboard extends StatelessWidget {
  const _MobileDashboard();

  @override
  Widget build(BuildContext context) {
    return const ChatPanel();
  }
}
