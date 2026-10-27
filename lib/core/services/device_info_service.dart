import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:sarjan_construction/core/config/app_constants.dart';

class DeviceInfoService {
  final DeviceInfoPlugin _deviceInfoPlugin;
  final SharedPreferences _prefs;
  String? _cachedDeviceId;

  DeviceInfoService({
    DeviceInfoPlugin? deviceInfoPlugin,
    required SharedPreferences prefs,
  })  : _deviceInfoPlugin = deviceInfoPlugin ?? DeviceInfoPlugin(),
        _prefs = prefs;

  Future<String> getDeviceId() async {
    if (_cachedDeviceId != null) {
      return _cachedDeviceId!;
    }

    final savedId = _prefs.getString(AppConstants.keyDeviceId);
    if (savedId != null && savedId.isNotEmpty) {
      _cachedDeviceId = savedId;
      return savedId;
    }

    String deviceId = '';
    try {
      if (kIsWeb) {
        final webInfo = await _deviceInfoPlugin.webBrowserInfo;
        deviceId = 'web_${webInfo.vendor}_${webInfo.userAgent.hashCode}';
      } else if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        deviceId = 'android_${androidInfo.id}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        deviceId = 'ios_${iosInfo.identifierForVendor ?? const Uuid().v4()}';
      } else if (Platform.isMacOS) {
        final macInfo = await _deviceInfoPlugin.macOsInfo;
        deviceId = 'macos_${macInfo.systemGUID ?? const Uuid().v4()}';
      } else {
        deviceId = const Uuid().v4();
      }
    } catch (_) {
      deviceId = const Uuid().v4();
    }

    if (deviceId.isEmpty) {
      deviceId = const Uuid().v4();
    }

    await _prefs.setString(AppConstants.keyDeviceId, deviceId);
    _cachedDeviceId = deviceId;
    return deviceId;
  }

  String getPlatformName() {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isMacOS) return 'macos';
    if (Platform.isLinux) return 'linux';
    if (Platform.isWindows) return 'windows';
    return 'unknown';
  }
}
