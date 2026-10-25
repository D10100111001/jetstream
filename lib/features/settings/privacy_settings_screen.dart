import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../theme/theme.dart';
import '../../services/auth_service.dart';
import '../../services/flight_service.dart';

class PrivacySettingsScreen extends StatelessWidget {
  const PrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Manage your privacy and data',
            style: Theme.of(context).textTheme.bodyLarge,
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 32),
          _buildSection(
            context,
            title: 'Data Management',
            children: [
              ListTile(
                leading: const Icon(
                  Icons.download_rounded,
                  color: JetstreamColors.electricTeal,
                ),
                title: const Text('Export My Data'),
                subtitle: const Text('Download all your flight data'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  _showExportDialog(context);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(
                  Icons.delete_forever_rounded,
                  color: JetstreamColors.sunsetOrange,
                ),
                title: const Text('Delete All Data'),
                subtitle: const Text('Permanently delete all your flights'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  _showDeleteDataDialog(context);
                },
              ),
            ],
          ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
          const SizedBox(height: 24),
          _buildSection(
            context,
            title: 'Account',
            children: [
              ListTile(
                leading: const Icon(
                  Icons.person_remove_rounded,
                  color: Colors.red,
                ),
                title: const Text(
                  'Delete Account',
                  style: TextStyle(color: Colors.red),
                ),
                subtitle: const Text('Permanently delete your account'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  _showDeleteAccountDialog(context);
                },
              ),
            ],
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
          const SizedBox(height: 24),
          _buildSection(
            context,
            title: 'Legal',
            children: [
              ListTile(
                leading: const Icon(
                  Icons.privacy_tip_outlined,
                  color: JetstreamColors.electricTeal,
                ),
                title: const Text('Privacy Policy'),
                trailing: const Icon(Icons.open_in_new_rounded),
                onTap: () async {
                  final url = Uri.parse('https://jetstream.app/privacy');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Could not open privacy policy'),
                        ),
                      );
                    }
                  }
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(
                  Icons.description_outlined,
                  color: JetstreamColors.electricTeal,
                ),
                title: const Text('Terms of Service'),
                trailing: const Icon(Icons.open_in_new_rounded),
                onTap: () async {
                  final url = Uri.parse('https://jetstream.app/terms');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Could not open terms of service'),
                        ),
                      );
                    }
                  }
                },
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
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).cardColor,
            border: Border.all(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text(
          'Your flight data will be exported as a JSON file. This may take a few moments.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Export functionality coming soon'),
                ),
              );
            },
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete All Data'),
        content: const Text(
          'Are you sure you want to delete all your flight data? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('All data deleted')));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This will permanently delete all your data and cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                final authService = Provider.of<AuthService>(
                  context,
                  listen: false,
                );
                final flightService = Provider.of<FlightService>(
                  context,
                  listen: false,
                );

                // Delete all user flights from Firestore
                final userId = authService.currentUser?.uid;
                if (userId != null) {
                  // Delete all flights
                  for (final flight in flightService.flights) {
                    await flightService.deleteFlight(flight.id);
                  }
                }

                // Delete the user account
                await authService.deleteAccount();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Account deleted successfully'),
                    ),
                  );
                  context.go('/login');
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting account: ${e.toString()}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}
