import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sarjan_construction/core/theme/app_color_scheme.dart';
import 'package:sarjan_construction/core/theme/bloc/theme_bloc.dart';
import 'package:sarjan_construction/core/theme/bloc/theme_event.dart';
import 'package:sarjan_construction/core/theme/bloc/theme_state.dart';
import 'package:sarjan_construction/core/utils/size_util.dart';
import 'package:sarjan_construction/core/widgets/app_button.dart';
import 'package:sarjan_construction/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sarjan_construction/features/auth/presentation/bloc/auth_event.dart';
import 'package:sarjan_construction/features/home/presentation/screens/home_screen.dart';
import 'package:sarjan_construction/features/home/presentation/screens/theme_selection_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
        selectedItemColor: theme.colorScheme.primary,
      ),
    );
  }
}

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          final currentTheme = themeState.colorTheme;

          return ListView(
            padding: context.pAll(4),
            children: [
              // Theme Selection Container (On tap opens ThemeSelectionScreen)
              Text(
                'Appearance & Theme',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),

              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ThemeSelectionScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: currentTheme.primary.withValues(alpha: 0.35),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: currentTheme.primary.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Gradient Avatar Icon
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              currentTheme.primary,
                              currentTheme.secondary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
                          Icons.palette_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Theme Name & Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Color Theme',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Active: ${currentTheme.label}',
                              style: TextStyle(
                                fontSize: 13,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Swatches Preview + Arrow
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentTheme.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentTheme.secondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Dark Mode Card
              Card(
                elevation: 0,
                color: theme.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: SwitchListTile(
                  title: const Text(
                    'Dark Mode',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    themeState.isDarkMode ? 'Dark mode enabled' : 'Light mode enabled',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  secondary: Icon(
                    themeState.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    color: theme.colorScheme.primary,
                  ),
                  value: themeState.isDarkMode,
                  onChanged: (_) {
                    context.read<ThemeBloc>().add(const ToggleThemeMode());
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Status Tokens Section
              Text(
                'System Color Tokens',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatusBadge(label: 'Success', color: AppPalette.success),
                    _StatusBadge(label: 'Danger', color: AppPalette.danger),
                    _StatusBadge(label: 'Warning', color: AppPalette.warning),
                    _StatusBadge(label: 'Info', color: AppPalette.info),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Logout Button
              AppButton(
                text: 'Sign Out',
                isOutlined: true,
                icon: Icons.logout_rounded,
                onPressed: () {
                  context.read<AuthBloc>().add(const LogoutSubmitted());
                  context.go('/login');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
