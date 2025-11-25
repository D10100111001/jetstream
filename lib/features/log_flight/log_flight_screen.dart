import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/flight_service.dart';
import '../../services/auth_service.dart';

class LogFlightScreen extends StatefulWidget {
  const LogFlightScreen({super.key});

  @override
  State<LogFlightScreen> createState() => _LogFlightScreenState();
}

class _LogFlightScreenState extends State<LogFlightScreen> {
  final _textController = TextEditingController();
  bool _isProcessing = false;

  Future<void> _processLog() async {
    if (_textController.text.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final flightService = Provider.of<FlightService>(context, listen: false);
      final authService = Provider.of<AuthService>(context, listen: false);
      final userId = authService.currentUser?.uid;

      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Process the input using the flight service
      final flight = await flightService.processNaturalLanguageInput(
        _textController.text,
        userId,
      );

      if (!mounted) return;

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Flight Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                _buildDetailRow('Airline', flight.airline),
                _buildDetailRow(
                  'Route',
                  '${flight.origin} → ${flight.destination}',
                ),
                _buildDetailRow(
                  'Date',
                  flight.departureTime.toLocal().toString().split(' ')[0],
                ),
                _buildDetailRow(
                  'Sentiment',
                  flight.experience?.sentiment?.toUpperCase() ?? 'N/A',
                ),
                if (flight.experience?.overallRating != null)
                  _buildDetailRow(
                      'Est. Rating', '${flight.experience!.overallRating}/5.0'),
                const SizedBox(height: 8),
                const Text(
                  'Narrative:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(flight.experience?.comment ?? 'No narrative generated.'),
                const SizedBox(height: 8),
                const Text(
                  'Tags:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Wrap(
                  spacing: 4,
                  children: (flight.experience?.tags ?? [])
                      .map(
                        (t) => Chip(
                          label: Text(t, style: const TextStyle(fontSize: 10)),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: const Text('Confirm & Log'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        if (!mounted) return;
        _textController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Flight Logged Successfully!')),
        );
      } else {
        // User cancelled, delete the flight that was already added
        if (!mounted) return;
        await flightService.deleteFlight(flight.id);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Log a New Flight')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tell us about your trip',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'e.g., "Flew Delta from JFK to LHR last Tuesday. The food was great but the seat was cramped."',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Type your story here...',
                border: OutlineInputBorder(),
                filled: true,
              ),
              maxLines: 6,
            ),
            const SizedBox(height: 16),
            if (_isProcessing)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton.icon(
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Analyze & Log Flight'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _processLog,
              ),
          ],
        ),
      ),
    );
  }
}
