import 'package:sarjan_construction/core/network/api_client.dart';
import 'package:sarjan_construction/features/auth/domain/models/user.dart';

abstract class AuthRemoteDataSource {
  Future<({AuthUser user, String token, String refreshToken})> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  ApiClient get apiClient => _apiClient;

  @override
  Future<({AuthUser user, String token, String refreshToken})> login({
    required String email,
    required String password,
  }) async {
    final user = AuthUser(
      id: 'user_default',
      name: email.split('@').first,
      email: email,
      role: 'Engineer',
      permissions: const [],
    );

    return (
      user: user,
      token: 'auth_token_sample',
      refreshToken: 'refresh_token_sample',
    );
  }
}
