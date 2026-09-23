import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.valueOrNull?.user;
    final isPremium = user?.isPremiumActive ?? false;
    final remainingDays = user?.remainingPremiumDays;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(title: const Text('Profile'), backgroundColor: Colors.transparent, elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: isPremium ? AppTheme.accent.withValues(alpha: 0.2) : AppTheme.surfaceHighlight,
                  child: Icon(
                    isPremium ? Icons.stars_rounded : Icons.person_rounded,
                    color: isPremium ? AppTheme.accent : AppTheme.textTertiary,
                    size: 52,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user?.displayNameOrUsername ?? 'User',
                  style: const TextStyle(color: AppTheme.textPrimary, fontSize: 20, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  '@${user?.username ?? ''}',
                  style: const TextStyle(color: AppTheme.textTertiary, fontSize: 14),
                ),
                const SizedBox(height: 10),

                // Premium Status Badge
                if (isPremium)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.accent.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.workspace_premium_rounded, color: AppTheme.accent, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          remainingDays != null ? 'Premium Active • $remainingDays days left' : 'Premium Active (Unlimited)',
                          style: const TextStyle(
                            color: AppTheme.accent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (user?.isPremium == true)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.timer_off_rounded, color: Colors.orange, size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Premium Expired',
                          style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceHighlight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Standard Account',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          _ProfileTile(
            icon: Icons.workspace_premium_rounded,
            iconColor: isPremium ? AppTheme.accent : AppTheme.textSecondary,
            title: isPremium ? 'Premium Privileges' : 'Request Premium',
            subtitle: isPremium
                ? (remainingDays != null ? '$remainingDays days remaining • Tap to extend' : 'Active • Tap to view')
                : 'Get extended listening & exclusive features',
            onTap: () => context.push('/premium-request'),
          ),
          _ProfileTile(
            icon: Icons.settings_rounded,
            title: 'Settings',
            onTap: () => context.push('/settings'),
          ),
          _ProfileTile(
            icon: Icons.notifications_rounded,
            title: 'Notifications',
            onTap: () => context.push('/notifications'),
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () async {
              await ref.read(authActionsProvider).logout();
              if (context.mounted) context.go('/login');
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.error,
              side: const BorderSide(color: AppTheme.error),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (iconColor ?? AppTheme.textSecondary).withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor ?? AppTheme.textSecondary, size: 22),
      ),
      title: Text(title, style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600)),
      subtitle: subtitle != null
          ? Text(subtitle!, style: const TextStyle(color: AppTheme.textTertiary, fontSize: 12))
          : null,
      trailing: const Icon(Icons.chevron_right_rounded, color: AppTheme.textTertiary),
      onTap: onTap,
    );
  }
}
