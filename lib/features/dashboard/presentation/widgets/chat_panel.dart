import 'package:flutter/material.dart';
import 'package:isef01_second_brain_frontend/core/design_system/design_system.dart';

/// Zentrales Chat-Panel des Dashboards.
///
/// Ist die Hauptkomponente der App — über den Chat erfasst der Nutzer
/// Notizen, Todos und Termine. Phase 7 implementiert hier Streaming und
/// echte Nachrichten; bis dahin zeigt das Panel den Platzhalter-Zustand.
class ChatPanel extends StatefulWidget {
  const ChatPanel({super.key});

  @override
  State<ChatPanel> createState() => _ChatPanelState();
}

class _ChatPanelState extends State<ChatPanel> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          _ChatHeader(),
          const Divider(height: 1, color: AppColors.slate200),
          Expanded(child: _MessageArea(scrollController: _scrollController)),
          const Divider(height: 1, color: AppColors.slate200),
          _InputArea(controller: _controller),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _ChatHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.px20,
        vertical: AppSpacing.px12,
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
              Icons.auto_awesome_rounded,
              color: AppColors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: AppSpacing.px12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AI Assistent', style: AppTypography.h4),
              Text(
                'Second Brain',
                style: AppTypography.body11.copyWith(color: AppColors.slate400),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Message Area ──────────────────────────────────────────────────────────────

class _MessageArea extends StatelessWidget {
  const _MessageArea({required this.scrollController});

  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(AppSpacing.px20),
      children: [
        _AssistantBubble(
          text:
              'Hallo! Ich bin dein Second Brain Assistent. '
              'Ich kann dir helfen, Notizen zu erstellen, '
              'Todos zu verwalten und deine Termine zu überblicken.\n\n'
              'Was kann ich für dich tun?',
          time: _currentTime(),
        ),
        const SizedBox(height: AppSpacing.px20),
        Text(
          'Beispiel-Anfragen:',
          style: AppTypography.bodyXs.copyWith(color: AppColors.slate400),
        ),
        const SizedBox(height: AppSpacing.px10),
        const Wrap(
          spacing: AppSpacing.px8,
          runSpacing: AppSpacing.px8,
          children: [
            _SuggestionChip('Was steht heute an?'),
            _SuggestionChip('Erstelle eine Notiz: Meeting-Ideen'),
            _SuggestionChip('Zeige hochprioräre Todos'),
            _SuggestionChip('Suche nach "Second Brain"'),
          ],
        ),
      ],
    );
  }

  static String _currentTime() {
    final now = DateTime.now();
    final h = now.hour.toString().padLeft(2, '0');
    final m = now.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

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

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      onTap: () {},
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.px16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: AppTypography.bodySm,
              decoration: InputDecoration(
                hintText: 'Nachricht schreiben...',
                hintStyle: AppTypography.bodySm.copyWith(
                  color: AppColors.slate400,
                ),
                filled: true,
                fillColor: AppColors.slate50,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.px16,
                  vertical: AppSpacing.px12,
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
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.px10),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.send_rounded,
                size: 18,
                color: AppColors.white,
              ),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
