import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

class LoginSubmitted extends AuthEvent {
  final String email;
  final String password;

  const LoginSubmitted({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class LogoutSubmitted extends AuthEvent {
  const LogoutSubmitted();
}

class SwitchUserRole extends AuthEvent {
  final String role;

  const SwitchUserRole(this.role);

  @override
  List<Object?> get props => [role];
}

