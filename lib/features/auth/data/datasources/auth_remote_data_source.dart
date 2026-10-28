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
    final baseOfficer = AuthUser.forRole(UserRole.safetyOfficer);
    final user = baseOfficer.copyWith(
      id: 'user_default',
      name: email.contains('@') ? email.split('@').first : 'Rajesh Patel',
      email: email,
    );

    return (
      user: user,
      token: 'auth_token_sample',
      refreshToken: 'refresh_token_sample',
    );
  }
}
