import 'package:flutter/material.dart';

/// Liste aller bisherigen Chat-Eingaben mit Pagination.
/// TODO(phase-8): BlocBuilder + infinite scroll implementieren.
class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Historie — Phase 8')));
}
