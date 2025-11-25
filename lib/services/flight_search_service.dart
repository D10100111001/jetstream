import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FlightSearchService {
  final String _baseUrl = 'http://api.aviationstack.com/v1';
  final String _apiKey;

  FlightSearchService({String? apiKey})
      : _apiKey = apiKey ?? dotenv.env['AVIATION_STACK_API_KEY'] ?? '';

  bool get hasApiKey => _apiKey.isNotEmpty && _apiKey != 'your_key_here';

  /// Search for flights based on available criteria
  /// Returns a list of matching raw flight data
  Future<List<Map<String, dynamic>>> searchFlights({
    String? flightNumber,
    String? airlineName,
    String? date, // YYYY-MM-DD
    String? originIata,
    String? destinationIata,
  }) async {
    if (!hasApiKey) {
      if (kDebugMode) print('⚠️ No AviationStack API key provided.');
      return [];
    }

    try {
      final queryParams = {
        'access_key': _apiKey,
        'limit': '10', // Limit results to save bandwidth/quota
      };

      // Map our flexible inputs to strict API params
      if (flightNumber != null && flightNumber.isNotEmpty) {
        queryParams['flight_iata'] = flightNumber;
      }
      
      if (airlineName != null && airlineName.isNotEmpty) {
        queryParams['airline_name'] = airlineName;
      }

      if (date != null && date.isNotEmpty) {
        queryParams['flight_date'] = date;
      }
      
      if (originIata != null && originIata.isNotEmpty) {
        queryParams['dep_iata'] = originIata;
      }
      
      if (destinationIata != null && destinationIata.isNotEmpty) {
        queryParams['arr_iata'] = destinationIata;
      }
      
      // Construct URL
      final uri = Uri.parse('$_baseUrl/flights').replace(queryParameters: queryParams);
      
      if (kDebugMode) print('🔎 Searching Real-Time Flights: $uri');

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = List<Map<String, dynamic>>.from(data['data'] ?? []);
        
        if (kDebugMode) print('✅ Found ${results.length} flights');
        
        // Simplify the results to save context tokens for LLM
        return results.map((flight) {
          return {
            'date': flight['flight_date'],
            'status': flight['flight_status'],
            'airline': flight['airline']?['name'] ?? flight['airline']?['iata'],
            'flight_number': flight['flight']?['iata'] ?? flight['flight']?['number'],
            'departure': {
              'airport': flight['departure']?['airport'],
              'iata': flight['departure']?['iata'],
              'scheduled': flight['departure']?['scheduled'],
              'actual': flight['departure']?['actual'],
            },
            'arrival': {
              'airport': flight['arrival']?['airport'],
              'iata': flight['arrival']?['iata'],
              'scheduled': flight['arrival']?['scheduled'],
              'actual': flight['arrival']?['actual'],
            },
            'aircraft': flight['aircraft']?['iata'] ?? flight['aircraft']?['icao'],
          };
        }).toList();
      } else {
        if (kDebugMode) print('❌ Flight Search Error: ${response.statusCode} ${response.body}');
        return [];
      }
    } catch (e) {
      if (kDebugMode) print('❌ Flight Search Exception: $e');
      return [];
    }
  }
}

