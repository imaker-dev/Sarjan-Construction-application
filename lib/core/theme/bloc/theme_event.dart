import 'package:flutter/material.dart';
import 'package:sarjan_construction/core/theme/app_color_scheme.dart';

abstract class ThemeEvent {
  const ThemeEvent();
}

class ChangeThemeColor extends ThemeEvent {
  final AppColorTheme colorTheme;
  const ChangeThemeColor(this.colorTheme);
}

class ChangeThemeMode extends ThemeEvent {
  final ThemeMode mode;
  const ChangeThemeMode(this.mode);
}

class ToggleThemeMode extends ThemeEvent {
  const ToggleThemeMode();
}
