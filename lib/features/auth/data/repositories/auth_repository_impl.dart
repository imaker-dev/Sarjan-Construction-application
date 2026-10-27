import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sarjan_construction/core/storage/secure_storage_service.dart';
import 'package:sarjan_construction/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sarjan_construction/features/auth/domain/models/user.dart';
import 'package:sarjan_construction/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorage;
  final SharedPreferences _prefs;

  static const String _keyCachedUser = 'cached_current_user_profile';

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorageService secureStorage,
    required SharedPreferences prefs,
  })  : _remoteDataSource = remoteDataSource,
        _secureStorage = secureStorage,
        _prefs = prefs;

  @override
  Future<AuthUser> login({
    required String email,
    required String password,
  }) async {
    final result = await _remoteDataSource.login(
      email: email,
      password: password,
    );

    await _secureStorage.saveToken(result.token);
    await _prefs.setString(_keyCachedUser, jsonEncode(result.user.toJson()));

    return result.user;
  }

  @override
  Future<void> logout() async {
    await _secureStorage.clear();
    await _prefs.remove(_keyCachedUser);
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    final raw = _prefs.getString(_keyCachedUser);
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return AuthUser.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.getToken();
    return token != null && token.isNotEmpty;
  }
}
