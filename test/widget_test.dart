import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sarjan_construction/core/config/app_urls.dart';
import 'package:sarjan_construction/core/theme/app_color_scheme.dart';
import 'package:sarjan_construction/core/theme/bloc/theme_bloc.dart';
import 'package:sarjan_construction/core/utils/size_util.dart';
import 'package:sarjan_construction/core/widgets/app_button.dart';
import 'package:sarjan_construction/core/widgets/app_text_field.dart';
import 'package:sarjan_construction/features/auth/domain/models/user.dart';
import 'package:sarjan_construction/features/auth/domain/repositories/auth_repository.dart';
import 'package:sarjan_construction/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:sarjan_construction/features/auth/presentation/screens/login_screen.dart';
import 'package:sarjan_construction/features/home/presentation/screens/home_screen.dart';
import 'package:sarjan_construction/features/home/presentation/screens/main_nav_screen.dart';
import 'package:sarjan_construction/features/home/presentation/screens/theme_selection_screen.dart';
import 'package:sarjan_construction/features/safety_dashboard/data/repositories/safety_dashboard_repository_impl.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/bloc/safety_dashboard_bloc.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/bloc/safety_dashboard_event.dart';

import 'package:sarjan_construction/features/safety_dashboard/presentation/screens/safety_alerts_screen.dart';
import 'package:sarjan_construction/features/safety_dashboard/presentation/screens/today_activities_screen.dart';

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<AuthUser?> getCurrentUser() async => null;

  @override
  Future<bool> isAuthenticated() async => false;

  @override
  Future<AuthUser> login({required String email, required String password}) async {
    return const AuthUser(
      id: '1',
      name: 'Admin',
      email: 'admin@imaker.com',
      role: 'admin',
    );
  }

  @override
  Future<void> logout() async {}
}

void main() {
  group('AppUrls Configuration Tests', () {
    test('AppUrls contains valid dev, staging and prod base URLs and core endpoints', () {
      expect(AppUrls.devBaseUrl, contains('dev-api'));
      expect(AppUrls.stagingBaseUrl, contains('staging-api'));
      expect(AppUrls.prodBaseUrl, contains('api.sarjanconstruction.com'));

      expect(AppUrls.login, equals('/auth/login'));
      expect(AppUrls.logout, equals('/auth/logout'));
      expect(AppUrls.privacyPolicy, contains('privacy'));
    });
  });

  group('Multi-Color Themes Tests', () {
    test('Themes match extracted PDF brand tokens', () {
      final violet = AppColorTheme.fromName('violet');
      expect(violet, equals(AppColorTheme.violet));
      expect(violet.primary, equals(const Color(0xFF753CEF)));
      expect(violet.secondary, equals(const Color(0xFFB63CEF)));

      final blue = AppColorTheme.fromName('blue');
      expect(blue.primary, equals(const Color(0xFF5D87FF)));

      final emerald = AppColorTheme.fromName('emerald');
      expect(emerald.primary, equals(const Color(0xFF10B981)));

      final rose = AppColorTheme.fromName('rose');
      expect(rose.primary, equals(const Color(0xFFE11D48)));

      final orange = AppColorTheme.fromName('orange');
      expect(orange.primary, equals(const Color(0xFFF97316)));

      expect(AppColorTheme.values.length, equals(5));

      final fallback = AppColorTheme.fromName('unknown');
      expect(fallback, equals(AppColorTheme.violet));
    });
  });

  group('HomeScreen & SizeUtil Tests', () {
    testWidgets('HomeScreen renders Safety Dashboard and navigates to separate screens', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final themeBloc = ThemeBloc();
      final authBloc = AuthBloc(authRepository: _FakeAuthRepository());
      final safetyBloc = SafetyDashboardBloc(repository: SafetyDashboardRepositoryImpl())
        ..add(const LoadSafetyDashboard());

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<ThemeBloc>.value(value: themeBloc),
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<SafetyDashboardBloc>.value(value: safetyBloc),
          ],
          child: const MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.qr_code_scanner_rounded), findsWidgets);
      expect(find.text('Key Site KPIs'), findsOneWidget);
      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.text('Register Labour'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Safety Alerts & Incidents'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('Safety Alerts & Incidents'), findsOneWidget);
      expect(find.text("Today's Schedule & Activities"), findsOneWidget);

      // Tap Safety Alerts tile to open separate SafetyAlertsScreen
      await tester.tap(find.text('Safety Alerts & Incidents'));
      await tester.pumpAndSettle();
      expect(find.byType(SafetyAlertsScreen), findsOneWidget);

      // Pop back to home
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Tap Today's Schedule tile to open separate TodayActivitiesScreen
      await tester.tap(find.text("Today's Schedule & Activities"));
      await tester.pumpAndSettle();
      expect(find.byType(TodayActivitiesScreen), findsOneWidget);
    });

    testWidgets('SizeUtil provides dynamic height, width and padding', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      late double calculatedW;
      late double calculatedH;
      late EdgeInsets calculatedPadding;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              calculatedW = context.w(50);
              calculatedH = context.h(25);
              calculatedPadding = context.pAll(5);
              return Container();
            },
          ),
        ),
      );

      expect(calculatedW, equals(400.0));
      expect(calculatedH, equals(300.0));
      expect(calculatedPadding, equals(const EdgeInsets.all(40.0)));
    });
  });

  group('Reusable Dynamic Widgets Tests', () {
    testWidgets('AppButton renders and handles tap and loading state', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Click Me',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
      await tester.tap(find.text('Click Me'));
      expect(tapped, isTrue);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Click Me',
              isLoading: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('AppTextField renders and handles password toggle', (tester) async {
      final controller = TextEditingController(text: 'secret');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              controller: controller,
              labelText: 'Password',
              isPassword: true,
            ),
          ),
        ),
      );

      expect(find.text('Password'), findsOneWidget);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('LoginScreen renders with branding, textfields and submit button', (tester) async {
      final authBloc = AuthBloc(authRepository: _FakeAuthRepository());

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<AuthBloc>.value(
            value: authBloc,
            child: const LoginScreen(),
          ),
        ),
      );

      expect(find.text('Imaker Construction'), findsOneWidget);
      expect(find.text('Email Address'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
    });
  });

  group('Theme Selection UI Tests', () {
    testWidgets('ThemeSelectionScreen renders all 5 theme banners with ACTIVE/SELECT labels', (tester) async {
      final themeBloc = ThemeBloc();

      await tester.pumpWidget(
        BlocProvider<ThemeBloc>.value(
          value: themeBloc,
          child: const MaterialApp(
            home: ThemeSelectionScreen(),
          ),
        ),
      );

      expect(find.text('SELECT THEME'), findsOneWidget);
      expect(find.text('VIOLET'), findsOneWidget);
      expect(find.text('BLUE'), findsOneWidget);
      expect(find.text('EMERALD'), findsOneWidget);
      expect(find.text('ROSE'), findsOneWidget);
      expect(find.text('ORANGE'), findsOneWidget);
      expect(find.text('ACTIVE'), findsOneWidget);

      // Tap on EMERALD to switch theme
      await tester.tap(find.text('EMERALD'));
      await tester.pumpAndSettle();

      expect(themeBloc.state.colorTheme, equals(AppColorTheme.emerald));
    });

    testWidgets('SettingsTab shows Color Theme container and opens ThemeSelectionScreen', (tester) async {
      final themeBloc = ThemeBloc();
      final authBloc = AuthBloc(authRepository: _FakeAuthRepository());

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<ThemeBloc>.value(value: themeBloc),
            BlocProvider<AuthBloc>.value(value: authBloc),
          ],
          child: const MaterialApp(
            home: SettingsTab(),
          ),
        ),
      );

      expect(find.text('Color Theme'), findsOneWidget);
      expect(find.text('Active: Violet (Default)'), findsOneWidget);

      // Tap the Color Theme container
      await tester.tap(find.text('Color Theme'));
      await tester.pumpAndSettle();

      // Should have pushed ThemeSelectionScreen
      expect(find.byType(ThemeSelectionScreen), findsOneWidget);
      expect(find.text('SELECT THEME'), findsOneWidget);
    });

    testWidgets('MainNavScreen renders all 5 bottom navigation tabs', (tester) async {
      final themeBloc = ThemeBloc();
      final authBloc = AuthBloc(authRepository: _FakeAuthRepository());
      final safetyBloc = SafetyDashboardBloc(repository: SafetyDashboardRepositoryImpl())
        ..add(const LoadSafetyDashboard());

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<ThemeBloc>.value(value: themeBloc),
            BlocProvider<AuthBloc>.value(value: authBloc),
            BlocProvider<SafetyDashboardBloc>.value(value: safetyBloc),
          ],
          child: const MaterialApp(
            home: MainNavScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Check all 5 tabs exist
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Workforce'), findsOneWidget);
      expect(find.text('Safety'), findsOneWidget);
      expect(find.text('Tasks'), findsOneWidget);
      expect(find.text('More'), findsOneWidget);

      // Check Safety Dashboard header content
      expect(find.byIcon(Icons.qr_code_scanner_rounded), findsWidgets);
      expect(find.text('Raise SOS Alert'), findsOneWidget);
      expect(find.text('Key Site KPIs'), findsOneWidget);
    });
  });
}
