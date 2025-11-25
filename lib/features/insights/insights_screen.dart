import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/flight_service.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  String? _insights;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _generateInsights();
  }

  Future<void> _generateInsights() async {
    final flightService = Provider.of<FlightService>(context, listen: false);

    if (flightService.flights.isEmpty) {
      setState(() {
        _insights =
            'Log some flights to see your personalized travel insights!';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await flightService.generateInsights();

      if (mounted) {
        setState(() {
          _insights = result;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _insights = 'Unable to generate insights. Please try again later.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Travel Insights'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateInsights,
            tooltip: 'Refresh Insights',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _insights ?? '',
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
