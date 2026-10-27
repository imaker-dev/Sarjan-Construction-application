import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoService {
  PackageInfo? _packageInfo;

  Future<void> init() async {
    try {
      _packageInfo = await PackageInfo.fromPlatform();
    } catch (_) {
      // Fallback for tests or unsupported environments
      _packageInfo = PackageInfo(
        appName: 'Sarjan Construction',
        packageName: 'com.example.sarjan_construction',
        version: '1.0.0',
        buildNumber: '1',
      );
    }
  }

  String get appVersion {
    if (_packageInfo == null) return '1.0.0';
    return '${_packageInfo!.version}+${_packageInfo!.buildNumber}';
  }

  String get appName => _packageInfo?.appName ?? 'Sarjan Construction';
  String get packageName => _packageInfo?.packageName ?? 'com.example.sarjan_construction';
}
