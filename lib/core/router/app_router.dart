import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sarjan_construction/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sarjan_construction/features/auth/presentation/screens/login_screen.dart';
import 'package:sarjan_construction/features/home/presentation/screens/main_nav_screen.dart';
import 'package:sarjan_construction/features/home/presentation/screens/theme_selection_screen.dart';

class AppRouter {
  AppRouter._();

  static GoRouter createRouter({
    required AuthBloc authBloc,
  }) {
    return GoRouter(
      initialLocation: '/login',
      debugLogDiagnostics: false,
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/main',
          builder: (context, state) => const MainNavScreen(),
        ),
        GoRoute(
          path: '/theme-selection',
          builder: (context, state) => const ThemeSelectionScreen(),
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Text('Route not found: ${state.uri.path}'),
        ),
      ),
    );
  }
}
