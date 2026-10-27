import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sarjan_construction/app.dart';
import 'package:sarjan_construction/core/config/app_flavor.dart';
import 'package:sarjan_construction/core/config/app_urls.dart';
import 'package:sarjan_construction/core/network/api_client.dart';
import 'package:sarjan_construction/core/services/device_info_service.dart';
import 'package:sarjan_construction/core/services/package_info_service.dart';
import 'package:sarjan_construction/core/storage/secure_storage_service.dart';
import 'package:sarjan_construction/core/utils/app_bloc_observer.dart';
import 'package:sarjan_construction/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sarjan_construction/features/auth/data/repositories/auth_repository_impl.dart';

Future<void> bootstrap({required Flavor flavor}) async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Flavor Environment Configuration
  final appConfig = switch (flavor) {
    Flavor.dev => const AppConfig(
        flavor: Flavor.dev,
        appTitle: 'Sarjan Construction (Dev)',
        apiBaseUrl: AppUrls.devBaseUrl,
        enableLogging: true,
      ),
    Flavor.staging => const AppConfig(
        flavor: Flavor.staging,
        appTitle: 'Sarjan Construction (Staging)',
        apiBaseUrl: AppUrls.stagingBaseUrl,
        enableLogging: true,
      ),
    Flavor.prod => const AppConfig(
        flavor: Flavor.prod,
        appTitle: 'Sarjan Construction',
        apiBaseUrl: AppUrls.prodBaseUrl,
        enableLogging: false,
      ),
  };
  AppConfig.initialize(appConfig);

  // 2. Initialize Foundation Services
  final prefs = await SharedPreferences.getInstance();
  final packageInfoService = PackageInfoService();
  await packageInfoService.init();

  final deviceInfoService = DeviceInfoService(prefs: prefs);
  final secureStorageService = SecureStorageService();

  // 3. Set up HTTP Client
  late final ApiClient apiClient;
  late final AuthRepositoryImpl authRepository;

  apiClient = ApiClient(
    secureStorage: secureStorageService,
    deviceInfoService: deviceInfoService,
    packageInfoService: packageInfoService,
    onUnauthorized: () async {
      await authRepository.logout();
    },
  );

  // 4. Initialize Auth Repository
  final authRemoteDataSource = AuthRemoteDataSourceImpl(apiClient: apiClient);
  authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    secureStorage: secureStorageService,
    prefs: prefs,
  );

  // 5. Set Bloc Observer
  Bloc.observer = AppBlocObserver();

  // 6. Run App
  runApp(
    SarjanApp(
      authRepository: authRepository,
      prefs: prefs,
    ),
  );
}
