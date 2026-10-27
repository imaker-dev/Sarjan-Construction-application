import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarjan_construction/core/theme/app_color_scheme.dart';
import 'package:sarjan_construction/core/theme/bloc/theme_bloc.dart';
import 'package:sarjan_construction/core/theme/bloc/theme_event.dart';
import 'package:sarjan_construction/core/theme/bloc/theme_state.dart';
import 'package:sarjan_construction/core/utils/size_util.dart';

class ThemeSelectionScreen extends StatelessWidget {
  const ThemeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SELECT THEME',
          style: TextStyle(
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              theme.brightness == Brightness.dark ? Icons.dark_mode : Icons.light_mode,
            ),
            tooltip: 'Toggle Dark Mode',
            onPressed: () {
              context.read<ThemeBloc>().add(const ToggleThemeMode());
            },
          ),
        ],
      ),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return ListView.separated(
            padding: EdgeInsets.symmetric(
              horizontal: context.w(4),
              vertical: context.h(2),
            ),
            itemCount: AppColorTheme.values.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final colorTheme = AppColorTheme.values[index];
              final isSelected = themeState.colorTheme == colorTheme;

              return _ThemeBannerCard(
                colorTheme: colorTheme,
                isSelected: isSelected,
                onTap: () {
                  context.read<ThemeBloc>().add(ChangeThemeColor(colorTheme));
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _ThemeBannerCard extends StatelessWidget {
  final AppColorTheme colorTheme;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeBannerCard({
    required this.colorTheme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryHex =
        '#${colorTheme.primary.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
    final secondaryHex =
        '#${colorTheme.secondary.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              colorTheme.primary,
              colorTheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colorTheme.primary.withValues(alpha: isSelected ? 0.45 : 0.22),
              blurRadius: isSelected ? 18 : 10,
              offset: const Offset(0, 6),
            ),
          ],
          border: isSelected
              ? Border.all(color: Colors.white, width: 2.5)
              : Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            children: [
              // Subtle background ambient light / texture circles
              Positioned(
                top: -30,
                right: -20,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Positioned(
                bottom: -40,
                left: -20,
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.06),
                  ),
                ),
              ),

              // Content inside card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Row with Left Tag & Right Pill Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left Pill: Color code & icon
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.palette_outlined,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                primaryHex,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right Pill Button: ACTIVE or SELECT
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withValues(alpha: 0.22),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isSelected) ...[
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: 14,
                                  color: colorTheme.primary,
                                ),
                                const SizedBox(width: 4),
                              ],
                              Text(
                                isSelected ? 'ACTIVE' : 'SELECT',
                                style: TextStyle(
                                  color: isSelected ? colorTheme.primary : Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Center & Bottom Typography
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          colorTheme.name.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 3.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$primaryHex  •  $secondaryHex',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
