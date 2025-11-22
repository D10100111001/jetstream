import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../services/flight_service.dart';
import '../../theme/theme.dart';
import '../../models/flight.dart';

class FlightDetailsScreen extends StatelessWidget {
  final String flightId;

  const FlightDetailsScreen({super.key, required this.flightId});

  @override
  Widget build(BuildContext context) {
    final flightService = context.watch<FlightService>();
    final flight = flightService.flights.firstWhere(
      (f) => f.id == flightId,
      orElse: () => throw Exception('Flight not found'),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flight Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Edit Flight'),
                  content: const Text(
                    'Flight editing will be available in a future update. For now, you can delete this flight and log it again with updated information.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Flight'),
                  content: const Text(
                      'Are you sure you want to delete this flight?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );

              if (confirmed == true && context.mounted) {
                flightService.deleteFlight(flightId);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Flight deleted')),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFlightHeader(context, flight),
            const SizedBox(height: 32),
            _buildFlightRoute(context, flight),
            const SizedBox(height: 32),
            if (flight.experience != null) ...[
              _buildExperienceSection(context, flight.experience!),
              const SizedBox(height: 32),
            ],
            _buildFlightInfo(context, flight),
          ],
        ),
      ),
    );
  }

  Widget _buildFlightHeader(BuildContext context, Flight flight) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    flight.airline,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  Text(
                    flight.flightNumber,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                  ),
                ],
              ),
              if (flight.experience != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Colors.white, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        flight.experience!.overallRating.toString(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildFlightRoute(BuildContext context, Flight flight) {
    final dateFormat = DateFormat('EEEE, MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceVariant,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Departure',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      flight.origin,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeFormat.format(flight.departureTime),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      dateFormat.format(flight.departureTime),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: JetstreamColors.electricTeal.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: JetstreamColors.electricTeal,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Arrival',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      flight.destination,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                    ),
                    const SizedBox(height: 4),
                    if (flight.arrivalTime != null) ...[
                      Text(
                        timeFormat.format(flight.arrivalTime!),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        dateFormat.format(flight.arrivalTime!),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ] else
                      Text(
                        'N/A',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 100.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildExperienceSection(
      BuildContext context, FlightExperience experience) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Experience',
          style: Theme.of(context).textTheme.headlineSmall,
        ).animate().fadeIn(duration: 600.ms, delay: 200.ms),
        const SizedBox(height: 16),

        // Sentiment badge
        if (experience.sentiment != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: _getSentimentColor(experience.sentiment).withOpacity(0.1),
              border: Border.all(
                color:
                    _getSentimentColor(experience.sentiment).withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getSentimentIcon(experience.sentiment),
                  color: _getSentimentColor(experience.sentiment),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  experience.sentiment!.toUpperCase(),
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: _getSentimentColor(experience.sentiment),
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 250.ms),

        const SizedBox(height: 16),

        // Comment/Narrative
        if (experience.comment != null)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color:
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
            ),
            child: Text(
              experience.comment!,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  ),
            ),
          ).animate().fadeIn(duration: 600.ms, delay: 300.ms),

        const SizedBox(height: 16),

        // Tags
        if (experience.tags.isNotEmpty) ...[
          Text(
            'Tags',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: experience.tags.map((tag) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: JetstreamColors.electricTeal.withOpacity(0.1),
                  border: Border.all(
                    color: JetstreamColors.electricTeal.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  tag,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: JetstreamColors.electricTeal,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              );
            }).toList(),
          ).animate().fadeIn(duration: 600.ms, delay: 350.ms),
          const SizedBox(height: 16),
        ],

        // Category Ratings
        if (experience.categoryRatings.isNotEmpty)
          ...[
            Text(
              'Category Ratings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...experience.categoryRatings.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key.toUpperCase(),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '${entry.value}/5',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: entry.value / 5,
                      backgroundColor:
                          Theme.of(context).colorScheme.surfaceVariant,
                      color: JetstreamColors.electricTeal,
                      minHeight: 8,
                    ),
                  ],
                ),
              );
            }),
          ].animate().fadeIn(duration: 600.ms, delay: 400.ms),

        // Highlights
        if (experience.highlights.isNotEmpty)
          ...[
            const SizedBox(height: 16),
            Text(
              'Highlights',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...experience.highlights.map((highlight) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: JetstreamColors.electricTeal,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        highlight,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ].animate().fadeIn(duration: 600.ms, delay: 450.ms),

        // Issues
        if (experience.issues.isNotEmpty)
          ...[
            const SizedBox(height: 16),
            Text(
              'Issues',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...experience.issues.map((issue) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_rounded,
                      color: JetstreamColors.sunsetOrange,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        issue,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ].animate().fadeIn(duration: 600.ms, delay: 500.ms),
      ],
    );
  }

  Widget _buildFlightInfo(BuildContext context, Flight flight) {
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
            'Flight Information',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          if (flight.aircraftType != null)
            _buildInfoRow(context, 'Aircraft', flight.aircraftType!),
          if (flight.seatNumber != null)
            _buildInfoRow(context, 'Seat', flight.seatNumber!),
          if (flight.cabinClass != null)
            _buildInfoRow(context, 'Class', flight.cabinClass!),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 550.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: JetstreamColors.mediumGray,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Color _getSentimentColor(String? sentiment) {
    switch (sentiment) {
      case 'positive':
        return JetstreamColors.electricTeal;
      case 'negative':
        return JetstreamColors.sunsetOrange;
      default:
        return JetstreamColors.mediumGray;
    }
  }

  IconData _getSentimentIcon(String? sentiment) {
    switch (sentiment) {
      case 'positive':
        return Icons.sentiment_satisfied_rounded;
      case 'negative':
        return Icons.sentiment_dissatisfied_rounded;
      default:
        return Icons.sentiment_neutral_rounded;
    }
  }
}
