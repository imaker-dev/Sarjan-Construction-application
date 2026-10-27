enum Flavor {
  dev,
  staging,
  prod,
}

class AppConfig {
  final Flavor flavor;
  final String appTitle;
  final String apiBaseUrl;
  final bool enableLogging;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  const AppConfig({
    required this.flavor,
    required this.appTitle,
    required this.apiBaseUrl,
    this.enableLogging = true,
    this.connectTimeout = const Duration(seconds: 25),
    this.receiveTimeout = const Duration(seconds: 25),
  });

  static late final AppConfig _instance;
  static bool _initialized = false;

  static void initialize(AppConfig config) {
    _instance = config;
    _initialized = true;
  }

  static AppConfig get instance {
    if (!_initialized) {
      throw StateError(
        'AppConfig has not been initialized. Call AppConfig.initialize() before accessing instance.',
      );
    }
    return _instance;
  }

  bool get isDev => flavor == Flavor.dev;
  bool get isStaging => flavor == Flavor.staging;
  bool get isProd => flavor == Flavor.prod;
}
