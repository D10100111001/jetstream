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
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile header
            _buildProfileHeader(context, user),

            const SizedBox(height: 32),

            // Stats grid
            _buildStatsGrid(context, stats),

            const SizedBox(height: 32),

            // Settings section
            _buildSettingsSection(context),

            const SizedBox(height: 24),

            // Sign out button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await authService.signOut();
                  if (context.mounted) {
                    context.go('/login');
                  }
                },
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Sign Out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: JetstreamColors.sunsetOrange,
                  side: const BorderSide(color: JetstreamColors.sunsetOrange),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, user) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                JetstreamColors.electricTeal,
                JetstreamColors.purpleAccent,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: JetstreamColors.electricTeal.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: user?.photoURL != null
              ? ClipOval(
                  child: Image.network(
                    user!.photoURL!,
                    fit: BoxFit.cover,
                  ),
                )
              : Center(
                  child: Text(
                    user?.displayName?.substring(0, 1).toUpperCase() ?? 'U',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ),
        ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),
        const SizedBox(height: 16),
        Text(
          user?.displayName ?? 'Anonymous User',
          style: Theme.of(context).textTheme.headlineSmall,
        ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
        const SizedBox(height: 4),
        Text(
          user?.email ?? '',
          style: Theme.of(context).textTheme.bodyMedium,
        ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, stats) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Stats',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.flight_takeoff_rounded,
                  label: 'Total Flights',
                  value: stats.totalFlights.toString(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatItem(
                  icon: Icons.public_rounded,
                  label: 'Total Miles',
                  value: _formatNumber(stats.totalMiles),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  icon: Icons.access_time_rounded,
                  label: 'Total Hours',
                  value: stats.totalHours.toString(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _StatItem(
                  icon: Icons.star_rounded,
                  label: 'Avg Rating',
                  value: stats.averageRating.toStringAsFixed(1),
                ),
              ),
            ],
          ),
          if (stats.favoriteAirline != null) ...[
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            _InfoRow(
              icon: Icons.favorite_rounded,
              label: 'Favorite Airline',
              value: stats.favoriteAirline!,
            ),
          ],
          if (stats.favoriteAircraft != null) ...[
            const SizedBox(height: 12),
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
        .fadeIn(duration: 600.ms, delay: 300.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildSettingsSection(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          ListTile(
            leading: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
              color: JetstreamColors.electricTeal,
            ),
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: themeProvider.themeMode == ThemeMode.dark,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
              activeColor: JetstreamColors.electricTeal,
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(
              Icons.notifications_outlined,
              color: JetstreamColors.electricTeal,
            ),
            title: const Text('Notifications'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              context.push('/settings/notifications');
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(
              Icons.privacy_tip_outlined,
              color: JetstreamColors.electricTeal,
            ),
            title: const Text('Privacy'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              context.push('/settings/privacy');
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(
              Icons.help_outline_rounded,
              color: JetstreamColors.electricTeal,
            ),
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () {
              context.push('/settings/help');
            },
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 400.ms)
        .slideY(begin: 0.2, end: 0);
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

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: JetstreamColors.electricTeal,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
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
    return Row(
      children: [
        Icon(
          icon,
          color: JetstreamColors.sunsetOrange,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
