import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../services/flight_service.dart';
import '../../services/auth_service.dart';
import '../../theme/theme.dart';
import '../../models/flight_analysis.dart';
import '../../models/ai_flight_extraction.dart';
import '../../models/flight.dart';

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

    if (kDebugMode) print('📝 FlightLogScreen: Processing input: "${_controller.text}"');

    setState(() {
      _isProcessing = true;
      _processingStage = 'Analyzing your input...';
    });

    try {
      final flightService = context.read<FlightService>();


      setState(() => _processingStage = 'Searching flights...');
      
      // Analyze input (Extract + Search)
      final analysis = await flightService.analyzeNaturalLanguageInput(_controller.text);
      
      if (kDebugMode) print('✅ Analysis complete. Found ${analysis.candidates.length} candidates');

      if (!mounted) return;

      // Stop processing state to show selection UI
      setState(() {
        _isProcessing = false;
        _processingStage = '';
      });

      // Show selection UI
      _showCandidateSelection(analysis);

    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ FlightLogScreen: Error processing flight: $e');
        print('Stack trace: $stackTrace');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          _isProcessing = false;
          _processingStage = '';
        });
      }
    }
  }

  void _showCandidateSelection(FlightLogAnalysis analysis) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CandidateSelectionSheet(
        analysis: analysis,
        onSelect: (candidate) => _saveFlight(candidate, analysis.extraction),
        onManual: () => _saveFlight(null, analysis.extraction),
      ),
    );
  }

  Future<void> _saveFlight(FlightCandidate? candidate, AIFlightExtraction extraction) async {
    Navigator.of(context).pop(); // Close the sheet

    setState(() {
      _isProcessing = true;
      _processingStage = 'Saving flight...';
    });

    try {
      final flightService = context.read<FlightService>();
      final authService = context.read<AuthService>();
      final userId = authService.currentUser?.uid ?? 'demo';

      Flight flight;
      if (candidate != null) {
        flight = flightService.createFlightFromCandidate(
          candidate: candidate,
          extraction: extraction,
          userId: userId,
          userInput: _controller.text,
        );
      } else {
        flight = flightService.createFlightFromExtraction(
          extraction: extraction,
          userId: userId,
          userInput: _controller.text,
        );
      }

      final flightId = await flightService.addFlight(flight);

      if (mounted) {
        // Show success snackbar
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
            duration: const Duration(seconds: 2),
          ),
        );

        // Navigate to flight details, replacing the log screen
        // This ensures back button goes to dashboard, not back to log form
        context.pushReplacement('/flight/$flightId');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving flight: $e'),
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
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
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

class _CandidateSelectionSheet extends StatelessWidget {
  final FlightLogAnalysis analysis;
  final ValueChanged<FlightCandidate> onSelect;
  final VoidCallback onManual;

  const _CandidateSelectionSheet({
    required this.analysis,
    required this.onSelect,
    required this.onManual,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Select Your Flight',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (analysis.candidates.isEmpty)
                  TextButton(
                    onPressed: onManual,
                    child: const Text('Enter Manually'),
                  ),
              ],
            ),
          ),
          
          if (analysis.candidates.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off_rounded, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No matching flights found',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We couldn\'t verify the exact flight details.\nYou can still log it manually.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: onManual,
                      child: const Text('Use Manual Details'),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: analysis.candidates.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final flight = analysis.candidates[index];
                  return _FlightCandidateCard(
                    flight: flight,
                    onTap: () => onSelect(flight),
                  );
                },
              ),
            ),
            
          // Footer
          if (analysis.candidates.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton(
                onPressed: onManual,
                child: const Text('None of these match? Use manual entry'),
              ),
            ),
        ],
      ),
    );
  }
}

class _FlightCandidateCard extends StatelessWidget {
  final FlightCandidate flight;
  final VoidCallback onTap;

  const _FlightCandidateCard({
    required this.flight,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final depTime = flight.departure?.scheduled ?? flight.departure?.actual;
    final arrTime = flight.arrival?.scheduled ?? flight.arrival?.actual;
    
    String formatTime(String? iso) {
      if (iso == null) return '--:--';
      try {
        return DateFormat.jm().format(DateTime.parse(iso));
      } catch (e) {
        return '--:--';
      }
    }

    Color statusColor;
    switch (flight.status?.toLowerCase()) {
      case 'active':
      case 'landed':
        statusColor = Colors.green;
        break;
      case 'cancelled':
        statusColor = Colors.red;
        break;
      case 'scheduled':
        statusColor = Colors.blue;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      flight.status?.toUpperCase() ?? 'UNKNOWN',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${flight.airline} • ${flight.flightNumber}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildAirportColumn(
                    context,
                    flight.departure?.iata ?? '---',
                    formatTime(depTime),
                    CrossAxisAlignment.start,
                  ),
                  const Icon(Icons.flight_takeoff_rounded, color: Colors.grey),
                  _buildAirportColumn(
                    context,
                    flight.arrival?.iata ?? '---',
                    formatTime(arrTime),
                    CrossAxisAlignment.end,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAirportColumn(
    BuildContext context,
    String code,
    String time,
    CrossAxisAlignment alignment,
  ) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          code,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
