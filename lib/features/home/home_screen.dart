import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../services/flight_service.dart';
import '../../services/auth_service.dart';
import '../../theme/theme.dart';
import '../../models/flight.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load flights from Firestore on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final flightService = context.read<FlightService>();
      final authService = context.read<AuthService>();
      if (authService.currentUser != null) {
        flightService.loadFlights(authService.currentUser!.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final flightService = context.watch<FlightService>();
    final user = authService.currentUser;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          _buildAppBar(context, user),

          // Stats Cards
          SliverToBoxAdapter(
            child: _buildStatsSection(flightService.userStats),
          ),

          // Recent Flights Header
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Flights',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  if (flightService.flights.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        context.push('/all-flights');
                      },
                      child: const Text('See All'),
                    ),
                ],
              ),
            ),
          ),

          // Flights List
          if (flightService.flights.isEmpty)
            SliverFillRemaining(child: _buildEmptyState(context))
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final flight = flightService.flights[index];
                  return _FlightCard(flight: flight)
                      .animate()
                      .fadeIn(duration: 400.ms, delay: (index * 100).ms)
                      .slideY(begin: 0.2, end: 0);
                }, childCount: flightService.flights.length),
              ),
            ),

          // Bottom spacing
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/log-flight');
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Log Flight'),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, user) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back,', style: Theme.of(context).textTheme.bodySmall),
            Text(
              user?.displayName?.split(' ').first ?? 'Traveler',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person_outline_rounded),
          onPressed: () {
            context.push('/profile');
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildStatsSection(UserStats stats) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              icon: Icons.flight_takeoff_rounded,
              label: 'Flights',
              value: stats.totalFlights.toString(),
              color: JetstreamColors.electricTeal,
            ).animate().fadeIn(duration: 600.ms).scale(delay: 100.ms),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.public_rounded,
              label: 'Miles',
              value: _formatNumber(stats.totalMiles),
              color: JetstreamColors.sunsetOrange,
            ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatCard(
              icon: Icons.access_time_rounded,
              label: 'Hours',
              value: stats.totalHours.toString(),
              color: JetstreamColors.purpleAccent,
            ).animate().fadeIn(duration: 600.ms).scale(delay: 300.ms),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Icon(
              Icons.flight_rounded,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No flights logged yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Start logging your flights to see insights',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              context.push('/log-flight');
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Log Your First Flight'),
          ),
        ],
      ).animate().fadeIn(duration: 600.ms).scale(),
    );
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
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
        ),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
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
                // Header: Airline and Date
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
