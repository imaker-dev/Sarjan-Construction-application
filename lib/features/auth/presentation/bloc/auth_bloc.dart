import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sarjan_construction/features/auth/domain/models/user.dart';
import 'package:sarjan_construction/features/auth/domain/repositories/auth_repository.dart';
import 'package:sarjan_construction/features/auth/presentation/bloc/auth_event.dart';
import 'package:sarjan_construction/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(const AuthState()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<LoginSubmitted>(_onLoginSubmitted);
    on<LogoutSubmitted>(_onLogoutSubmitted);
    on<SwitchUserRole>(_onSwitchUserRole);
  }

  void _onSwitchUserRole(
    SwitchUserRole event,
    Emitter<AuthState> emit,
  ) {
    final newRole = UserRole.fromString(event.role);
    final newUser = AuthUser.forRole(newRole);
    emit(state.copyWith(
      status: AuthStatus.authenticated,
      user: newUser,
    ));
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    final isAuth = await _authRepository.isAuthenticated();
    if (isAuth) {
      final user = await _authRepository.getCurrentUser();
      if (user != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        ));
        return;
      }
    }
    emit(state.copyWith(
      status: AuthStatus.unauthenticated,
      clearUser: true,
    ));
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final user = await _authRepository.login(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: 'Login failed: $e',
      ));
    }
  }

  Future<void> _onLogoutSubmitted(
    LogoutSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    await _authRepository.logout();
    emit(state.copyWith(
      status: AuthStatus.unauthenticated,
      clearUser: true,
    ));
  }
}
