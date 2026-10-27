import 'package:sarjan_construction/features/auth/domain/models/user.dart';

abstract class AuthRepository {
  Future<AuthUser> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<AuthUser?> getCurrentUser();

  Future<bool> isAuthenticated();
}
