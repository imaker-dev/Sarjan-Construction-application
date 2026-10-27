import 'package:flutter/material.dart';
import 'package:sarjan_construction/core/theme/app_color_scheme.dart';
import 'package:sarjan_construction/core/theme/app_theme.dart';

class ThemeState {
  final AppColorTheme colorTheme;
  final ThemeMode themeMode;

  const ThemeState({
    this.colorTheme = AppColorTheme.violet,
    this.themeMode = ThemeMode.light,
  });

  Color get primaryColor => colorTheme.primary;
  Color get secondaryColor => colorTheme.secondary;

  ThemeData get lightTheme => AppTheme.light(colorTheme);
  ThemeData get darkTheme => AppTheme.dark(colorTheme);

  bool get isDarkMode => themeMode == ThemeMode.dark;

  ThemeState copyWith({
    AppColorTheme? colorTheme,
    ThemeMode? themeMode,
  }) {
    return ThemeState(
      colorTheme: colorTheme ?? this.colorTheme,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
