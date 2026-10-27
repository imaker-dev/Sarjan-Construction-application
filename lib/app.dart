import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sarjan_construction/core/config/app_flavor.dart';
import 'package:sarjan_construction/core/router/app_router.dart';
import 'package:sarjan_construction/core/theme/bloc/theme_bloc.dart';
import 'package:sarjan_construction/core/theme/bloc/theme_state.dart';
import 'package:sarjan_construction/features/auth/domain/repositories/auth_repository.dart';
import 'package:sarjan_construction/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sarjan_construction/features/auth/presentation/bloc/auth_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SarjanApp extends StatefulWidget {
  final AuthRepository authRepository;
  final SharedPreferences prefs;

  const SarjanApp({
    super.key,
    required this.authRepository,
    required this.prefs,
  });

  @override
  State<SarjanApp> createState() => _SarjanAppState();
}

class _SarjanAppState extends State<SarjanApp> {
  late final AuthBloc _authBloc;
  late final ThemeBloc _themeBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _themeBloc = ThemeBloc();
    _authBloc = AuthBloc(authRepository: widget.authRepository)
      ..add(const CheckAuthStatus());

    _router = AppRouter.createRouter(
      authBloc: _authBloc,
    );
  }

  @override
  void dispose() {
    _authBloc.close();
    _themeBloc.close();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>.value(value: _themeBloc),
        BlocProvider<AuthBloc>.value(value: _authBloc),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: AppConfig.instance.appTitle,
            debugShowCheckedModeBanner: !AppConfig.instance.isProd,
            theme: themeState.lightTheme,
            darkTheme: themeState.darkTheme,
            themeMode: themeState.themeMode,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
