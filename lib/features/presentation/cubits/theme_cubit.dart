import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeState(themeMode: ThemeMode.light));

  void toggleTheme() {
    final newThemeMode = state.themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    emit(ThemeState(themeMode: newThemeMode));
  }

  void setTheme(ThemeMode themeMode) {
    emit(ThemeState(themeMode: themeMode));
  }
}