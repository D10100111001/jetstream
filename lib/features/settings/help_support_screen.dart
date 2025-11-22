import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../theme/theme.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  String _appVersion = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion = '${packageInfo.version} (${packageInfo.buildNumber})';
      });
    } catch (e) {
      setState(() {
        _appVersion = '1.0.0';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'We\'re here to help',
            style: Theme.of(context).textTheme.bodyLarge,
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 32),
          _buildSection(
            context,
            title: 'Frequently Asked Questions',
            children: [
              _buildFAQTile(
                context,
                question: 'How do I log a flight?',
                answer:
                    'Tap the "Log Flight" button on the home screen and describe your flight in natural language. Our AI will extract all the details.',
              ),
              const Divider(height: 1),
              _buildFAQTile(
                context,
                question: 'How accurate is the AI analysis?',
                answer:
                    'Our AI uses advanced natural language processing to extract flight details and sentiment. While highly accurate, you can always edit details after logging.',
              ),
              const Divider(height: 1),
              _buildFAQTile(
                context,
                question: 'Can I export my flight data?',
                answer:
                    'Yes! Go to Settings > Privacy > Export My Data to download all your flight information as a JSON file.',
              ),
              const Divider(height: 1),
              _buildFAQTile(
                context,
                question: 'Is my data secure?',
                answer:
                    'Absolutely. All your data is encrypted and stored securely. We never share your personal information with third parties.',
              ),
            ],
          ).animate().fadeIn(duration: 600.ms, delay: 100.ms),
          const SizedBox(height: 24),
          _buildSection(
            context,
            title: 'Contact',
            children: [
              ListTile(
                leading: const Icon(
                  Icons.email_outlined,
                  color: JetstreamColors.electricTeal,
                ),
                title: const Text('Email Support'),
                subtitle: const Text('support@jetstream.app'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  // TODO: Open email client
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening email client...')),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(
                  Icons.bug_report_outlined,
                  color: JetstreamColors.electricTeal,
                ),
                title: const Text('Report a Bug'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  _showBugReportDialog(context);
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: JetstreamColors.electricTeal,
                ),
                title: const Text('Suggest a Feature'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  _showFeatureSuggestionDialog(context);
                },
              ),
            ],
          ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
          const SizedBox(height: 24),
          _buildSection(
            context,
            title: 'About',
            children: [
              ListTile(
                leading: const Icon(
                  Icons.info_outline_rounded,
                  color: JetstreamColors.electricTeal,
                ),
                title: const Text('App Version'),
                subtitle: Text(_appVersion),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(
                  Icons.description_outlined,
                  color: JetstreamColors.electricTeal,
                ),
                title: const Text('Terms of Service'),
                trailing: const Icon(Icons.open_in_new_rounded),
                onTap: () {
                  // TODO: Open terms URL
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Opening terms of service...')),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(
                  Icons.gavel_rounded,
                  color: JetstreamColors.electricTeal,
                ),
                title: const Text('Licenses'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () {
                  showLicensePage(
                    context: context,
                    applicationName: 'Jetstream',
                    applicationVersion: _appVersion,
                  );
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

  Widget _buildFAQTile(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    return ExpansionTile(
      title: Text(question),
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            answer,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  void _showBugReportDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report a Bug'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Describe the bug...',
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
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
                    content: Text('Bug report submitted. Thank you!')),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showFeatureSuggestionDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suggest a Feature'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Describe your feature idea...',
            border: OutlineInputBorder(),
          ),
          maxLines: 5,
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
                  content: Text('Feature suggestion submitted. Thank you!'),
                ),
              );
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
