import 'package:equatable/equatable.dart';
import 'package:sarjan_construction/features/auth/domain/models/user.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  failure,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AuthUser? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;
  bool get isLoading => status == AuthStatus.loading;
  bool get isFailure => status == AuthStatus.failure;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;

  AuthState copyWith({
    AuthStatus? status,
    AuthUser? user,
    String? errorMessage,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, user, errorMessage];
}
