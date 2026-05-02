import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:isef01_second_brain_frontend/app/router.dart';
import 'package:isef01_second_brain_frontend/core/design_system/design_system.dart';
import 'package:isef01_second_brain_frontend/features/chat/presentation/bloc/chat_cubit.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/entities/history_entry.dart';
import 'package:isef01_second_brain_frontend/features/history/presentation/bloc/history_cubit.dart';

class HistoryEntryCard extends StatelessWidget {
  const HistoryEntryCard({
    super.key,
    required this.entry,
    required this.conversationEntries,
  });

  final HistoryEntry entry;

  /// Alle Einträge der gleichen conversationId — für loadConversation benötigt.
  final List<HistoryEntry> conversationEntries;

  @override
  Widget build(BuildContext context) {
    final timestamp = _formatTimestamp(entry.createdAt);

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.px16,
        vertical: AppSpacing.px4,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.slate200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.px12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(timestamp, style: AppTypography.timestamp),
                      if (entry.tool != null) ...[
                        const SizedBox(width: AppSpacing.px6),
                        _ToolBadge(tool: entry.tool!),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.px4),
                  Text(
                    entry.prompt,
                    style: AppTypography.bodySm
                        .copyWith(color: AppColors.slate800),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (entry.response != null) ...[
                    const SizedBox(height: AppSpacing.px2),
                    Text(
                      entry.response!,
                      style: AppTypography.bodyXs,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.px8),
            _ActionButtons(
              entry: entry,
              conversationEntries: conversationEntries,
            ),
          ],
        ),
      ),
    );
  }

  static String _formatTimestamp(DateTime dt) {
    final local = dt.toLocal();
    final d = local.day.toString().padLeft(2, '0');
    final m = local.month.toString().padLeft(2, '0');
    final y = local.year;
    final h = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');
    return '$d.$m.$y, $h:$min';
  }
}

class _ToolBadge extends StatelessWidget {
  const _ToolBadge({required this.tool});
  final String tool;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.px6,
        vertical: AppSpacing.px2,
      ),
      decoration: BoxDecoration(
        color: AppColors.infoLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
      ),
      child: Text(
        tool,
        style: AppTypography.body10.copyWith(color: AppColors.info),
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.entry,
    required this.conversationEntries,
  });

  final HistoryEntry entry;
  final List<HistoryEntry> conversationEntries;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: 'Weiter chatten',
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            onTap: () {
              context.read<ChatCubit>().loadConversation(
                    entry.conversationId,
                    conversationEntries,
                  );
              context.go(AppRoutes.dashboard);
            },
            child: const Padding(
              padding: EdgeInsets.all(AppSpacing.px6),
              child: Icon(
                Icons.chat_bubble_outline_rounded,
                size: 18,
                color: AppColors.indigo500,
              ),
            ),
          ),
        ),
        Tooltip(
          message: 'Löschen',
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            onTap: () => _confirmDelete(context),
            child: const Padding(
              padding: EdgeInsets.all(AppSpacing.px6),
              child: Icon(
                Icons.delete_outline_rounded,
                size: 18,
                color: AppColors.slate400,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await AppConfirmDialog.show(
      context,
      title: 'Eintrag löschen',
      message: 'Dieser Konversationseintrag wird dauerhaft entfernt.',
    );
    if (confirmed == true && context.mounted) {
      context.read<HistoryCubit>().deleteEntry(entry.id);
    }
  }
}
