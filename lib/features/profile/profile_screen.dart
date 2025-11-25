import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';
import '../../services/flight_service.dart';
import '../../theme/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final flightService = context.watch<FlightService>();
    final user = authService.currentUser;
    final stats = flightService.userStats;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            // Profile header
            _buildProfileHeader(context, user),

            const SizedBox(height: 32),

            // Stats grid
            _buildStatsGrid(context, stats),

            const SizedBox(height: 24),

            // Settings section
            _buildSettingsSection(context),

            const SizedBox(height: 24),

            // Sign out button
            _buildSignOutButton(context, authService),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, user) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [JetstreamColors.sunsetOrange, Color(0xFFFF8C5A)],
            ),
            boxShadow: [
              BoxShadow(
                color: JetstreamColors.sunsetOrange.withOpacity(0.4),
                blurRadius: 24,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: user?.photoURL != null
              ? ClipOval(
                  child: Image.network(user!.photoURL!, fit: BoxFit.cover),
                )
              : Center(
                  child: Text(
                    user?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 48,
                    ),
                  ),
                ),
        ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
        const SizedBox(height: 20),
        Text(
          user?.displayName ?? 'Anonymous User',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
        const SizedBox(height: 6),
        Text(
          user?.email ?? '',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isDark
                ? JetstreamColors.lightGray
                : JetstreamColors.mediumGray,
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, stats) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            'Your Stats',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Stats grid
        Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.flight_takeoff_rounded,
                    iconColor: JetstreamColors.electricTeal,
                    label: 'Total Flights',
                    value: stats.totalFlights.toString(),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        JetstreamColors.electricTeal.withOpacity(
                          isDark ? 0.15 : 0.08,
                        ),
                        JetstreamColors.electricTeal.withOpacity(
                          isDark ? 0.05 : 0.02,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.public_rounded,
                    iconColor: JetstreamColors.purpleAccent,
                    label: 'Total Miles',
                    value: _formatNumber(stats.totalMiles),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        JetstreamColors.purpleAccent.withOpacity(
                          isDark ? 0.15 : 0.08,
                        ),
                        JetstreamColors.purpleAccent.withOpacity(
                          isDark ? 0.05 : 0.02,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
            .animate()
            .fadeIn(duration: 600.ms, delay: 200.ms)
            .slideX(begin: -0.1, end: 0),

        const SizedBox(height: 12),

        Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.access_time_rounded,
                    iconColor: JetstreamColors.sunsetOrange,
                    label: 'Total Hours',
                    value: stats.totalHours.toString(),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        JetstreamColors.sunsetOrange.withOpacity(
                          isDark ? 0.15 : 0.08,
                        ),
                        JetstreamColors.sunsetOrange.withOpacity(
                          isDark ? 0.05 : 0.02,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.star_rounded,
                    iconColor: JetstreamColors.goldenYellow,
                    label: 'Avg Rating',
                    value: stats.averageRating.toStringAsFixed(1),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        JetstreamColors.goldenYellow.withOpacity(
                          isDark ? 0.15 : 0.08,
                        ),
                        JetstreamColors.goldenYellow.withOpacity(
                          isDark ? 0.05 : 0.02,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
            .animate()
            .fadeIn(duration: 600.ms, delay: 300.ms)
            .slideX(begin: -0.1, end: 0),

        // Favorite airline and aircraft
        if (stats.favoriteAirline != null ||
            stats.favoriteAircraft != null) ...[
          const SizedBox(height: 12),
          Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: isDark
                      ? JetstreamColors.deepNavy.withOpacity(0.6)
                      : Colors.white,
                  border: Border.all(
                    color: isDark
                        ? JetstreamColors.darkGray.withOpacity(0.3)
                        : JetstreamColors.paleGray.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    if (stats.favoriteAirline != null) ...[
                      _InfoRow(
                        icon: Icons.favorite_rounded,
                        label: 'Favorite Airline',
                        value: stats.favoriteAirline!,
                      ),
                    ],
                    if (stats.favoriteAircraft != null) ...[
                      if (stats.favoriteAirline != null)
                        const SizedBox(height: 16),
                      _InfoRow(
                        icon: Icons.airplanemode_active_rounded,
                        label: 'Favorite Aircraft',
                        value: stats.favoriteAircraft!,
                      ),
                    ],
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 400.ms)
              .slideY(begin: 0.1, end: 0),
        ],
      ],
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            'Settings',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Dark mode toggle
        _SettingsCard(
              icon: themeProvider.themeMode == ThemeMode.dark
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
              iconColor: JetstreamColors.purpleAccent,
              title: 'Dark Mode',
              trailing: Switch(
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
                activeColor: JetstreamColors.electricTeal,
                activeTrackColor: JetstreamColors.electricTeal.withOpacity(0.3),
              ),
            )
            .animate()
            .fadeIn(duration: 600.ms, delay: 450.ms)
            .slideX(begin: -0.05, end: 0),

        const SizedBox(height: 10),

        // Notifications
        _SettingsCard(
              icon: Icons.notifications_rounded,
              iconColor: JetstreamColors.sunsetOrange,
              title: 'Notifications',
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: isDark
                    ? JetstreamColors.mediumGray
                    : JetstreamColors.lightGray,
              ),
              onTap: () => context.push('/settings/notifications'),
            )
            .animate()
            .fadeIn(duration: 600.ms, delay: 500.ms)
            .slideX(begin: -0.05, end: 0),

        const SizedBox(height: 10),

        // Privacy
        _SettingsCard(
              icon: Icons.shield_rounded,
              iconColor: JetstreamColors.electricTeal,
              title: 'Privacy',
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: isDark
                    ? JetstreamColors.mediumGray
                    : JetstreamColors.lightGray,
              ),
              onTap: () => context.push('/settings/privacy'),
            )
            .animate()
            .fadeIn(duration: 600.ms, delay: 550.ms)
            .slideX(begin: -0.05, end: 0),

        const SizedBox(height: 10),

        // Help & Support
        _SettingsCard(
              icon: Icons.help_rounded,
              iconColor: JetstreamColors.goldenYellow,
              title: 'Help & Support',
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: isDark
                    ? JetstreamColors.mediumGray
                    : JetstreamColors.lightGray,
              ),
              onTap: () => context.push('/settings/help'),
            )
            .animate()
            .fadeIn(duration: 600.ms, delay: 600.ms)
            .slideX(begin: -0.05, end: 0),
      ],
    );
  }

  Widget _buildSignOutButton(BuildContext context, AuthService authService) {
    return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                JetstreamColors.sunsetOrange.withOpacity(0.1),
                JetstreamColors.sunsetOrange.withOpacity(0.05),
              ],
            ),
            border: Border.all(
              color: JetstreamColors.sunsetOrange.withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                await authService.signOut();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      color: JetstreamColors.sunsetOrange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Sign Out',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: JetstreamColors.sunsetOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: 650.ms)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Gradient gradient;

  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: gradient,
        border: Border.all(
          color: iconColor.withOpacity(isDark ? 0.2 : 0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(isDark ? 0.2 : 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 28,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isDark
            ? JetstreamColors.deepNavy.withOpacity(0.6)
            : Colors.white,
        border: Border.all(
          color: isDark
              ? JetstreamColors.darkGray.withOpacity(0.3)
              : JetstreamColors.paleGray.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(isDark ? 0.15 : 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: JetstreamColors.sunsetOrange.withOpacity(
              isDark ? 0.15 : 0.1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: JetstreamColors.sunsetOrange, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
