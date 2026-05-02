import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isef01_second_brain_frontend/features/chat/domain/entities/message.dart';
import 'package:isef01_second_brain_frontend/features/chat/presentation/widgets/message_bubble.dart';

void main() {
  group('MessageBubble', () {
    testWidgets('zeigt Inhalt einer User-Nachricht an', (tester) async {
      final message = Message(
        id: '1',
        role: MessageRole.user,
        content: 'Hallo Welt',
        createdAt: DateTime(2024),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: MessageBubble(message: message)),
        ),
      );

      expect(find.text('Hallo Welt'), findsOneWidget);
    });

    testWidgets('User-Nachricht wird rechts ausgerichtet', (tester) async {
      final message = Message(
        id: '1',
        role: MessageRole.user,
        content: 'User',
        createdAt: DateTime(2024),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: MessageBubble(message: message)),
        ),
      );

      final align = tester.widget<Align>(find.byType(Align));
      expect(align.alignment, Alignment.centerRight);
    });

    testWidgets('Assistant-Nachricht wird links ausgerichtet', (tester) async {
      final message = Message(
        id: '2',
        role: MessageRole.assistant,
        content: 'Antwort vom Bot',
        createdAt: DateTime(2024),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: MessageBubble(message: message)),
        ),
      );

      expect(find.text('Antwort vom Bot'), findsOneWidget);
      final align = tester.widget<Align>(find.byType(Align));
      expect(align.alignment, Alignment.centerLeft);
    });
  });
}
