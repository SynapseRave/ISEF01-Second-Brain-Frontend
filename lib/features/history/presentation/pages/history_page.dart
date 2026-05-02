import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isef01_second_brain_frontend/core/design_system/design_system.dart';
import 'package:isef01_second_brain_frontend/core/di/injection.dart';
import 'package:isef01_second_brain_frontend/core/widgets/app_loading_indicator.dart';
import 'package:isef01_second_brain_frontend/features/history/domain/entities/history_entry.dart';
import 'package:isef01_second_brain_frontend/features/history/presentation/bloc/history_cubit.dart';
import 'package:isef01_second_brain_frontend/features/history/presentation/bloc/history_state.dart';
import 'package:isef01_second_brain_frontend/features/history/presentation/widgets/history_entry_card.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HistoryCubit>()..loadHistory(),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(),
              Divider(height: 1, color: AppColors.slate200),
              Expanded(child: _HistoryBody()),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.px24,
        vertical: AppSpacing.px20,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.history_rounded,
            size: 22,
            color: AppColors.indigo600,
          ),
          const SizedBox(width: AppSpacing.px10),
          Text('Konversations-Verlauf', style: AppTypography.h3),
          const Spacer(),
          BlocBuilder<HistoryCubit, HistoryState>(
            builder: (context, state) {
              if (state is! HistoryLoaded) return const SizedBox.shrink();
              return Text(
                '${state.entries.length} Einträge',
                style: AppTypography.bodyXs,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HistoryBody extends StatelessWidget {
  const _HistoryBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        return switch (state) {
          HistoryInitial() || HistoryLoading() => const AppLoadingIndicator(),
          HistoryError(:final message) => AppErrorView(
              message: message,
              onRetry: () => context.read<HistoryCubit>().loadHistory(),
            ),
          HistoryLoaded() => _HistoryList(state: state),
        };
      },
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.state});
  final HistoryLoaded state;

  @override
  Widget build(BuildContext context) {
    if (state.entries.isEmpty) {
      return const AppEmptyState(
        icon: Icons.history_rounded,
        title: 'Noch keine Konversationen',
        description: 'Deine Chat-Verläufe erscheinen hier.',
      );
    }

    final groups = _groupByConversation(state.entries);
    final conversationIds = groups.keys.toList();

    return ListView.builder(
      padding: const EdgeInsets.only(
        top: AppSpacing.px8,
        bottom: AppSpacing.px24,
      ),
      itemCount: conversationIds.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == conversationIds.length) {
          return _LoadMoreButton(isLoading: state.isLoadingMore);
        }
        final id = conversationIds[index];
        final entries = groups[id]!;
        return _ConversationGroup(
          conversationId: id,
          entries: entries,
        );
      },
    );
  }

  static Map<String, List<HistoryEntry>> _groupByConversation(
    List<HistoryEntry> entries,
  ) {
    final map = <String, List<HistoryEntry>>{};
    for (final e in entries) {
      (map[e.conversationId] ??= []).add(e);
    }
    return map;
  }
}

class _ConversationGroup extends StatelessWidget {
  const _ConversationGroup({
    required this.conversationId,
    required this.entries,
  });

  final String conversationId;
  final List<HistoryEntry> entries;

  @override
  Widget build(BuildContext context) {
    final newest = entries.reduce(
      (a, b) => a.createdAt.isAfter(b.createdAt) ? a : b,
    );
    final label = _formatGroupDate(newest.createdAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.px16,
            AppSpacing.px16,
            AppSpacing.px16,
            AppSpacing.px6,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.chat_rounded,
                size: 14,
                color: AppColors.slate400,
              ),
              const SizedBox(width: AppSpacing.px6),
              Text(label, style: AppTypography.labelXs),
              const SizedBox(width: AppSpacing.px6),
              Text(
                '· ${entries.length} ${entries.length == 1 ? 'Eintrag' : 'Einträge'}',
                style: AppTypography.bodyXs,
              ),
            ],
          ),
        ),
        ...entries.map(
          (e) => HistoryEntryCard(
            entry: e,
            conversationEntries: entries,
          ),
        ),
      ],
    );
  }

  static String _formatGroupDate(DateTime dt) {
    final local = dt.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final entryDay = DateTime(local.year, local.month, local.day);
    final diff = today.difference(entryDay).inDays;

    if (diff == 0) return 'Heute';
    if (diff == 1) return 'Gestern';
    if (diff < 7) return 'Vor $diff Tagen';

    final d = local.day.toString().padLeft(2, '0');
    final m = local.month.toString().padLeft(2, '0');
    return '$d.$m.${local.year}';
  }
}

class _LoadMoreButton extends StatelessWidget {
  const _LoadMoreButton({required this.isLoading});
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.px16,
        vertical: AppSpacing.px16,
      ),
      child: Center(
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : AppButton(
                label: 'Mehr laden',
                icon: Icons.expand_more_rounded,
                variant: AppButtonVariant.secondary,
                onPressed: () => context.read<HistoryCubit>().loadMore(),
              ),
      ),
    );
  }
}
