import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/local/database/app_database.dart';
import '../../infrastructure/secure_storage/storage_service.dart';

/// Global providers for singleton services.
/// These are overridden in main() with real instances.

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  throw UnimplementedError('Override appDatabaseProvider in ProviderScope');
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override sharedPreferencesProvider in ProviderScope');
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  throw UnimplementedError('Override secureStorageProvider in ProviderScope');
});

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService(ref.watch(secureStorageProvider));
});

final localPrefsServiceProvider = Provider<LocalPrefsService>((ref) {
  return LocalPrefsService(ref.watch(sharedPreferencesProvider));
});
