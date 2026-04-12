import 'package:flutter/material.dart';
import 'package:isef01_second_brain_frontend/core/design_system/design_system.dart';

/// Ergänzende Panels (Notizen, Todos, Kalender) für die Desktop-Ansicht.
///
/// Zeigen Platzhalter-Inhalte — Phase 5 füllt diese mit echten Daten.
class SupplementaryPanels extends StatelessWidget {
  const SupplementaryPanels({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.slate50,
      child: const SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.px16),
        child: Column(
          children: [
            _SectionPanel(
              icon: Icons.description_outlined,
              title: 'Notizen',
              child: AppEmptyState(
                icon: Icons.description_outlined,
                title: 'Keine Notizen',
                description: 'Erstelle deine erste Notiz',
              ),
            ),
            SizedBox(height: AppSpacing.px12),
            _SectionPanel(
              icon: Icons.check_box_outlined,
              title: 'Todos',
              child: AppEmptyState(
                icon: Icons.check_box_outlined,
                title: 'Keine Todos',
                description: 'Alle Aufgaben erledigt!',
              ),
            ),
            SizedBox(height: AppSpacing.px12),
            _SectionPanel(
              icon: Icons.calendar_today_outlined,
              title: 'Kalender',
              child: AppEmptyState(
                icon: Icons.calendar_today_outlined,
                title: 'Keine Termine',
                description: 'Freier Tag!',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kompakte horizontale Leiste der drei Panels für Tablet-Ansicht.
class SupplementaryPanelsCompact extends StatelessWidget {
  const SupplementaryPanelsCompact({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: AppColors.slate50,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.px16,
        vertical: AppSpacing.px10,
      ),
      child: const Row(
        children: [
          Expanded(child: _CompactTile(icon: Icons.description_outlined,    label: 'Notizen',   count: '0')),
          SizedBox(width: AppSpacing.px8),
          Expanded(child: _CompactTile(icon: Icons.check_box_outlined,      label: 'Todos',     count: '0')),
          SizedBox(width: AppSpacing.px8),
          Expanded(child: _CompactTile(icon: Icons.calendar_today_outlined, label: 'Kalender',  count: '0')),
        ],
      ),
    );
  }
}

// ── Private Widgets ───────────────────────────────────────────────────────────

class _SectionPanel extends StatelessWidget {
  const _SectionPanel({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.px16, AppSpacing.px12,
              AppSpacing.px16, AppSpacing.px8,
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: AppColors.slate500),
                const SizedBox(width: AppSpacing.px8),
                Text(title, style: AppTypography.labelSm),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.slate100),
          child,
        ],
      ),
    );
  }
}

class _CompactTile extends StatelessWidget {
  const _CompactTile({
    required this.icon,
    required this.label,
    required this.count,
  });

  final IconData icon;
  final String label;
  final String count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.px12,
        vertical: AppSpacing.px8,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.slate400),
          const SizedBox(width: AppSpacing.px8),
          Expanded(
            child: Text(label, style: AppTypography.bodySm),
          ),
          Text(
            count,
            style: AppTypography.labelSm.copyWith(color: AppColors.slate400),
          ),
        ],
      ),
    );
  }
}
