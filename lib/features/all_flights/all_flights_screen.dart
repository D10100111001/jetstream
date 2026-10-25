import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../services/flight_service.dart';
import '../../theme/theme.dart';
import '../../models/flight.dart';

class AllFlightsScreen extends StatefulWidget {
  const AllFlightsScreen({super.key});

  @override
  State<AllFlightsScreen> createState() => _AllFlightsScreenState();
}

class _AllFlightsScreenState extends State<AllFlightsScreen> {
  String _sortBy = 'date'; // 'date', 'airline', 'rating'
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final flightService = context.watch<FlightService>();
    final flights = _getFilteredAndSortedFlights(flightService.flights);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Flights'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort_rounded),
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'date', child: Text('Sort by Date')),
              const PopupMenuItem(
                value: 'airline',
                child: Text('Sort by Airline'),
              ),
              const PopupMenuItem(
                value: 'rating',
                child: Text('Sort by Rating'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search flights...',
                prefixIcon: const Icon(Icons.search_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2, end: 0),

          // Flights count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${flights.length} flight${flights.length != 1 ? 's' : ''}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: JetstreamColors.mediumGray,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Flights list
          Expanded(
            child: flights.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: flights.length,
                    itemBuilder: (context, index) {
                      final flight = flights[index];
                      return _FlightCard(flight: flight)
                          .animate()
                          .fadeIn(duration: 400.ms, delay: (index * 50).ms)
                          .slideX(begin: 0.2, end: 0);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  List<Flight> _getFilteredAndSortedFlights(List<Flight> flights) {
    // Filter by search query
    var filtered = flights.where((flight) {
      if (_searchQuery.isEmpty) return true;
      return flight.airline.toLowerCase().contains(_searchQuery) ||
          flight.origin.toLowerCase().contains(_searchQuery) ||
          flight.destination.toLowerCase().contains(_searchQuery) ||
          flight.flightNumber.toLowerCase().contains(_searchQuery);
    }).toList();

    // Sort
    switch (_sortBy) {
      case 'date':
        filtered.sort((a, b) => b.departureTime.compareTo(a.departureTime));
        break;
      case 'airline':
        filtered.sort((a, b) => a.airline.compareTo(b.airline));
        break;
      case 'rating':
        filtered.sort((a, b) {
          final ratingA = a.experience?.overallRating ?? 0;
          final ratingB = b.experience?.overallRating ?? 0;
          return ratingB.compareTo(ratingA);
        });
        break;
    }

    return filtered;
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No flights found',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _FlightCard extends StatelessWidget {
  final Flight flight;

  const _FlightCard({required this.flight});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor,
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            context.push('/flight/${flight.id}');
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: JetstreamColors.electricTeal.withValues(
                              alpha: 0.1,
                            ),
                          ),
                          child: const Icon(
                            Icons.flight_rounded,
                            color: JetstreamColors.electricTeal,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              flight.airline,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              flight.flightNumber,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (flight.experience != null)
                      _buildRatingBadge(
                        context,
                        flight.experience!.overallRating,
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                // Route
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            flight.origin,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(
                            timeFormat.format(flight.departureTime),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Icon(
                            Icons.arrow_forward_rounded,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dateFormat.format(flight.departureTime),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            flight.destination,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          if (flight.arrivalTime != null)
                            Text(
                              timeFormat.format(flight.arrivalTime!),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Tags
                if (flight.experience != null &&
                    flight.experience!.tags.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: flight.experience!.tags.take(3).map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: _getTagColor(
                            flight.experience!.sentiment,
                          ).withValues(alpha: 0.1),
                          border: Border.all(
                            color: _getTagColor(
                              flight.experience!.sentiment,
                            ).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          tag,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: _getTagColor(
                                  flight.experience!.sentiment,
                                ),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBadge(BuildContext context, int rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _getRatingColor(rating).withValues(alpha: 0.1),
        border: Border.all(
          color: _getRatingColor(rating).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 16, color: _getRatingColor(rating)),
          const SizedBox(width: 4),
          Text(
            rating.toString(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: _getRatingColor(rating),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRatingColor(int rating) {
    if (rating >= 4) return JetstreamColors.electricTeal;
    if (rating >= 3) return JetstreamColors.goldenYellow;
    return JetstreamColors.sunsetOrange;
  }

  Color _getTagColor(String? sentiment) {
    switch (sentiment) {
      case 'positive':
        return JetstreamColors.electricTeal;
      case 'negative':
        return JetstreamColors.sunsetOrange;
      default:
        return JetstreamColors.mediumGray;
    }
  }
}
