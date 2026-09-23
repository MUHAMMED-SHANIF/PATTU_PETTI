import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../domain/entities/user_entity.dart';
import '../../../../core/errors/app_error.dart';
import '../../../auth/data/auth_repository.dart';

/// Auth state exposed to the app.
class AuthStateData {
  const AuthStateData({
    this.user,
    this.isLoading = false,
  });

  final UserEntity? user;
  final bool isLoading;

  bool get isAuthenticated => user != null;
  bool get isAdmin => user?.isAdmin ?? false;

  AuthStateData copyWith({UserEntity? user, bool? isLoading}) {
    return AuthStateData(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Active user provider (set immediately upon successful login/register for instant navigation).
final activeUserProvider = StateProvider<UserEntity?>((ref) => null);

/// Local offline user override provider (for offline / guest usage).
final localUserOverrideProvider = StateProvider<UserEntity?>((ref) => null);

/// Auth state provider — watches active user, Supabase session, and local offline override.
final authStateProvider = StreamProvider<AuthStateData>((ref) async* {
  final repo = ref.watch(authRepositoryProvider);
  final activeUser = ref.watch(activeUserProvider);
  final localUser = ref.watch(localUserOverrideProvider);

  if (activeUser != null) {
    yield AuthStateData(user: activeUser);
    return;
  }

  if (localUser != null) {
    yield AuthStateData(user: localUser);
    return;
  }

  yield const AuthStateData(isLoading: true);

  await for (final supabaseState in Supabase.instance.client.auth.onAuthStateChange) {
    // If active user was set while listening, yield it
    final currentActive = ref.read(activeUserProvider);
    if (currentActive != null) {
      yield AuthStateData(user: currentActive);
      continue;
    }

    final currentLocal = ref.read(localUserOverrideProvider);
    if (currentLocal != null) {
      yield AuthStateData(user: currentLocal);
      continue;
    }

    if (supabaseState.session == null) {
      yield const AuthStateData();
    } else {
      try {
        final userResult = await repo.getCurrentUser();
        yield userResult.fold(
          onSuccess: (user) {
            ref.read(activeUserProvider.notifier).state = user;
            return AuthStateData(user: user);
          },
          onFailure: (_) => const AuthStateData(),
        );
      } catch (_) {
        yield const AuthStateData();
      }
    }
  }
});

/// Auth actions provider — login, register, logout, etc.
final authActionsProvider = Provider<AuthActions>((ref) {
  return AuthActions(ref.watch(authRepositoryProvider), ref);
});

class AuthActions {
  const AuthActions(this._repo, this._ref);
  final AuthRepository _repo;
  final Ref _ref;

  Future<void> continueOffline({String username = 'local_listener'}) async {
    final cached = await _repo.getCachedUser();
    if (cached != null) {
      _ref.read(localUserOverrideProvider.notifier).state = cached;
      return;
    }
    _ref.read(localUserOverrideProvider.notifier).state = UserEntity(
      id: 'local-offline-user',
      username: username,
      displayName: 'Local Listener',
      role: 'normal',
    );
  }

  Future<Result<UserEntity>> login(String usernameOrEmail, String password) async {
    final res = await _repo.login(usernameOrEmail: usernameOrEmail, password: password);
    res.fold(
      onSuccess: (user) {
        _ref.read(activeUserProvider.notifier).state = user;
      },
      onFailure: (_) {},
    );
    return res;
  }

  Future<Result<UserEntity>> register({
    required String username,
    required String email,
    required String password,
    String? displayName,
  }) async {
    final res = await _repo.register(
      username: username,
      email: email,
      password: password,
      displayName: displayName,
    );
    res.fold(
      onSuccess: (user) {
        _ref.read(activeUserProvider.notifier).state = user;
      },
      onFailure: (_) {},
    );
    return res;
  }

  Future<Result<void>> logout() async {
    _ref.read(activeUserProvider.notifier).state = null;
    _ref.read(localUserOverrideProvider.notifier).state = null;
    return _repo.logout();
  }

  Future<Result<void>> resetPassword(String email) =>
      _repo.resetPassword(email);

  Future<Result<UserEntity>> updateProfile({
    String? displayName,
    String? bio,
    String? avatarPath,
  }) =>
      _repo.updateProfile(
        displayName: displayName,
        bio: bio,
        avatarPath: avatarPath,
      );

  Future<Result<void>> deleteAccount() => _repo.deleteAccount();

  Future<UserEntity?> refreshUser() async {
    final res = await _repo.getCurrentUser();
    return res.fold(
      onSuccess: (user) {
        _ref.read(activeUserProvider.notifier).state = user;
        return user;
      },
      onFailure: (_) => null,
    );
  }
}
