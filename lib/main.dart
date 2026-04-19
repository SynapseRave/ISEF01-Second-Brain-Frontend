import 'package:flutter/material.dart';
import 'package:isef01_second_brain_frontend/app/app.dart';
import 'package:isef01_second_brain_frontend/core/di/injection.dart';
import 'package:isef01_second_brain_frontend/core/theme/theme_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  final themeCubit = await ThemeCubit.create();
  runApp(SecondBrainApp(themeCubit: themeCubit));
}
