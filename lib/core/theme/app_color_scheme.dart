import 'package:flutter/material.dart';

enum AppColorTheme {
  violet(
    label: 'Violet (Default)',
    primary: Color(0xFF753CEF),
    secondary: Color(0xFFB63CEF),
  ),
  blue(
    label: 'Blue',
    primary: Color(0xFF5D87FF),
    secondary: Color(0xFF44B7F7),
  ),
  emerald(
    label: 'Emerald',
    primary: Color(0xFF10B981),
    secondary: Color(0xFF06B6D4),
  ),
  rose(
    label: 'Rose',
    primary: Color(0xFFE11D48),
    secondary: Color(0xFFF43F5E),
  ),
  orange(
    label: 'Orange',
    primary: Color(0xFFF97316),
    secondary: Color(0xFFF59E0B),
  );

  final String label;
  final Color primary;
  final Color secondary;

  const AppColorTheme({
    required this.label,
    required this.primary,
    required this.secondary,
  });

  Color get color => primary;

  static AppColorTheme fromName(String name) {
    return AppColorTheme.values.firstWhere(
      (t) => t.name.toLowerCase() == name.toLowerCase(),
      orElse: () => AppColorTheme.violet,
    );
  }
}

class AppPalette {
  AppPalette._();

  // Status Tokens (Semantic)
  static const Color success = Color(0xFF22C55E);
  static const Color danger = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Dark-Mode Tokens
  static const Color darkBackground = Color(0xFF1C2536);
  static const Color darkDialog = Color(0xFF202B3E);
  static const Color darkForeground = Color(0xFFF8FAFC);
  static const Color darkMuted = Color(0xFF94A3B8);

  // Neutral Tokens
  static const Color grey100 = Color(0xFFFAF9FB);
  static const Color grey200 = Color(0xFFF4F2F6);
  static const Color grey300 = Color(0xFFE9E7ED);
  static const Color grey400 = Color(0xFFD4D1DA);
  static const Color grey500 = Color(0xFFAAA6B2);
  static const Color grey600 = Color(0xFF817C8B);
  static const Color grey700 = Color(0xFF625D6B);
  static const Color grey800 = Color(0xFF45414D);
  static const Color grey900 = Color(0xFF29262F);
}
