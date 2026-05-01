import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:isef01_second_brain_frontend/core/design_system/design_system.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/entities/dashboard_item.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/presentation/bloc/dashboard_cubit.dart';

/// Ergänzende Panels (Notizen, Todos, Kalender) für die Desktop-Ansicht.
class SupplementaryPanels extends StatelessWidget {
  const SupplementaryPanels({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final loaded = state is DashboardLoaded ? state : null;
        return Container(
          color: AppColors.slate50,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.px16),
            child: Column(
              children: [
                _SectionPanel(
                  icon: Icons.description_outlined,
                  title: 'Notizen',
                  isLoading: state is DashboardLoading,
                  child: loaded?.lastNote != null
                      ? _NotePreview(loaded!.lastNote!)
                      : const AppEmptyState(
                          icon: Icons.description_outlined,
                          title: 'Keine Notizen',
                          description: 'Erstelle deine erste Notiz',
                        ),
                ),
                const SizedBox(height: AppSpacing.px12),
                _SectionPanel(
                  icon: Icons.check_box_outlined,
                  title: 'Todos',
                  isLoading: state is DashboardLoading,
                  child: loaded != null && loaded.todos.isNotEmpty
                      ? _TodoList(loaded.todos)
                      : const AppEmptyState(
                          icon: Icons.check_box_outlined,
                          title: 'Keine Todos',
                          description: 'Alle Aufgaben erledigt!',
                        ),
                ),
                const SizedBox(height: AppSpacing.px12),
                _SectionPanel(
                  icon: Icons.calendar_today_outlined,
                  title: 'Kalender',
                  isLoading: state is DashboardLoading,
                  child: loaded?.nextEvent != null
                      ? _EventPreview(loaded!.nextEvent!)
                      : const AppEmptyState(
                          icon: Icons.calendar_today_outlined,
                          title: 'Keine Termine',
                          description: 'Freier Tag!',
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Kompakte horizontale Leiste der drei Panels für Tablet-Ansicht.
class SupplementaryPanelsCompact extends StatelessWidget {
  const SupplementaryPanelsCompact({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final loaded = state is DashboardLoaded ? state : null;
        return Container(
          height: 80,
          color: AppColors.slate50,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.px16,
            vertical: AppSpacing.px10,
          ),
          child: Row(
            children: [
              Expanded(
                child: _CompactTile(
                  icon: Icons.description_outlined,
                  label: 'Notizen',
                  value: loaded?.lastNote?.title ?? '–',
                ),
              ),
              const SizedBox(width: AppSpacing.px8),
              Expanded(
                child: _CompactTile(
                  icon: Icons.check_box_outlined,
                  label: 'Todos',
                  value: loaded != null ? '${loaded.todos.length}' : '–',
                ),
              ),
              const SizedBox(width: AppSpacing.px8),
              Expanded(
                child: _CompactTile(
                  icon: Icons.calendar_today_outlined,
                  label: 'Kalender',
                  value: loaded?.nextEvent != null
                      ? DateFormat('HH:mm').format(loaded!.nextEvent!.startTime)
                      : '–',
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Content Widgets ───────────────────────────────────────────────────────────

class _NotePreview extends StatelessWidget {
  const _NotePreview(this.note);

  final NoteItem note;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.px12),
      child: Row(
        children: [
          const Icon(
            Icons.article_outlined,
            size: 16,
            color: AppColors.slate400,
          ),
          const SizedBox(width: AppSpacing.px8),
          Expanded(
            child: Text(
              note.title,
              style: AppTypography.bodySm,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _TodoList extends StatelessWidget {
  const _TodoList(this.todos);

  final List<TodoItem> todos;

  @override
  Widget build(BuildContext context) {
    final items = todos.take(5).toList();
    return Column(
      children: [
        for (final t in items)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.px12,
              AppSpacing.px8,
              AppSpacing.px12,
              0,
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.radio_button_unchecked,
                  size: 14,
                  color: AppColors.slate400,
                ),
                const SizedBox(width: AppSpacing.px8),
                Expanded(
                  child: Text(
                    t.title,
                    style: AppTypography.bodySm,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.px8),
      ],
    );
  }
}

class _EventPreview extends StatelessWidget {
  const _EventPreview(this.event);

  final CalendarEventItem event;

  @override
  Widget build(BuildContext context) {
    final local = event.startTime.toLocal();
    final dateStr = DateFormat('dd.MM.yyyy').format(local);
    final timeStr = DateFormat('HH:mm').format(local);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.px12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$dateStr · $timeStr Uhr',
            style: AppTypography.labelSm.copyWith(color: AppColors.slate400),
          ),
          const SizedBox(height: AppSpacing.px4),
          Text(
            event.title,
            style: AppTypography.bodySm,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ── Private Layout Widgets ────────────────────────────────────────────────────

class _SectionPanel extends StatelessWidget {
  const _SectionPanel({
    required this.icon,
    required this.title,
    required this.child,
    this.isLoading = false,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final bool isLoading;

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
              AppSpacing.px16,
              AppSpacing.px12,
              AppSpacing.px16,
              AppSpacing.px8,
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: AppColors.slate500),
                const SizedBox(width: AppSpacing.px8),
                Text(title, style: AppTypography.labelSm),
                if (isLoading) ...[
                  const Spacer(),
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 1.5),
                  ),
                ],
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
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

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
          Expanded(child: Text(label, style: AppTypography.bodySm)),
          Text(
            value,
            style: AppTypography.labelSm.copyWith(color: AppColors.slate400),
          ),
        ],
      ),
    );
  }
}
