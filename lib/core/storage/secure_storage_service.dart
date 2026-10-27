import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sarjan_construction/core/config/app_constants.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveToken(String token) =>
      _storage.write(key: AppConstants.keyAccessToken, value: token);

  Future<String?> getToken() =>
      _storage.read(key: AppConstants.keyAccessToken);

  Future<void> clear() => _storage.deleteAll();
}
