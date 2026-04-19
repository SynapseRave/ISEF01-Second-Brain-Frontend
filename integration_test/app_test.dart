import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:isef01_second_brain_frontend/app/app.dart';
import 'package:isef01_second_brain_frontend/core/theme/theme_cubit.dart';
import 'package:flutter/material.dart';

// Integration Tests laufen auf einem echten Gerät oder Emulator.
// Sie testen komplette User Flows von Anfang bis Ende.
// Sind am langsamsten, prüfen aber das Zusammenspiel aller Schichten.
//
// Starten mit: flutter test integration_test/
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App smoke test', () {
    testWidgets('App startet ohne Fehler', (tester) async {
      final themeCubit = await ThemeCubit.create();

      await tester.pumpWidget(SecondBrainApp(themeCubit: themeCubit));
      await tester.pumpAndSettle();

      expect(find.byType(MaterialApp), findsOneWidget);

      addTearDown(themeCubit.close);
    });
  });
}
