import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/theme.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() =>
      _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState
    extends State<NotificationsSettingsScreen> {
  bool _flightReminders = true;
  bool _weeklySummaries = true;
  bool _achievements = false;
  bool _pushNotifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Manage your notification preferences',
            style: Theme.of(context).textTheme.bodyLarge,
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 32),
          _buildSection(
            context,
            title: 'Flight Notifications',
            children: [
              _buildSwitchTile(
                context,
                title: 'Flight Reminders',
                subtitle: 'Get reminded about upcoming flights',
                value: _flightReminders,
                onChanged: (value) {
                  setState(() {
                    _flightReminders = value;
                  });
                },
                icon: Icons.flight_takeoff_rounded,
              ),
            ],
          ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
          const SizedBox(height: 24),
          _buildSection(
            context,
            title: 'Activity Notifications',
            children: [
              _buildSwitchTile(
                context,
                title: 'Weekly Summaries',
                subtitle: 'Receive weekly flight statistics',
                value: _weeklySummaries,
                onChanged: (value) {
                  setState(() {
                    _weeklySummaries = value;
                  });
                },
                icon: Icons.insights_rounded,
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                context,
                title: 'Achievements',
                subtitle: 'Get notified about milestones',
                value: _achievements,
                onChanged: (value) {
                  setState(() {
                    _achievements = value;
                  });
                },
                icon: Icons.emoji_events_rounded,
              ),
            ],
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
          const SizedBox(height: 24),
          _buildSection(
            context,
            title: 'Delivery Method',
            children: [
              _buildSwitchTile(
                context,
                title: 'Push Notifications',
                subtitle: 'Receive notifications on this device',
                value: _pushNotifications,
                onChanged: (value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                },
                icon: Icons.notifications_active_rounded,
              ),
            ],
          ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).cardColor,
            border: Border.all(
              color: Theme.of(context).colorScheme.surfaceVariant,
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title),
      subtitle: Text(subtitle),
      secondary: Icon(
        icon,
        color: JetstreamColors.electricTeal,
      ),
      activeColor: JetstreamColors.electricTeal,
    );
  }
}
