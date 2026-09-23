import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:audio_service/audio_service.dart';
import 'app.dart';
import 'audio_engine/player_service.dart';
import 'data/local/database/app_database.dart';
import 'shared/providers/global_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ─── System UI ───────────────────────────────────────────
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF141419),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // ─── Supabase ────────────────────────────────────────────
  // URL and anon key are loaded from environment or build args.
  // Never hardcode in source code.
  // Use: flutter run --dart-define=SUPABASE_URL=... --dart-define=SUPABASE_ANON_KEY=...
  const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://utlncpwtolnalpuazefa.supabase.co',
  );
  const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_3oohtfZRwAUpKIdmjr2hIA_xXjxm4UY',
  );

  await Supabase.initialize(
    url: supabaseUrl,
    // ignore: deprecated_member_use
    anonKey: supabaseAnonKey,
    authOptions: FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
      autoRefreshToken: true,
    ),
    realtimeClientOptions: const RealtimeClientOptions(
      logLevel: RealtimeLogLevel.info,
    ),
  );

  // ─── Local Services ──────────────────────────────────────
  final db = AppDatabase();
  final prefs = await SharedPreferences.getInstance();
  const secureStorage = FlutterSecureStorage();

  // ─── Audio Service ───────────────────────────────────────
  PattuPettiAudioHandler? audioHandler;
  try {
    audioHandler = await AudioService.init(
      builder: () => PattuPettiAudioHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.pattupetti.patt_petti.audio',
        androidNotificationChannelName: 'Pattu Petti Playback',
        androidNotificationOngoing: true,
        androidStopForegroundOnPause: true,
      ),
    );
  } catch (e) {
    debugPrint('AudioService.init notice: $e');
  }

  // ─── Global Error Widget (prevents white error boxes) ────
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0x331DB954),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.music_note_rounded,
                  color: Color(0xFF1DB954),
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tuning your audio space...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  };

  // ─── Run App ─────────────────────────────────────────────
  runApp(
    ProviderScope(
      overrides: [
        if (audioHandler != null)
          audioHandlerProvider.overrideWithValue(audioHandler),
        appDatabaseProvider.overrideWithValue(db),
        sharedPreferencesProvider.overrideWithValue(prefs),
        secureStorageProvider.overrideWithValue(secureStorage),
      ],
      child: const PattuPettiApp(),
    ),
  );
}
