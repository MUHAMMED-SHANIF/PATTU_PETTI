import 'package:equatable/equatable.dart';

/// Represents a user in the Pattu Petti system.
/// Roles and permissions are loaded from the database — never hardcoded.
class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.username,
    this.displayName,
    this.email,
    this.phone,
    this.avatarUrl,
    this.bio,
    required this.role,
    this.isPremium = false,
    this.premiumExpiresAt,
    this.isBanned = false,
  });

  final String id;
  final String username;
  final String? displayName;
  final String? email;
  final String? phone;
  final String? avatarUrl;
  final String? bio;
  final String role; // 'admin' | 'normal' | 'privileged' — from DB
  final bool isPremium;
  final DateTime? premiumExpiresAt;
  final bool isBanned;

  String get displayNameOrUsername => displayName ?? username;

  bool get isAdmin => role == 'admin';
  bool get isPrivileged => role == 'privileged';
  bool get isNormal => role == 'normal';

  /// Whether premium privileges are currently active.
  /// Strictly checks current device time against premiumExpiresAt.
  /// If the allowed days have elapsed, returns false even in offline mode.
  bool get isPremiumActive {
    if (!isPremium) return false;
    if (premiumExpiresAt == null) return true; // unlimited
    return premiumExpiresAt!.isAfter(DateTime.now());
  }

  /// Remaining days of premium access (rounded up), or null if unlimited/not premium.
  int? get remainingPremiumDays {
    if (!isPremiumActive || premiumExpiresAt == null) return null;
    final diff = premiumExpiresAt!.difference(DateTime.now());
    return (diff.inHours / 24).ceil().clamp(0, 99999);
  }

  UserEntity copyWith({
    String? id,
    String? username,
    String? displayName,
    String? email,
    String? phone,
    String? avatarUrl,
    String? bio,
    String? role,
    bool? isPremium,
    DateTime? premiumExpiresAt,
    bool? isBanned,
  }) {
    return UserEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      role: role ?? this.role,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiresAt: premiumExpiresAt ?? this.premiumExpiresAt,
      isBanned: isBanned ?? this.isBanned,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'display_name': displayName,
    'email': email,
    'phone': phone,
    'avatar_url': avatarUrl,
    'bio': bio,
    'role': role,
    'is_premium': isPremium,
    'premium_expires_at': premiumExpiresAt?.toIso8601String(),
    'is_banned': isBanned,
  };

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
    id: json['id'] as String,
    username: json['username'] as String? ?? 'user',
    displayName: json['display_name'] as String?,
    email: json['email'] as String?,
    phone: json['phone'] as String?,
    avatarUrl: json['avatar_url'] as String?,
    bio: json['bio'] as String?,
    role: json['role'] as String? ?? 'normal',
    isPremium: json['is_premium'] as bool? ?? false,
    premiumExpiresAt: json['premium_expires_at'] != null 
        ? DateTime.tryParse(json['premium_expires_at'] as String)
        : null,
    isBanned: json['is_banned'] as bool? ?? false,
  );

  @override
  List<Object?> get props => [id, username, displayName, email, role, isPremium, premiumExpiresAt, isBanned];
}
