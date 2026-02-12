
part of 'theme_cubit.dart';


class ThemeState {
  final ThemeMode themeMode;

  ThemeState({required this.themeMode});

  bool get isDarkMode => themeMode == ThemeMode.dark;
  bool get isLightMode => themeMode == ThemeMode.light;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ThemeState && other.themeMode == themeMode;
  }

  @override
  int get hashCode => themeMode.hashCode;
}