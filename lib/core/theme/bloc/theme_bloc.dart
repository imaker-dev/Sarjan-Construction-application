import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarjan_construction/core/theme/app_color_scheme.dart';
import 'package:sarjan_construction/core/theme/bloc/theme_event.dart';
import 'package:sarjan_construction/core/theme/bloc/theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc({AppColorTheme initialTheme = AppColorTheme.violet})
      : super(ThemeState(colorTheme: initialTheme)) {
    on<ChangeThemeColor>((event, emit) {
      emit(state.copyWith(colorTheme: event.colorTheme));
    });

    on<ChangeThemeMode>((event, emit) {
      emit(state.copyWith(themeMode: event.mode));
    });

    on<ToggleThemeMode>((event, emit) {
      final nextMode = state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
      emit(state.copyWith(themeMode: nextMode));
    });
  }
}
