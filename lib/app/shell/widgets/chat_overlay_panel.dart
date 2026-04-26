import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isef01_second_brain_frontend/core/design_system/design_system.dart';
import 'package:isef01_second_brain_frontend/features/chat/domain/entities/message.dart';
import 'package:isef01_second_brain_frontend/features/chat/presentation/bloc/chat_cubit.dart';
import 'package:isef01_second_brain_frontend/features/chat/presentation/bloc/chat_state.dart';

/// Persistentes Chat-Panel, das über dem Haupt-Inhalt eingeblendet wird.
///
/// Auf Desktop erscheint es als Seitenbereich (rechts, 360 px),
/// auf Mobile als Modal-BottomSheet.
class ChatOverlayPanel extends StatefulWidget {
  const ChatOverlayPanel({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  State<ChatOverlayPanel> createState() => _ChatOverlayPanelState();
}

class _ChatOverlayPanelState extends State<ChatOverlayPanel> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: const Border(left: BorderSide(color: AppColors.slate200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(-4, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _Header(onClose: widget.onClose),
          const Divider(height: 1),
          const Expanded(child: _MessageArea()),
          const Divider(height: 1),
          _InputArea(controller: _controller),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.px16,
        vertical: AppSpacing.px12,
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: AppSpacing.px10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Assistent', style: AppTypography.h4),
                Text(
                  'Second Brain',
                  style: AppTypography.body11.copyWith(
                    color: AppColors.slate400,
                  ),
                ),
              ],
            ),
          ),
          AppButton.icon(icon: Icons.close_rounded, onPressed: onClose),
        ],
      ),
    );
  }
}

// ── Message Area ──────────────────────────────────────────────────────────────

class _MessageArea extends StatefulWidget {
  const _MessageArea();

  @override
  State<_MessageArea> createState() => _MessageAreaState();
}

class _MessageAreaState extends State<_MessageArea> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listenWhen: (prev, curr) =>
          prev.messages.length != curr.messages.length ||
          (curr.isStreaming &&
              prev.streamingContent != curr.streamingContent) ||
          (prev.error == null && curr.error != null),
      listener: (_, _) => _scrollToBottom(),
      builder: (context, state) {
        if (state.messages.isEmpty &&
            !state.isStreaming &&
            state.error == null) {
          return _buildWelcome(context);
        }
        return ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.all(AppSpacing.px16),
          itemCount:
              state.messages.length +
              (state.isStreaming ? 1 : 0) +
              (state.isStreaming && state.statusMessage != null ? 1 : 0) +
              (!state.isStreaming && state.error != null ? 1 : 0),
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.px10),
          itemBuilder: (context, i) {
            final messageCount = state.messages.length;
            final hasStatus = state.statusMessage != null;

            // Fehler-Bubble am Ende (nur wenn nicht mehr streamend)
            if (!state.isStreaming &&
                state.error != null &&
                i == messageCount) {
              return _ErrorBubble(message: state.error!);
            }

            // Status-Zeile direkt vor der Streaming-Bubble
            if (state.isStreaming && hasStatus && i == messageCount) {
              return Padding(
                padding: const EdgeInsets.only(left: 42),
                child: Text(
                  state.statusMessage!,
                  style: AppTypography.bodyXs.copyWith(
                    color: AppColors.slate400,
                  ),
                ),
              );
            }

            // Streaming-Bubble (letzte Position)
            if (state.isStreaming && i >= messageCount) {
              if (state.streamingContent.isEmpty) {
                return const _TypingIndicator();
              }
              return _AssistantBubble(
                text: state.streamingContent,
                time: _formatTime(DateTime.now()),
              );
            }

            // Normale Nachricht
            final msg = state.messages[i];
            return msg.role == MessageRole.user
                ? _UserBubble(
                    text: msg.content,
                    time: _formatTime(msg.createdAt),
                  )
                : _AssistantBubble(
                    text: msg.content,
                    time: _formatTime(msg.createdAt),
                  );
          },
        );
      },
    );
  }

  Widget _buildWelcome(BuildContext context) {
    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSpacing.px16),
      children: [
        _AssistantBubble(
          text:
              'Hallo! Ich bin dein Second Brain Assistent. '
              'Ich kann dir helfen, Notizen zu erstellen, '
              'Todos zu verwalten und deine Termine zu überblicken.\n\n'
              'Was kann ich für dich tun?',
          time: _formatTime(DateTime.now()),
        ),
        const SizedBox(height: AppSpacing.px16),
        Text(
          'Beispiel-Anfragen:',
          style: AppTypography.bodyXs.copyWith(color: AppColors.slate400),
        ),
        const SizedBox(height: AppSpacing.px8),
        Wrap(
          spacing: AppSpacing.px8,
          runSpacing: AppSpacing.px8,
          children: const [
            _SuggestionChip('Was steht heute an?'),
            _SuggestionChip('Erstelle eine Notiz: Meeting-Ideen'),
            _SuggestionChip('Zeige hochprioräre Todos'),
            _SuggestionChip('Suche nach "Second Brain"'),
          ],
        ),
      ],
    );
  }

  static String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

// ── Bubbles ───────────────────────────────────────────────────────────────────

class _AssistantBubble extends StatelessWidget {
  const _AssistantBubble({required this.text, required this.time});
  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.white,
            size: 16,
          ),
        ),
        const SizedBox(width: AppSpacing.px10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.px12),
            decoration: BoxDecoration(
              color: AppColors.slate50,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(AppSpacing.radiusLg),
                bottomLeft: Radius.circular(AppSpacing.radiusLg),
                bottomRight: Radius.circular(AppSpacing.radiusLg),
              ),
              border: Border.all(color: AppColors.slate200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: AppTypography.bodySm),
                const SizedBox(height: AppSpacing.px6),
                Text(time, style: AppTypography.timestamp),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _UserBubble extends StatelessWidget {
  const _UserBubble({required this.text, required this.time});
  final String text;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.px12),
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.radiusLg),
                topRight: Radius.circular(AppSpacing.radiusLg),
                bottomLeft: Radius.circular(AppSpacing.radiusLg),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  text,
                  style: AppTypography.bodySm.copyWith(color: AppColors.white),
                ),
                const SizedBox(height: AppSpacing.px6),
                Text(
                  time,
                  style: AppTypography.timestamp.copyWith(
                    color: AppColors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          ),
          child: const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.white,
            size: 16,
          ),
        ),
        const SizedBox(width: AppSpacing.px10),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.px12,
            vertical: AppSpacing.px12,
          ),
          decoration: BoxDecoration(
            color: AppColors.slate50,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(AppSpacing.radiusLg),
              bottomLeft: Radius.circular(AppSpacing.radiusLg),
              bottomRight: Radius.circular(AppSpacing.radiusLg),
            ),
            border: Border.all(color: AppColors.slate200),
          ),
          child: Text(
            '...',
            style: AppTypography.bodySm.copyWith(color: AppColors.slate400),
          ),
        ),
      ],
    );
  }
}

class _ErrorBubble extends StatelessWidget {
  const _ErrorBubble({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.px12,
        vertical: AppSpacing.px10,
      ),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.error),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 16,
            color: AppColors.error,
          ),
          const SizedBox(width: AppSpacing.px8),
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodySm.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      onTap: () => context.read<ChatCubit>().sendMessage(label),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.px10,
          vertical: AppSpacing.px6,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(color: AppColors.slate200),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Text(label, style: AppTypography.body11),
      ),
    );
  }
}

// ── Input Area ────────────────────────────────────────────────────────────────

class _InputArea extends StatelessWidget {
  const _InputArea({required this.controller});

  final TextEditingController controller;

  void _send(BuildContext context) {
    final text = controller.text.trim();
    if (text.isEmpty) return;
    controller.clear();
    context.read<ChatCubit>().sendMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    final isStreaming = context.select<ChatCubit, bool>(
      (c) => c.state.isStreaming,
    );

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.px12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: AppTypography.bodySm,
              enabled: !isStreaming,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(context),
              decoration: InputDecoration(
                hintText: isStreaming
                    ? 'Assistent antwortet...'
                    : 'Nachricht schreiben...',
                hintStyle: AppTypography.bodySm.copyWith(
                  color: AppColors.slate400,
                ),
                filled: true,
                fillColor: AppColors.slate50,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.px12,
                  vertical: AppSpacing.px10,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  borderSide: const BorderSide(color: AppColors.slate200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  borderSide: const BorderSide(
                    color: AppColors.indigo600,
                    width: 2,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  borderSide: const BorderSide(color: AppColors.slate100),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.px8),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: isStreaming ? null : AppColors.brandGradient,
              color: isStreaming ? AppColors.slate200 : null,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                isStreaming ? Icons.hourglass_top_rounded : Icons.send_rounded,
                size: 16,
                color: isStreaming ? AppColors.slate400 : AppColors.white,
              ),
              onPressed: isStreaming ? null : () => _send(context),
            ),
          ),
        ],
      ),
    );
  }
}
