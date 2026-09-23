import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

/// A rich, animated music-themed loading screen.
/// Replaces any blank or boring loading state with an engaging visual experience.
class MusicLoadingScreen extends StatefulWidget {
  const MusicLoadingScreen({
    super.key,
    this.message = 'Tuning your music universe...',
  });

  final String message;

  @override
  State<MusicLoadingScreen> createState() => _MusicLoadingScreenState();
}

class _MusicLoadingScreenState extends State<MusicLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int _messageIndex = 0;
  Timer? _messageTimer;

  static const _messages = [
    'Tuning your music universe...',
    'Harmonizing audio library...',
    'Setting up your stage...',
    'Almost ready to groove...',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _messageTimer = Timer.periodic(const Duration(seconds: 2), (t) {
      if (!mounted) return;
      setState(() {
        _messageIndex = (_messageIndex + 1) % _messages.length;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _messageTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        alignment: Alignment.center,
        children: [
          // ─── Ambient Glow in Background ────────────────────────
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.accent.withValues(alpha: 0.15 + 0.1 * _controller.value),
                      const Color(0xFF9C27B0).withValues(alpha: 0.08 * (1.0 - _controller.value)),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              );
            },
          ),

          // ─── Content ────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated glowing logo container
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final scale = 1.0 + (_controller.value * 0.06);
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceElevated,
                            borderRadius: BorderRadius.circular(26),
                            border: Border.all(
                              color: AppTheme.accent.withValues(
                                alpha: 0.4 + 0.4 * _controller.value,
                              ),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.accent.withValues(
                                  alpha: 0.25 + 0.25 * _controller.value,
                                ),
                                blurRadius: 28,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.music_note_rounded,
                              color: AppTheme.accent,
                              size: 46,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 36),

                  // Brand name
                  Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                  ),

                  const SizedBox(height: 24),

                  // ─── Animated Equalizer Wave Bars ────────────────
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          // Staggered sine heights
                          final offset = index * 0.25;
                          final wave = ((_controller.value + offset) % 1.0);
                          final height = 12.0 + 26.0 * (wave < 0.5 ? wave * 2 : (1.0 - wave) * 2);
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3.5),
                            width: 5,
                            height: height,
                            decoration: BoxDecoration(
                              color: index % 2 == 0 ? AppTheme.accent : AppTheme.secondaryLight,
                              borderRadius: BorderRadius.circular(3),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.accent.withValues(alpha: 0.4),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    },
                  ),

                  const SizedBox(height: 28),

                  // ─── Rotating inspiring status text ──────────────
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: Text(
                      _messages[_messageIndex],
                      key: ValueKey<int>(_messageIndex),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
