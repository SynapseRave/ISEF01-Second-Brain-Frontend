import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isef01_second_brain_frontend/app/router.dart';
import 'package:isef01_second_brain_frontend/app/theme/app_theme.dart';
import 'package:isef01_second_brain_frontend/core/auth/auth_cubit.dart';
import 'package:isef01_second_brain_frontend/core/theme/theme_cubit.dart';

class SecondBrainApp extends StatefulWidget {
  const SecondBrainApp({
    super.key,
    required this.themeCubit,
    required this.authCubit,
  });

  final ThemeCubit themeCubit;
  final AuthCubit authCubit;

  @override
  State<SecondBrainApp> createState() => _SecondBrainAppState();
}

class _SecondBrainAppState extends State<SecondBrainApp> {
  late final _router = createRouter(widget.authCubit);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.themeCubit),
        BlocProvider.value(value: widget.authCubit),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            title: 'Second Brain',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
