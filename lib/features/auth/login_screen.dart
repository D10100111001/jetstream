import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';
import '../../theme/theme.dart';
import 'dart:math' as math;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final authService = context.read<AuthService>();
      await authService.signInWithGoogle();
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign in: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final authService = context.read<AuthService>();
      await authService.signInWithApple();
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign in: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
          _AnimatedGradientBackground(),

          // Floating particles
          ..._buildFloatingParticles(),

          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo and title
                    _buildHeader(),

                    const SizedBox(height: 60),

                    // Sign in buttons
                    _buildSignInButtons(),

                    const SizedBox(height: 40),

                    // Footer text
                    _buildFooter(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // App icon with glow effect
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                JetstreamColors.electricTeal,
                JetstreamColors.brightCyan,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: JetstreamColors.electricTeal.withOpacity(0.5),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: const Icon(
            Icons.flight_takeoff_rounded,
            size: 60,
            color: Colors.white,
          ),
        )
            .animate(onPlay: (controller) => controller.repeat())
            .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.3))
            .then()
            .shake(duration: 500.ms, hz: 2, curve: Curves.easeInOut),

        const SizedBox(height: 32),

        // App name
        Text(
          'Jetstream',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: JetstreamColors.starlightWhite,
                fontWeight: FontWeight.w900,
                letterSpacing: -2,
              ),
        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3, end: 0),

        const SizedBox(height: 12),

        // Tagline
        Text(
          'AI-Native Passenger Intelligence',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: JetstreamColors.lightGray,
                fontWeight: FontWeight.w400,
              ),
          textAlign: TextAlign.center,
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 200.ms)
            .slideY(begin: -0.3, end: 0),
      ],
    );
  }

  Widget _buildSignInButtons() {
    return Column(
      children: [
        // Google Sign In
        _SocialSignInButton(
          onPressed: _isLoading ? null : _handleGoogleSignIn,
          icon: Icons.g_mobiledata_rounded,
          label: 'Continue with Google',
          backgroundColor: Colors.white,
          foregroundColor: JetstreamColors.darkGray,
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 400.ms)
            .slideX(begin: -0.2, end: 0),

        const SizedBox(height: 16),

        // Apple Sign In
        _SocialSignInButton(
          onPressed: _isLoading ? null : _handleAppleSignIn,
          icon: Icons.apple_rounded,
          label: 'Continue with Apple',
          backgroundColor: Colors.white.withOpacity(0.1),
          foregroundColor: JetstreamColors.starlightWhite,
          borderColor: Colors.white.withOpacity(0.2),
        )
            .animate()
            .fadeIn(duration: 600.ms, delay: 500.ms)
            .slideX(begin: -0.2, end: 0),
      ],
    );
  }

  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          'By continuing, you agree to our',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: JetstreamColors.mediumGray,
              ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Terms of Service',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: JetstreamColors.electricTeal,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Text(
              ' and ',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: JetstreamColors.mediumGray,
                  ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Privacy Policy',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: JetstreamColors.electricTeal,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 600.ms);
  }

  List<Widget> _buildFloatingParticles() {
    return List.generate(20, (index) {
      final random = math.Random(index);
      return Positioned(
        left: random.nextDouble() * 400,
        top: random.nextDouble() * 800,
        child: Container(
          width: random.nextDouble() * 4 + 2,
          height: random.nextDouble() * 4 + 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.3),
          ),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .moveY(
              begin: 0,
              end: random.nextDouble() * 100 - 50,
              duration: Duration(milliseconds: 2000 + random.nextInt(2000)),
              curve: Curves.easeInOut,
            )
            .fadeIn(duration: 1000.ms)
            .then()
            .fadeOut(duration: 1000.ms),
      );
    });
  }
}

class _AnimatedGradientBackground extends StatefulWidget {
  @override
  State<_AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<_AnimatedGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                JetstreamColors.midnightBlue,
                JetstreamColors.deepNavy,
                Color.lerp(
                  JetstreamColors.midnightBlue,
                  JetstreamColors.electricTeal.withOpacity(0.2),
                  _controller.value,
                )!,
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SocialSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;

  const _SocialSignInButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: borderColor != null
            ? Border.all(color: borderColor!, width: 1)
            : null,
        boxShadow: borderColor == null
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: foregroundColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
