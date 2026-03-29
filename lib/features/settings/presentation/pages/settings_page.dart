import 'package:flutter/material.dart';

/// Einstellungsseite: Dienste verbinden/trennen, Theme-Toggle.
/// TODO(phase-4): BlocBuilder + OAuth-Flows einbauen.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Einstellungen — Phase 4')));
}
