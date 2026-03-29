import 'package:flutter/material.dart';

/// Zentrierter Ladeindikator — wird app-weit fuer Loading-States verwendet.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}
