import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:sarjan_construction/core/config/app_constants.dart';
import 'package:sarjan_construction/core/config/app_flavor.dart';
import 'package:sarjan_construction/core/errors/exceptions.dart';
import 'package:sarjan_construction/core/services/device_info_service.dart';
import 'package:sarjan_construction/core/services/package_info_service.dart';
import 'package:sarjan_construction/core/storage/secure_storage_service.dart';

class ApiClient {
  final http.Client _client;
  final SecureStorageService _secureStorage;
  final DeviceInfoService _deviceInfoService;
  final PackageInfoService _packageInfoService;
  final VoidCallback? _onUnauthorized;

  ApiClient({
    http.Client? client,
    required SecureStorageService secureStorage,
    required DeviceInfoService deviceInfoService,
    required PackageInfoService packageInfoService,
    VoidCallback? onUnauthorized,
  })  : _client = client ?? http.Client(),
        _secureStorage = secureStorage,
        _deviceInfoService = deviceInfoService,
        _packageInfoService = packageInfoService,
        _onUnauthorized = onUnauthorized;

  String get _baseUrl => AppConfig.instance.apiBaseUrl;

  Future<Map<String, String>> _buildHeaders() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // 1. Auth Token from Secure Storage
    final token = await _secureStorage.getToken();
    if (token != null && token.isNotEmpty) {
      headers[AppConstants.headerAuthorization] = 'Bearer $token';
    }

    // 2. Device & Version Metadata
    headers[AppConstants.headerDeviceId] = await _deviceInfoService.getDeviceId();
    headers[AppConstants.headerAppVersion] = _packageInfoService.appVersion;
    headers[AppConstants.headerPlatform] = _deviceInfoService.getPlatformName();

    return headers;
  }

  Uri _resolveUri(String path, [Map<String, dynamic>? queryParameters]) {
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    final fullUrl = '$_baseUrl/$cleanPath';
    final uri = Uri.parse(fullUrl);
    if (queryParameters != null && queryParameters.isNotEmpty) {
      return uri.replace(
        queryParameters: queryParameters.map(
          (k, v) => MapEntry(k, v?.toString() ?? ''),
        ),
      );
    }
    return uri;
  }

  http.Response _handleResponse(http.Response response) {
    if (response.statusCode == 401) {
      _onUnauthorized?.call();
      throw const UnauthorizedException();
    }
    if (response.statusCode >= 400) {
      throw ServerException(
        message: 'Server error: ${response.statusCode} - ${response.body}',
        statusCode: response.statusCode,
      );
    }
    return response;
  }

  Future<http.Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    final headers = await _buildHeaders();
    final uri = _resolveUri(path, queryParameters);
    final response = await _client.get(uri, headers: headers);
    return _handleResponse(response);
  }

  Future<http.Response> post(String path, {Object? body}) async {
    final headers = await _buildHeaders();
    final uri = _resolveUri(path);
    final response = await _client.post(
      uri,
      headers: headers,
      body: body is Map || body is List ? jsonEncode(body) : body,
    );
    return _handleResponse(response);
  }

  Future<http.Response> put(String path, {Object? body}) async {
    final headers = await _buildHeaders();
    final uri = _resolveUri(path);
    final response = await _client.put(
      uri,
      headers: headers,
      body: body is Map || body is List ? jsonEncode(body) : body,
    );
    return _handleResponse(response);
  }

  Future<http.Response> delete(String path) async {
    final headers = await _buildHeaders();
    final uri = _resolveUri(path);
    final response = await _client.delete(uri, headers: headers);
    return _handleResponse(response);
  }

  void close() {
    _client.close();
  }
}
