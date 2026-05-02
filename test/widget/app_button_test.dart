import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isef01_second_brain_frontend/core/design_system/widgets/app_button.dart';

void main() {
  group('AppButton', () {
    testWidgets('primary: zeigt Label an und reagiert auf Tap', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(label: 'Speichern', onPressed: () => tapped = true),
          ),
        ),
      );

      expect(find.text('Speichern'), findsOneWidget);
      await tester.tap(find.byType(AppButton));
      expect(tapped, isTrue);
    });

    testWidgets('secondary: zeigt Label an', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: 'Abbrechen',
              onPressed: () {},
              variant: AppButtonVariant.secondary,
            ),
          ),
        ),
      );

      expect(find.text('Abbrechen'), findsOneWidget);
    });

    testWidgets('disabled wenn onPressed null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppButton(label: 'Gesperrt')),
        ),
      );

      // FilledButton ist disabled wenn onPressed null
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('ghost icon-only: kein Label, Icon sichtbar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton.icon(icon: Icons.add, onPressed: () {}),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text(''), findsNothing);
    });

    testWidgets('primary mit Icon zeigt Icon und Label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              label: 'Hinzufügen',
              icon: Icons.add,
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(find.text('Hinzufügen'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });
  });
}
