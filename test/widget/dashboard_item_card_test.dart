import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/domain/entities/dashboard_item.dart';
import 'package:isef01_second_brain_frontend/features/dashboard/presentation/widgets/dashboard_item_card.dart';

// Widget Tests prüfen ob ein Widget korrekt gerendert wird.
// Sie brauchen kein Backend — die Daten werden direkt übergeben.
// Langsamer als Unit Tests, aber schneller als Integration Tests.
void main() {
  group('DashboardItemCard', () {
    testWidgets('zeigt Titel und Service-Name an', (tester) async {
      const item = NoteItem(
        id: '1',
        title: 'Meine erste Notiz',
        sourceService: 'notion',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: DashboardItemCard(item: item)),
        ),
      );

      expect(find.text('Meine erste Notiz'), findsOneWidget);
      expect(find.text('notion'), findsOneWidget);
    });
  });
}
