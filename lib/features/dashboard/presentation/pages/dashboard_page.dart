import 'package:flutter/material.dart';

/// Haupt-Dashboard: Notizen, Todos und Kalendereintraege.
/// TODO(phase-5): BlocBuilder einbauen, echte Daten anzeigen.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Dashboard — Phase 5')));
}
