import 'package:flutter/material.dart';

class SecondBrainApp extends StatelessWidget {
  const SecondBrainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Second Brain',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Second Brain')),
        body: const Center(
          child: Text('Projekt erfolgreich eingerichtet'),
        ),
      ),
    );
  }
}