import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class PremiumRequestScreen extends ConsumerStatefulWidget {
  const PremiumRequestScreen({super.key});

  @override
  ConsumerState<PremiumRequestScreen> createState() => _PremiumRequestScreenState();
}

class _PremiumRequestScreenState extends ConsumerState<PremiumRequestScreen> {
  final _phoneController = TextEditingController();
  final _daysController = TextEditingController(text: '30');
  final _reasonController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isSubmitting = false;
  bool _isLoadingStatus = true;
  Map<String, dynamic>? _pendingRequest;
  Map<String, dynamic>? _rejectedRequest;

  static const List<int> _presetDays = [7, 15, 30, 90, 365];

  @override
  void initState() {
    super.initState();
    _fetchExistingRequest();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _daysController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _fetchExistingRequest() async {
    setState(() => _isLoadingStatus = true);

    try {
      // 1. Refresh user profile from Supabase & local DB
      await ref.read(authActionsProvider).refreshUser();

      final user = ref.read(authStateProvider).valueOrNull?.user;
      if (user == null) {
        if (mounted) setState(() => _isLoadingStatus = false);
        return;
      }

      // 2. Fetch the latest request for this user
      final res = await Supabase.instance.client
          .from('premium_requests')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (mounted) {
        setState(() {
          if (res != null && res['status'] == 'pending') {
            _pendingRequest = res;
            _rejectedRequest = null;
          } else if (res != null && res['status'] == 'rejected') {
            _pendingRequest = null;
            _rejectedRequest = res;
          } else {
            _pendingRequest = null;
            _rejectedRequest = null;
          }
          _isLoadingStatus = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingStatus = false);
    }
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(authStateProvider).valueOrNull?.user;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in first to submit a request.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final phone = _phoneController.text.trim();
    final days = int.tryParse(_daysController.text.trim()) ?? 30;
    final reason = _reasonController.text.trim();

    try {
      final client = Supabase.instance.client;

      // 1. Try insert with native columns
      try {
        await client.from('premium_requests').insert({
          'user_id': user.id,
          'phone_number': phone,
          'requested_days': days,
          'reason': reason.isNotEmpty ? reason : 'Requested access for $days days',
          'status': 'pending',
        });
      } catch (colErr) {
        // 2. Resilient fallback: encode [Days: X | Phone: Y] into reason
        final fallbackReason = '[Days: $days | Phone: $phone] ${reason.isNotEmpty ? reason : 'Requested access'}';
        await client.from('premium_requests').insert({
          'user_id': user.id,
          'reason': fallbackReason,
          'status': 'pending',
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.accent,
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Premium request for $days days submitted successfully!',
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ),
        );
        await _fetchExistingRequest();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.error,
            content: Text('Failed to submit request: $e'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).valueOrNull?.user;
    final isPremium = user?.isPremiumActive ?? false;
    final remainingDays = user?.remainingPremiumDays;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(
          isPremium
              ? 'Premium Membership'
              : _pendingRequest != null
                  ? 'Request Status'
                  : 'Request Premium',
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Refresh Status',
            icon: const Icon(Icons.refresh_rounded, color: AppTheme.textSecondary),
            onPressed: _isLoadingStatus ? null : _fetchExistingRequest,
          ),
        ],
      ),
      body: _isLoadingStatus
          ? const Center(child: CircularProgressIndicator(color: AppTheme.accent))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: isPremium
                  ? _buildPremiumActiveView(user, remainingDays)
                  : _pendingRequest != null
                      ? _buildPendingReviewView()
                      : _buildRequestFormView(),
            ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // VIEW 1: PREMIUM ACTIVE (Approved VIP view - cannot request new)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildPremiumActiveView(dynamic user, int? remainingDays) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // VIP Card Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2A2312), Color(0xFF1B160C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.accent.withValues(alpha: 0.5), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppTheme.accent.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.workspace_premium_rounded, color: AppTheme.accent, size: 28),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'VIP PREMIUM ACTIVE',
                          style: TextStyle(
                            color: AppTheme.accent,
                            fontSize: 14,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Full Access Unlocked',
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Divider(color: Color(0xFF3E331B), height: 1),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'REMAINING TIME',
                        style: TextStyle(
                          color: AppTheme.textTertiary,
                          fontSize: 11,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        remainingDays != null ? '$remainingDays Days' : 'Lifetime Access',
                        style: const TextStyle(
                          color: AppTheme.accent,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  if (user?.premiumExpiresAt != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'EXPIRES ON',
                          style: TextStyle(
                            color: AppTheme.textTertiary,
                            fontSize: 11,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${user.premiumExpiresAt!.day} ${_monthName(user.premiumExpiresAt!.month)} ${user.premiumExpiresAt!.year}',
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Lockout Note
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: const Row(
            children: [
              Icon(Icons.lock_outline_rounded, color: AppTheme.accent, size: 18),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Your premium subscription is active. You can request an extension once your current plan expires.',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),

        // Premium Benefits Section
        const Text(
          'Your Premium Benefits',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Enjoy full studio powers and unconstrained music playback.',
          style: TextStyle(color: AppTheme.textTertiary, fontSize: 13),
        ),
        const SizedBox(height: 16),

        _buildBenefitItem(
          icon: Icons.wifi_off_rounded,
          title: 'Unlimited Offline Playback',
          desc: 'Play all your songs, playlists, and recordings anywhere without an active internet connection.',
          color: const Color(0xFF10B981),
        ),
        _buildBenefitItem(
          icon: Icons.high_quality_rounded,
          title: 'Ultra Hi-Res Lossless Audio',
          desc: 'Enjoy master-grade studio audio quality (FLAC, Hi-Res 320kbps) with dynamic headroom.',
          color: const Color(0xFF3B82F6),
        ),
        _buildBenefitItem(
          icon: Icons.content_cut_rounded,
          title: 'Audio Stem Separation & Clip Studio',
          desc: 'Cut songs with millisecond precision, extract vocal/instrumental stems, and create custom clips.',
          color: const Color(0xFF8B5CF6),
        ),
        _buildBenefitItem(
          icon: Icons.merge_type_rounded,
          title: 'Multi-Track Audio Merge',
          desc: 'Combine multiple tracks with seamless crossfades, volume balancing, and master exports.',
          color: const Color(0xFFEC4899),
        ),
        _buildBenefitItem(
          icon: Icons.block_rounded,
          title: '100% Ad-Free Experience',
          desc: 'Zero interruptions, zero sponsor banners, and zero third-party tracking.',
          color: const Color(0xFFF59E0B),
        ),
        _buildBenefitItem(
          icon: Icons.cloud_sync_rounded,
          title: 'Cloud Library Sync & Backup',
          desc: 'Safely backup and synchronize your playlists, liked tracks, and clips across devices.',
          color: const Color(0xFF06B6D4),
        ),
        _buildBenefitItem(
          icon: Icons.support_agent_rounded,
          title: 'VIP Priority Support & Early Features',
          desc: 'Receive rapid dedicated support and get early access to upcoming features.',
          color: AppTheme.accent,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // VIEW 2: PENDING REVIEW (Cannot request new until approved/rejected)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildPendingReviewView() {
    final days = _pendingRequest!['requested_days'] ?? _extractDaysFromReason(_pendingRequest!['reason']);
    final phone = _pendingRequest!['phone_number'] ?? _extractPhoneFromReason(_pendingRequest!['reason']);
    final submittedAt = _formatTimestamp(_pendingRequest!['created_at']);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        // Animated icon badge
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.5), width: 2),
          ),
          child: const Icon(
            Icons.hourglass_top_rounded,
            color: Color(0xFFF59E0B),
            size: 46,
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Request Under Admin Review',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Your premium request has been submitted and is currently being evaluated by an administrator.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 28),

        // Submission Details Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SUBMISSION DETAILS',
                style: TextStyle(
                  color: AppTheme.textTertiary,
                  fontSize: 11,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                icon: Icons.calendar_month_rounded,
                label: 'Requested Duration',
                value: '$days Days',
                valueColor: AppTheme.accent,
              ),
              const Divider(color: Colors.white12, height: 20),
              _buildDetailRow(
                icon: Icons.phone_rounded,
                label: 'Contact Phone',
                value: phone.isNotEmpty ? phone : 'Not specified',
              ),
              const Divider(color: Colors.white12, height: 20),
              _buildDetailRow(
                icon: Icons.schedule_rounded,
                label: 'Submitted On',
                value: submittedAt,
              ),
              const Divider(color: Colors.white12, height: 20),
              _buildDetailRow(
                icon: Icons.pending_rounded,
                label: 'Status',
                value: 'Pending Approval',
                valueColor: const Color(0xFFF59E0B),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Lockout Explanatory Alert
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
          ),
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline_rounded, color: Color(0xFFF59E0B), size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'To prevent duplicate requests, you cannot submit a new request until an administrator approves or rejects this one.',
                  style: TextStyle(
                    color: Color(0xFFFDE68A),
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Refresh Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.refresh_rounded, size: 20),
            label: const Text('Check Approval Status', style: TextStyle(fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.accent,
              side: const BorderSide(color: AppTheme.accent, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: _fetchExistingRequest,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // VIEW 3: REQUEST FORM (Enabled only if no pending request and not active)
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildRequestFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // If previous request was rejected, show notice
          if (_rejectedRequest != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.error.withValues(alpha: 0.35)),
              ),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.cancel_outlined, color: AppTheme.error, size: 22),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Previous Request Not Approved',
                          style: TextStyle(
                            color: AppTheme.error,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Your earlier request was rejected by the admin. You may update your details and submit a new request below.',
                          style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.workspace_premium_rounded, color: AppTheme.accent, size: 32),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Request Access',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Submit a request for full premium VIP access.',
                      style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Phone Number Field
          const Text(
            'Phone Number *',
            style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            style: const TextStyle(color: AppTheme.textPrimary),
            decoration: InputDecoration(
              hintText: 'e.g. +91 9876543210',
              prefixIcon: const Icon(Icons.phone_rounded, color: AppTheme.accent, size: 20),
              filled: true,
              fillColor: AppTheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.accent, width: 1.5),
              ),
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please enter your phone number';
              }
              if (val.trim().length < 6) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),

          // Duration (How Many Days)
          const Text(
            'How Many Days? *',
            style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _daysController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: const TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              hintText: 'Number of days (e.g. 30)',
              suffixText: 'Days',
              suffixStyle: const TextStyle(color: AppTheme.accent, fontWeight: FontWeight.w600),
              prefixIcon: const Icon(Icons.calendar_today_rounded, color: AppTheme.accent, size: 20),
              filled: true,
              fillColor: AppTheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.accent, width: 1.5),
              ),
            ),
            validator: (val) {
              if (val == null || val.trim().isEmpty) {
                return 'Please enter the number of days';
              }
              final days = int.tryParse(val.trim());
              if (days == null || days <= 0) {
                return 'Must be at least 1 day';
              }
              if (days > 3650) {
                return 'Maximum 3650 days (10 years)';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),

          // Quick duration chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _presetDays.map((d) {
              final isSelected = _daysController.text.trim() == d.toString();
              return InkWell(
                onTap: () {
                  setState(() {
                    _daysController.text = d.toString();
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.accent : AppTheme.surfaceHighlight,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? AppTheme.accent : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    d == 365 ? '1 Year' : '$d Days',
                    style: TextStyle(
                      color: isSelected ? Colors.black : AppTheme.textSecondary,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Reason / Notes
          const Text(
            'Reason / Notes (Optional)',
            style: TextStyle(color: AppTheme.textPrimary, fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _reasonController,
            maxLines: 3,
            style: const TextStyle(color: AppTheme.textPrimary),
            decoration: InputDecoration(
              hintText: 'Why do you need premium access?',
              hintStyle: const TextStyle(color: AppTheme.textTertiary),
              filled: true,
              fillColor: AppTheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.accent, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: Colors.black,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _isSubmitting ? null : _submitRequest,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.black),
                    )
                  : const Text(
                      'Submit Premium Request',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // HELPER WIDGETS
  // ───────────────────────────────────────────────────────────────────────────
  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String desc,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    desc,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.textTertiary, size: 18),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return 'Recently';
    try {
      final dt = DateTime.parse(timestamp.toString()).toLocal();
      return '${dt.day} ${_monthName(dt.month)} ${dt.year}, ${_twoDigits(dt.hour)}:${_twoDigits(dt.minute)}';
    } catch (_) {
      return timestamp.toString();
    }
  }

  String _twoDigits(int n) => n >= 10 ? '$n' : '0$n';

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
  }

  int _extractDaysFromReason(dynamic reason) {
    if (reason == null) return 30;
    final str = reason.toString();
    final match = RegExp(r'Days:\s*(\d+)').firstMatch(str);
    if (match != null) return int.tryParse(match.group(1) ?? '30') ?? 30;
    return 30;
  }

  String _extractPhoneFromReason(dynamic reason) {
    if (reason == null) return '';
    final str = reason.toString();
    final match = RegExp(r'Phone:\s*([^\s\]|]+)').firstMatch(str);
    if (match != null) return match.group(1) ?? '';
    return '';
  }
}
