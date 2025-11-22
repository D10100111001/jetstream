import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../services/flight_service.dart';
import '../../services/auth_service.dart';
import '../../theme/theme.dart';

class FlightLogScreen extends StatefulWidget {
  const FlightLogScreen({super.key});

  @override
  State<FlightLogScreen> createState() => _FlightLogScreenState();
}

class _FlightLogScreenState extends State<FlightLogScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _isProcessing = false;
  String _processingStage = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _processInput() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _isProcessing = true;
      _processingStage = 'Analyzing your input...';
    });

    try {
      final flightService = context.read<FlightService>();
      final authService = context.read<AuthService>();
      final userId = authService.currentUser?.uid ?? 'demo';

      // Simulate AI processing stages
      await Future.delayed(const Duration(milliseconds: 800));
      setState(() => _processingStage = 'Extracting flight details...');

      await Future.delayed(const Duration(milliseconds: 800));
      setState(() => _processingStage = 'Analyzing sentiment...');

      await Future.delayed(const Duration(milliseconds: 600));
      setState(() => _processingStage = 'Generating insights...');

      // Process the flight
      await flightService.processNaturalLanguageInput(_controller.text, userId);

      if (mounted) {
        // Show success and navigate back
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle_rounded, color: Colors.white),
                SizedBox(width: 12),
                Text('Flight logged successfully!'),
              ],
            ),
            backgroundColor: JetstreamColors.electricTeal,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _processingStage = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Flight'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Tell us about your flight',
                  style: Theme.of(context).textTheme.headlineMedium,
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: -0.2, end: 0),

                const SizedBox(height: 12),

                Text(
                  'Just describe your flight naturally, and our AI will extract all the details.',
                  style: Theme.of(context).textTheme.bodyLarge,
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 100.ms)
                    .slideY(begin: -0.2, end: 0),

                const SizedBox(height: 32),

                // Input field
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        JetstreamColors.electricTeal.withOpacity(0.05),
                        JetstreamColors.purpleAccent.withOpacity(0.05),
                      ],
                    ),
                    border: Border.all(
                      color: JetstreamColors.electricTeal.withOpacity(0.2),
                      width: 2,
                    ),
                  ),
                  child: TextField(
                    controller: _controller,
                    maxLines: 8,
                    enabled: !_isProcessing,
                    style: Theme.of(context).textTheme.bodyLarge,
                    decoration: InputDecoration(
                      hintText:
                          'e.g., "Flew Delta from LAX to JFK last Friday. Great crew, but the middle seat was uncomfortable. Some turbulence during landing."',
                      hintStyle:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: JetstreamColors.mediumGray,
                              ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 200.ms)
                    .slideY(begin: 0.2, end: 0),

                const SizedBox(height: 24),

                // Example prompts
                _buildExamplePrompts(),

                const SizedBox(height: 32),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _processInput,
                    child: _isProcessing
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(_processingStage),
                            ],
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.auto_awesome_rounded),
                              SizedBox(width: 8),
                              Text('Process with AI'),
                            ],
                          ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms, delay: 300.ms)
                    .slideY(begin: 0.2, end: 0),
              ],
            ),
          ),

          // Processing overlay
          if (_isProcessing)
            Positioned.fill(
              child: Container(
                color:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                              color:
                                  JetstreamColors.electricTeal.withOpacity(0.5),
                              blurRadius: 30,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          size: 50,
                          color: Colors.white,
                        ),
                      )
                          .animate(onPlay: (controller) => controller.repeat())
                          .rotate(duration: 2000.ms)
                          .then()
                          .shimmer(duration: 1000.ms),
                      const SizedBox(height: 32),
                      Text(
                        _processingStage,
                        style: Theme.of(context).textTheme.titleLarge,
                      ).animate().fadeIn(duration: 300.ms),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExamplePrompts() {
    final examples = [
      'Flew United from SFO to ORD yesterday',
      'Amazing first class on Delta LAX to JFK',
      'Terrible delay on Southwest, crew was great though',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Try these examples:',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: JetstreamColors.mediumGray,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: examples.map((example) {
            return ActionChip(
              label: Text(example),
              onPressed: _isProcessing
                  ? null
                  : () {
                      _controller.text = example;
                    },
              backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
              side: BorderSide.none,
              labelStyle: Theme.of(context).textTheme.bodySmall,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            );
          }).toList(),
        ),
      ],
    ).animate().fadeIn(duration: 600.ms, delay: 250.ms);
  }
}
