import 'package:sarjan_construction/core/config/app_flavor.dart';

/// Centralized file for managing environment base URLs and API endpoints.
/// 
/// How to use:
/// 1. Update [devBaseUrl], [stagingBaseUrl], and [prodBaseUrl] below with your actual backend URLs.
/// 2. Add your custom feature endpoint paths under "API Endpoints" as you develop them.
/// 3. In your code, access endpoints using [AppUrls.baseUrl] or [AppUrls.login].
class AppUrls {
  AppUrls._();

  // ===========================================================================
  // 1. ENVIRONMENT BASE URLS
  // ===========================================================================

  /// Development Server (Used when running dev flavor / main_dev.dart)
  static const String devBaseUrl = 'https://dev-api.sarjanconstruction.com/v1';

  /// Staging / UAT Server (Used when running staging flavor / main_staging.dart)
  static const String stagingBaseUrl = 'https://staging-api.sarjanconstruction.com/v1';

  /// Production Live Server (Used when running prod flavor / main_prod.dart)
  static const String prodBaseUrl = 'https://api.sarjanconstruction.com/v1';

  /// Returns the current active Base URL based on the running flavor
  static String get baseUrl {
    switch (AppConfig.instance.flavor) {
      case Flavor.dev:
        return devBaseUrl;
      case Flavor.staging:
        return stagingBaseUrl;
      case Flavor.prod:
        return prodBaseUrl;
    }
  }

  // ===========================================================================
  // 2. API ENDPOINTS
  // Add your API endpoint paths here as you develop your features.
  // ===========================================================================

  // Authentication
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
  static const String userProfile = '/auth/me';

  // External Links (Policies, Support, Website)
  static const String privacyPolicy = 'https://sarjanconstruction.com/privacy';
  static const String termsOfService = 'https://sarjanconstruction.com/terms';
  static const String supportHelpdesk = 'https://sarjanconstruction.com/support';
}
