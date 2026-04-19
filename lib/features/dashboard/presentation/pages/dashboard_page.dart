import 'package:flutter/material.dart';
import 'package:isef01_second_brain_frontend/core/design_system/design_system.dart';
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
    if (AppBreakpoints.isDesktop(context)) {
      return const _DesktopDashboard();
    }
    if (AppBreakpoints.isTablet(context)) {
      return const _TabletDashboard();
    }
    return const _MobileDashboard();
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
        // Ergänzende Panels: feste Breite, scrollbar
        SizedBox(width: 320, child: SupplementaryPanels()),
        VerticalDivider(width: 1, color: AppColors.slate200),
        // Chat: nimmt den gesamten restlichen Platz ein
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
        // Kompakte horizontale Zusammenfassung der drei Dienste
        SupplementaryPanelsCompact(),
        Divider(height: 1, color: AppColors.slate200),
        // Chat füllt den restlichen Platz
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
