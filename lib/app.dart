import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/screens/register_screen.dart';
import 'features/auth/presentation/screens/onboarding_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/library/presentation/screens/library_screen.dart';
import 'features/search/presentation/screens/search_screen.dart';
import 'features/playlists/presentation/screens/playlists_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/player/presentation/screens/player_screen.dart';
import 'features/clips/presentation/screens/clip_editor_screen.dart';
import 'features/merge/presentation/screens/merge_editor_screen.dart';
import 'features/recording/presentation/screens/recording_screen.dart';
import 'features/notifications/presentation/screens/notifications_screen.dart';
import 'features/settings/presentation/screens/settings_screen.dart';
import 'features/premium/presentation/screens/premium_request_screen.dart';
import 'domain/entities/user_entity.dart';
import 'shared/widgets/app_shell.dart';
import 'shared/widgets/loading_screen.dart';
import 'features/auth/presentation/providers/auth_provider.dart';

class PattuPettiApp extends ConsumerWidget {
  const PattuPettiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Pattu Petti',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}

// ─── Auth Listenable ─────────────────────────────────────────────────────────
// A ChangeNotifier that tells GoRouter when to re-evaluate redirect.
// GoRouter is created ONCE. When auth changes, only redirect() re-runs.
// This is the correct pattern — watching providers inside the router provider
// causes a new GoRouter on every auth change, wiping navigation (white screen).
final _authListenableProvider = Provider<ValueNotifier<int>>((ref) {
  final notifier = ValueNotifier<int>(0);

  ref.listen<AsyncValue<AuthStateData>>(authStateProvider, (_, __) {
    notifier.value++;
  });
  ref.listen<UserEntity?>(activeUserProvider, (_, __) {
    notifier.value++;
  });
  ref.listen<dynamic>(localUserOverrideProvider, (_, __) {
    notifier.value++;
  });

  ref.onDispose(() => notifier.dispose());
  return notifier;
});

// ─── App Router ──────────────────────────────────────────────────────────────
final appRouterProvider = Provider<GoRouter>((ref) {
  // Watch the listenable once — it never changes instance, just increments value.
  final listenable = ref.watch(_authListenableProvider);

  final router = GoRouter(
    initialLocation: '/login',
    refreshListenable: listenable, // triggers redirect re-evaluation on auth change
    redirect: (context, state) {
      // READ (never watch) inside redirect — called by GoRouter, not Riverpod
      final authValue = ref.read(authStateProvider);
      final activeUser = ref.read(activeUserProvider);
      final localUser = ref.read(localUserOverrideProvider);

      final isAuthenticated =
          activeUser != null ||
          localUser != null ||
          (authValue.valueOrNull?.isAuthenticated ?? false);

      // While still loading Supabase initial session without any active user, wait
      final isLoading = authValue.isLoading && activeUser == null && localUser == null;
      if (isLoading) return null;

      final path = state.uri.path;
      final isAuthRoute = path == '/login' || path == '/register';

      // Unauthenticated → push to login (except /onboarding & /loading which are ok)
      if (!isAuthenticated && !isAuthRoute && path != '/onboarding' && path != '/loading') {
        return '/login';
      }
      // Authenticated on auth page → go home
      if (isAuthenticated && isAuthRoute) {
        return '/home';
      }
      // Root → resolve correctly
      if (path == '/') {
        return isAuthenticated ? '/home' : '/login';
      }
      return null;
    },
    routes: [
      // ─── Auth & Loading ─────────────────────────────────
      GoRoute(path: '/loading', builder: (c, s) => const MusicLoadingScreen()),
      GoRoute(path: '/login', builder: (c, s) => const LoginScreen()),
      GoRoute(path: '/register', builder: (c, s) => const RegisterScreen()),
      GoRoute(path: '/onboarding', builder: (c, s) => const OnboardingScreen()),

      // ─── Main Shell ──────────────────────────────────────
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),
          GoRoute(path: '/library', builder: (c, s) => const LibraryScreen()),
          GoRoute(path: '/search', builder: (c, s) => const SearchScreen()),
          GoRoute(path: '/playlists', builder: (c, s) => const PlaylistsScreen()),
          GoRoute(path: '/profile', builder: (c, s) => const ProfileScreen()),
        ],
      ),

      // ─── Feature Screens ─────────────────────────────────
      GoRoute(
        path: '/player/:itemId',
        builder: (c, s) => PlayerScreen(itemId: s.pathParameters['itemId']!),
      ),
      GoRoute(
        path: '/clip-editor/:itemId',
        builder: (c, s) => ClipEditorScreen(sourceItemId: s.pathParameters['itemId']!),
      ),
      GoRoute(path: '/merge-editor', builder: (c, s) => const MergeEditorScreen()),
      GoRoute(path: '/recording', builder: (c, s) => const RecordingScreen()),
      GoRoute(path: '/notifications', builder: (c, s) => const NotificationsScreen()),
      GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),
      GoRoute(path: '/premium-request', builder: (c, s) => const PremiumRequestScreen()),
    ],
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: Text(
          'Page not found: ${state.uri}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    ),
  );

  ref.onDispose(() => router.dispose());
  return router;
});
