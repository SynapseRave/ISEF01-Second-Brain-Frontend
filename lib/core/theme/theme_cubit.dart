import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Verwaltet den App-Theme (hell / dunkel) und persistiert die Auswahl.
///
/// Initialisierung vor dem ersten Frame:
/// ```dart
/// final cubit = await ThemeCubit.create();
/// ```
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit._(this._prefs) : super(_load(_prefs));

  static const _key = 'theme_mode';
  final SharedPreferences _prefs;

  /// Erstellt und initialisiert den Cubit — lädt die gespeicherte Einstellung.
  static Future<ThemeCubit> create() async {
    final prefs = await SharedPreferences.getInstance();
    return ThemeCubit._(prefs);
  }

  static ThemeMode _load(SharedPreferences prefs) {
    final stored = prefs.getString(_key);
    return switch (stored) {
      'dark'  => ThemeMode.dark,
      'light' => ThemeMode.light,
      _       => ThemeMode.system,
    };
  }

  void setLight() => _save(ThemeMode.light);
  void setDark()  => _save(ThemeMode.dark);

  void toggle() => state == ThemeMode.dark ? setLight() : setDark();

  void _save(ThemeMode mode) {
    _prefs.setString(_key, mode == ThemeMode.dark ? 'dark' : 'light');
    emit(mode);
  }
}
