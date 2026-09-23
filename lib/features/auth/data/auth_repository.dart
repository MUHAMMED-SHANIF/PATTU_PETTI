import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../core/errors/app_error.dart';
import '../../../core/constants/app_constants.dart';
import '../../../infrastructure/secure_storage/storage_service.dart';
import '../../../shared/providers/global_providers.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return SupabaseAuthRepository(
    supabase: Supabase.instance.client,
    secureStorage: ref.watch(secureStorageServiceProvider),
  );
});

/// Abstract auth repository. Allows future swap of backend.
abstract class AuthRepository {
  /// Login with either username or email, plus password.
  Future<Result<UserEntity>> login({required String usernameOrEmail, required String password});
  Future<Result<UserEntity>> register({
    required String username,
    required String email,
    required String password,
    String? displayName,
  });
  Future<Result<void>> logout();
  Future<Result<void>> resetPassword(String email);
  Future<Result<UserEntity>> getCurrentUser();
  Future<UserEntity?> getCachedUser();
  Future<Result<UserEntity>> updateProfile({
    String? displayName,
    String? bio,
    String? avatarPath,
  });
  Future<Result<void>> deleteAccount();
}

/// Supabase implementation of auth repository.
class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository({
    required this.supabase,
    required this.secureStorage,
  });

  final SupabaseClient supabase;
  final SecureStorageService secureStorage;

  // ─── Simple email detector ────────────────────────────────
  static final _emailRegex = RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w\-]{2,}$');
  bool _isEmail(String input) => _emailRegex.hasMatch(input.trim());

  @override
  Future<Result<UserEntity>> login({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      final input = usernameOrEmail.trim();
      String emailToUse;

      if (_isEmail(input)) {
        // ── Direct email login ───────────────────────────────
        emailToUse = input.toLowerCase();
      } else {
        // ── Username → lookup email ──────────────────────────
        final usernameNormalized = input.toLowerCase();

        if (usernameNormalized.length < AppConstants.usernameMinLength) {
          return const Failure(AuthError(message: 'Username is too short.'));
        }

        final profileData = await supabase
            .from('profiles')
            .select('email')
            .eq('username_normalized', usernameNormalized)
            .maybeSingle();

        if (profileData == null || profileData['email'] == null) {
          return const Failure(
            AuthError(message: 'No account found with that username. Please check your username or sign in with your email.'),
          );
        }

        emailToUse = profileData['email'] as String;
      }

      // Sign in with Supabase Auth
      final response = await supabase.auth.signInWithPassword(
        email: emailToUse,
        password: password,
      );

      if (response.user == null) {
        return const Failure(
          AuthError(message: 'Login failed. Please check your credentials.'),
        );
      }

      // Fetch full profile + role (with fallback if profile not created yet)
      UserEntity user;
      try {
        user = await _fetchUserProfile(response.user!.id);
      } catch (_) {
        // Profile not in DB yet (trigger may be delayed) — build from auth data
        user = _userFromAuth(response.user!);
      }

      // Check if banned
      if (user.isBanned) {
        await supabase.auth.signOut();
        return const Failure(
          AuthError(message: 'Your account has been suspended. Please contact support.'),
        );
      }

      // Cache session for offline login
      await secureStorage.writeJson(StorageKeys.offlineCredentials, {
        'userId': response.user!.id,
        'username': user.username,
      });

      return Success(user);
    } on AuthException catch (e) {
      return Failure(AuthError(message: _parseAuthError(e)));
    } catch (e) {
      return Failure(UnknownError(message: 'Login failed: ${e.toString()}'));
    }
  }

  @override
  Future<Result<UserEntity>> register({
    required String username,
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final usernameNormalized = username.trim().toLowerCase();
      final emailNormalized = email.trim().toLowerCase();

      // ── Validate username ────────────────────────────────
      final usernameError = _validateUsername(usernameNormalized);
      if (usernameError != null) {
        return Failure(AuthError(message: usernameError));
      }

      // ── Validate email format ────────────────────────────
      if (!_isEmail(emailNormalized)) {
        return const Failure(AuthError(message: 'Please enter a valid email address.'));
      }

      // ── Check username uniqueness ─────────────────────────
      final existingUsername = await supabase
          .from('profiles')
          .select('id')
          .eq('username_normalized', usernameNormalized)
          .maybeSingle();

      if (existingUsername != null) {
        return const Failure(
          AuthError(message: 'That username is already taken. Please choose another.'),
        );
      }

      // ── Check email uniqueness via profiles table ─────────
      // (Supabase auth will also block duplicates, but this gives a friendlier message)
      final existingEmail = await supabase
          .from('profiles')
          .select('id')
          .eq('email', emailNormalized)
          .maybeSingle();

      if (existingEmail != null) {
        return const Failure(
          AuthError(message: 'An account with this email already exists. Please sign in.'),
        );
      }

      // ── Register with Supabase Auth ───────────────────────
      final response = await supabase.auth.signUp(
        email: emailNormalized,
        password: password,
        data: {
          'username': username.trim(),
          'username_normalized': usernameNormalized,
          'display_name': displayName?.trim().isNotEmpty == true
              ? displayName!.trim()
              : username.trim(),
        },
      );

      if (response.user == null) {
        return const Failure(
          AuthError(message: 'Registration failed. Please try again.'),
        );
      }

      final userId = response.user!.id;
      final effectiveDisplayName =
          displayName?.trim().isNotEmpty == true ? displayName!.trim() : username.trim();

      // ── If no session returned, email confirmation is required ────────────
      // Try auto sign-in so the user lands directly in the app.
      if (response.session == null) {
        try {
          await supabase.auth.signInWithPassword(
            email: emailNormalized,
            password: password,
          );
        } on AuthException catch (e) {
          final msg = e.message.toLowerCase();
          if (msg.contains('email not confirmed') || msg.contains('email_not_confirmed')) {
            return const Failure(AuthError(
              message: 'Account created! Please check your email inbox to confirm '
                  'your account, then sign in.',
            ));
          }
          // Other sign-in error after registration — still proceed
        } catch (_) {}
      }

      // ── Upsert profile directly ─────────────────────────────
      try {
        await supabase.from('profiles').upsert({
          'id': userId,
          'username': username.trim(),
          'username_normalized': usernameNormalized,
          'display_name': effectiveDisplayName,
          'email': emailNormalized,
          'updated_at': DateTime.now().toIso8601String(),
        });
      } catch (_) {}

      try {
        await supabase.from('user_roles').upsert({
          'user_id': userId,
          'role': AppConstants.roleNormal,
        });
      } catch (_) {}

      // ── Fetch and return the complete user (with fallback) ─
      UserEntity user;
      try {
        user = await _fetchUserProfile(userId);
      } catch (_) {
        user = _userFromAuth(response.user!);
      }
      await _cacheUserLocally(user);
      return Success(user);
    } on AuthException catch (e) {
      return Failure(AuthError(message: _parseAuthError(e)));
    } catch (e) {
      return Failure(UnknownError(message: 'Registration failed: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await supabase.auth.signOut();
      await secureStorage.delete(StorageKeys.offlineCredentials);
      await secureStorage.delete(StorageKeys.cachedUserProfile);
      await secureStorage.delete(StorageKeys.lastVerifiedClockMs);
      return const Success(null);
    } catch (e) {
      return Failure(UnknownError(message: 'Logout failed.'));
    }
  }

  @override
  Future<Result<void>> resetPassword(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email.trim());
      return const Success(null);
    } on AuthException catch (e) {
      return Failure(AuthError(message: _parseAuthError(e)));
    } catch (e) {
      return Failure(UnknownError(message: 'Password reset failed.'));
    }
  }

  @override
  Future<Result<UserEntity>> getCurrentUser() async {
    try {
      final supabaseUser = supabase.auth.currentUser;
      if (supabaseUser == null) {
        final cached = await _loadCachedUserLocally();
        if (cached != null) return Success(cached);
        return const Failure(AuthError(message: 'No authenticated user.'));
      }
      try {
        final user = await _fetchUserProfile(supabaseUser.id);
        await _cacheUserLocally(user);
        return Success(user);
      } catch (_) {
        // If network request failed (e.g. offline), use cached user so premium duration & role persist!
        final cached = await _loadCachedUserLocally();
        if (cached != null && cached.id == supabaseUser.id) {
          return Success(cached);
        }
        return Success(_userFromAuth(supabaseUser));
      }
    } catch (e) {
      final cached = await _loadCachedUserLocally();
      if (cached != null) return Success(cached);
      return Failure(UnknownError(message: 'Failed to load user data.'));
    }
  }

  @override
  Future<UserEntity?> getCachedUser() => _loadCachedUserLocally();

  Future<void> _cacheUserLocally(UserEntity user) async {
    try {
      await secureStorage.writeJson(StorageKeys.cachedUserProfile, user.toJson());
      await secureStorage.write(
        StorageKeys.lastVerifiedClockMs,
        DateTime.now().millisecondsSinceEpoch.toString(),
      );
    } catch (e) {
      debugPrint('Failed to cache user profile locally: $e');
    }
  }

  Future<UserEntity?> _loadCachedUserLocally() async {
    try {
      final json = await secureStorage.readJson(StorageKeys.cachedUserProfile);
      if (json != null) {
        final user = UserEntity.fromJson(json);

        // Anti-clock tampering protection:
        // If user rolls device clock back to artificially extend offline expiry, detect and invalidate!
        final lastVerifiedStr = await secureStorage.read(StorageKeys.lastVerifiedClockMs);
        if (lastVerifiedStr != null) {
          final lastVerifiedMs = int.tryParse(lastVerifiedStr) ?? 0;
          final currentMs = DateTime.now().millisecondsSinceEpoch;
          // If phone clock is rolled back by more than 1 hour from last verified run:
          if (currentMs < lastVerifiedMs - 3600000) {
            debugPrint('Device clock rollback detected! Offline premium suspended.');
            return user.copyWith(isPremium: false);
          }
        }
        return user;
      }
    } catch (e) {
      debugPrint('Failed to load cached user profile: $e');
    }
    return null;
  }

  @override
  Future<Result<UserEntity>> updateProfile({
    String? displayName,
    String? bio,
    String? avatarPath,
  }) async {
    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) return const Failure(AuthError(message: 'Not authenticated.'));

      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };
      if (displayName != null) updates['display_name'] = displayName;
      if (bio != null) updates['bio'] = bio;
      if (avatarPath != null) updates['avatar_url'] = avatarPath;

      await supabase.from('profiles').update(updates).eq('id', userId);
      final user = await _fetchUserProfile(userId);
      await _cacheUserLocally(user);
      return Success(user);
    } catch (e) {
      return Failure(UnknownError(message: 'Failed to update profile.'));
    }
  }

  @override
  Future<Result<void>> deleteAccount() async {
    try {
      await supabase.functions.invoke('delete-account');
      await supabase.auth.signOut();
      await secureStorage.delete(StorageKeys.offlineCredentials);
      await secureStorage.delete(StorageKeys.cachedUserProfile);
      await secureStorage.delete(StorageKeys.lastVerifiedClockMs);
      return const Success(null);
    } catch (e) {
      return Failure(UnknownError(message: 'Account deletion failed. Please try again.'));
    }
  }

  // ─── Private helpers ─────────────────────────────────────

  /// Builds a minimal UserEntity from auth metadata when the profile row
  /// is not yet in the database (e.g. trigger delay or first login).
  UserEntity _userFromAuth(User authUser) {
    final meta = authUser.userMetadata ?? {};
    final username = (meta['username'] as String?)?.isNotEmpty == true
        ? meta['username'] as String
        : (authUser.email?.split('@').first ?? 'user');
    return UserEntity(
      id: authUser.id,
      username: username,
      displayName: meta['display_name'] as String? ?? username,
      email: authUser.email,
      role: AppConstants.roleNormal,
    );
  }

  Future<UserEntity> _fetchUserProfile(String userId) async {
    // 1. Try full join query with explicit foreign key names
    try {
      final data = await supabase
          .from('profiles')
          .select('''
            id, username, display_name, email, phone, bio, avatar_url,
            user_roles!user_roles_user_id_fkey (role),
            user_restrictions!user_restrictions_user_id_fkey (is_banned, ban_reason),
            premium_access!premium_access_user_id_fkey (expires_at)
          ''')
          .eq('id', userId)
          .maybeSingle();

      if (data != null) {
        final roleData = data['user_roles'];
        String role = AppConstants.roleNormal;
        if (roleData is Map && roleData['role'] != null) {
          role = roleData['role'] as String;
        } else if (roleData is List && roleData.isNotEmpty && roleData[0]['role'] != null) {
          role = roleData[0]['role'] as String;
        }

        final restrictionData = data['user_restrictions'];
        bool isBanned = false;
        if (restrictionData is Map) {
          isBanned = restrictionData['is_banned'] as bool? ?? false;
        } else if (restrictionData is List && restrictionData.isNotEmpty) {
          isBanned = restrictionData[0]['is_banned'] as bool? ?? false;
        }

        final premiumData = data['premium_access'];
        final isPremium = (premiumData is Map) || (premiumData is List && premiumData.isNotEmpty);
        DateTime? premiumExpiry;
        if (premiumData is Map && premiumData['expires_at'] != null) {
          premiumExpiry = DateTime.tryParse(premiumData['expires_at'] as String);
        } else if (premiumData is List && premiumData.isNotEmpty && premiumData[0]['expires_at'] != null) {
          premiumExpiry = DateTime.tryParse(premiumData[0]['expires_at'] as String);
        }

        return UserEntity(
          id: data['id'] as String,
          username: data['username'] as String? ?? 'user',
          displayName: data['display_name'] as String? ?? data['username'] as String?,
          email: data['email'] as String?,
          phone: data['phone'] as String?,
          bio: data['bio'] as String?,
          avatarUrl: data['avatar_url'] as String?,
          role: role,
          isPremium: isPremium,
          premiumExpiresAt: premiumExpiry,
          isBanned: isBanned,
        );
      }
    } catch (e) {
      debugPrint('_fetchUserProfile full join failed: $e');
    }

    // 2. Fallback: query profiles alone without joins
    try {
      final basicData = await supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (basicData != null) {
        return UserEntity(
          id: basicData['id'] as String,
          username: basicData['username'] as String? ?? 'user',
          displayName: basicData['display_name'] as String? ?? basicData['username'] as String?,
          email: basicData['email'] as String?,
          phone: basicData['phone'] as String?,
          bio: basicData['bio'] as String?,
          avatarUrl: basicData['avatar_url'] as String?,
          role: AppConstants.roleNormal,
        );
      }
    } catch (e) {
      debugPrint('_fetchUserProfile basic profile failed: $e');
    }

    // 3. Fallback: construct from current auth user
    final currentAuth = supabase.auth.currentUser;
    if (currentAuth != null && currentAuth.id == userId) {
      return _userFromAuth(currentAuth);
    }

    throw Exception('User profile not found for $userId');
  }

  String? _validateUsername(String username) {
    if (username.length < AppConstants.usernameMinLength) {
      return 'Username must be at least ${AppConstants.usernameMinLength} characters.';
    }
    if (username.length > AppConstants.usernameMaxLength) {
      return 'Username must be at most ${AppConstants.usernameMaxLength} characters.';
    }
    if (!RegExp(AppConstants.usernamePattern).hasMatch(username)) {
      return 'Username can only contain letters, numbers, and underscores.';
    }
    return null;
  }

  String _parseAuthError(AuthException e) {
    final msg = e.message.toLowerCase();
    if (msg.contains('invalid login credentials') || msg.contains('invalid_credentials')) {
      return 'Incorrect password. Please try again.';
    }
    if (msg.contains('email already') || msg.contains('already registered') ||
        msg.contains('user already registered')) {
      return 'An account with this email already exists. Please sign in.';
    }
    if (msg.contains('weak password') || msg.contains('password should be')) {
      return 'Password is too weak. Use at least 8 characters.';
    }
    if (msg.contains('rate limit') || msg.contains('too many requests')) {
      return 'Too many attempts. Please wait a moment and try again.';
    }
    if (msg.contains('email not confirmed') || msg.contains('email_not_confirmed')) {
      return 'Please confirm your email before signing in.';
    }
    return e.message;
  }
}
