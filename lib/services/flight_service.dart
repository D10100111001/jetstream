import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/flight.dart';
import '../models/flight_analysis.dart';
import '../models/ai_flight_extraction.dart';
import 'dart:async';
import 'dart:math' as math;
import 'ai_service.dart';

class FlightService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AiService _aiService = AiService();
  final List<Flight> _flights = [];
  bool _isLoading = false;

  List<Flight> get flights => List.unmodifiable(_flights);
  bool get isLoading => _isLoading;
  
  /// Analyze natural language input to find candidates
  /// Returns analysis with extracted data and real flight candidates
  Future<FlightLogAnalysis> analyzeNaturalLanguageInput(String input) async {
    if (kDebugMode) print('✈️ FlightService: Analyzing input...');
    try {
      return await _aiService.analyzeFlightLog(input);
    } catch (e) {
      if (kDebugMode) print('❌ FlightService Error analyzing input: $e');
      rethrow;
    }
  }

  /// Create a Flight object from a selected candidate and AI extraction
  /// This prepares the flight for saving but doesn't save it yet
  Flight createFlightFromCandidate({
    required FlightCandidate candidate,
    required AIFlightExtraction extraction,
    required String userId,
    required String userInput,
  }) {
    // Parse date from candidate or extraction
    DateTime departureTime;
    try {
      // Candidate date is usually YYYY-MM-DD. Departure scheduled is full ISO.
      // Prefer scheduled departure if available
      if (candidate.departure?.scheduled != null) {
        departureTime = DateTime.parse(candidate.departure!.scheduled!);
      } else if (candidate.date != null) {
        departureTime = DateTime.parse(candidate.date!);
      } else if (extraction.date != null) {
        departureTime = DateTime.parse(extraction.date!);
      } else {
        departureTime = DateTime.now();
      }
    } catch (e) {
      departureTime = DateTime.now();
    }

    // Calculate arrival time
    DateTime arrivalTime;
    try {
       if (candidate.arrival?.scheduled != null) {
        arrivalTime = DateTime.parse(candidate.arrival!.scheduled!);
      } else {
        // Fallback to calculation
        final distance = _calculateDistance(
          candidate.departure?.iata ?? extraction.origin, 
          candidate.arrival?.iata ?? extraction.destination
        );
        final estimatedFlightTime = (distance / 500.0);
        arrivalTime = departureTime.add(Duration(minutes: (estimatedFlightTime * 60).round()));
      }
    } catch (e) {
      arrivalTime = departureTime.add(const Duration(hours: 2));
    }

    // Create experience
    final experience = FlightExperience(
      overallRating: extraction.rating,
      comment: userInput,
      tags: extraction.tags,
      categoryRatings: {
        'crew': extraction.rating,
        'comfort': extraction.rating,
        'boarding': extraction.rating,
        'entertainment': math.max(1, extraction.rating - 1),
      },
      sentiment: extraction.sentiment,
      highlights: extraction.highlights,
      issues: extraction.issues,
    );

    return Flight(
      userId: userId,
      airline: candidate.airline ?? extraction.airline,
      flightNumber: candidate.flightNumber ?? extraction.flightNumber,
      origin: candidate.departure?.iata ?? extraction.origin,
      destination: candidate.arrival?.iata ?? extraction.destination,
      departureTime: departureTime,
      arrivalTime: arrivalTime,
      aircraftType: candidate.aircraft ?? extraction.aircraftType,
      seatNumber: extraction.seatNumber,
      cabinClass: extraction.cabinClass,
      experience: experience,
    );
  }
  
  /// Create a Flight object from extraction only (fallback)
  Flight createFlightFromExtraction({
    required AIFlightExtraction extraction,
    required String userId,
    required String userInput,
  }) {
     // Parse date from structured extraction
    DateTime departureTime;
    try {
      if (extraction.date != null && extraction.date!.isNotEmpty) {
        departureTime = DateTime.parse(extraction.date!);
      } else {
        departureTime = DateTime.now().subtract(const Duration(days: 1));
      }
    } catch (e) {
      departureTime = DateTime.now().subtract(const Duration(days: 1));
    }

    // Calculate estimated arrival time based on distance
    final distance = _calculateDistance(extraction.origin, extraction.destination);
    final estimatedFlightTime = (distance / 500.0); // Average 500 mph
    final arrivalTime = departureTime.add(
      Duration(minutes: (estimatedFlightTime * 60).round()),
    );

    // Create flight experience from structured extraction
    final experience = FlightExperience(
      overallRating: extraction.rating,
      comment: userInput,
      tags: extraction.tags,
      categoryRatings: {
        'crew': extraction.rating,
        'comfort': extraction.rating,
        'boarding': extraction.rating,
        'entertainment': math.max(1, extraction.rating - 1),
      },
      sentiment: extraction.sentiment,
      highlights: extraction.highlights,
      issues: extraction.issues,
    );

    return Flight(
      userId: userId,
      airline: extraction.airline,
      flightNumber: extraction.flightNumber,
      origin: extraction.origin,
      destination: extraction.destination,
      departureTime: departureTime,
      arrivalTime: arrivalTime,
      aircraftType: extraction.aircraftType,
      seatNumber: extraction.seatNumber,
      cabinClass: extraction.cabinClass,
      experience: experience,
    );
  }

  /// Load flights for a specific user from Firestore
  Future<void> loadFlights(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await _firestore
          .collection('flights')
          .where('userId', isEqualTo: userId)
          .orderBy('departureTime', descending: true)
          .get();

      _flights.clear();
      for (final doc in snapshot.docs) {
        try {
          final flight = Flight.fromJson({...doc.data(), 'id': doc.id});
          _flights.add(flight);
        } catch (e) {
          if (kDebugMode) {
            print('Error parsing flight ${doc.id}: $e');
          }
        }
      }

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading flights: $e');
      }
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  UserStats get userStats {
    if (_flights.isEmpty) {
      return UserStats();
    }

    final airlineBreakdown = <String, int>{};
    final aircraftBreakdown = <String, int>{};
    var totalRating = 0.0;
    var ratingCount = 0;
    var totalMiles = 0;
    var totalMinutes = 0;

    for (final flight in _flights) {
      // Count airlines
      airlineBreakdown[flight.airline] =
          (airlineBreakdown[flight.airline] ?? 0) + 1;

      // Count aircraft
      if (flight.aircraftType != null) {
        aircraftBreakdown[flight.aircraftType!] =
            (aircraftBreakdown[flight.aircraftType!] ?? 0) + 1;
      }

      // Calculate average rating
      if (flight.experience != null) {
        totalRating += flight.experience!.overallRating;
        ratingCount++;
      }

      // Calculate actual miles and flight time
      final distance = _calculateDistance(flight.origin, flight.destination);
      totalMiles += distance;

      if (flight.arrivalTime != null) {
        final flightDuration =
            flight.arrivalTime!.difference(flight.departureTime).inMinutes;
        totalMinutes += flightDuration;
      } else {
        // Estimate based on distance (average 500 mph)
        totalMinutes += (distance / 500.0 * 60).round();
      }
    }

    // Find favorite airline (most flights)
    String? favoriteAirline;
    var maxFlights = 0;
    airlineBreakdown.forEach((airline, flightCount) {
      if (flightCount > maxFlights) {
        maxFlights = flightCount;
        favoriteAirline = airline;
      }
    });

    // Find favorite aircraft
    String? favoriteAircraft;
    var maxAircraftFlights = 0;
    aircraftBreakdown.forEach((aircraft, aircraftCount) {
      if (aircraftCount > maxAircraftFlights) {
        maxAircraftFlights = aircraftCount;
        favoriteAircraft = aircraft;
      }
    });

    return UserStats(
      totalFlights: _flights.length,
      totalMiles: totalMiles,
      totalHours: (totalMinutes / 60.0).round(),
      airlineBreakdown: airlineBreakdown,
      aircraftBreakdown: aircraftBreakdown,
      favoriteAirline: favoriteAirline,
      favoriteAircraft: favoriteAircraft,
      averageRating: ratingCount > 0 ? totalRating / ratingCount : 0.0,
    );
  }

  /// Process natural language flight log using AI with structured output
  Future<Flight> processNaturalLanguageInput(
      String input, String userId) async {
    if (kDebugMode) print('✈️ FlightService: Starting processNaturalLanguageInput...');
    try {
      // Use AI service to extract flight data with type-safe structured output
      if (kDebugMode) print('✈️ FlightService: Calling AI service...');
      final extraction = await _aiService.processFlightLog(input);
      if (kDebugMode) print('✅ FlightService: AI extraction complete.');

      // Parse date from structured extraction
      DateTime departureTime;
      try {
        if (extraction.date != null && extraction.date!.isNotEmpty) {
          departureTime = DateTime.parse(extraction.date!);
        } else {
          departureTime = DateTime.now().subtract(const Duration(days: 1));
        }
      } catch (e) {
        departureTime = DateTime.now().subtract(const Duration(days: 1));
      }

      // Calculate estimated arrival time based on distance
      if (kDebugMode) print('✈️ FlightService: Calculating distance...');
      final distance = _calculateDistance(extraction.origin, extraction.destination);
      final estimatedFlightTime = (distance / 500.0); // Average 500 mph
      final arrivalTime = departureTime.add(
        Duration(minutes: (estimatedFlightTime * 60).round()),
      );

      // Create flight experience from structured extraction
      final experience = FlightExperience(
        overallRating: extraction.rating,
        comment: input,
        tags: extraction.tags,
        categoryRatings: {
          'crew': extraction.rating,
          'comfort': extraction.rating,
          'boarding': extraction.rating,
          'entertainment': math.max(1, extraction.rating - 1),
        },
        sentiment: extraction.sentiment,
        highlights: extraction.highlights,
        issues: extraction.issues,
      );

      // Create flight object from structured extraction
      final flight = Flight(
        userId: userId,
        airline: extraction.airline,
        flightNumber: extraction.flightNumber,
        origin: extraction.origin,
        destination: extraction.destination,
        departureTime: departureTime,
        arrivalTime: arrivalTime,
        aircraftType: extraction.aircraftType,
        seatNumber: extraction.seatNumber,
        cabinClass: extraction.cabinClass,
        experience: experience,
      );

      // Add to Firestore
      if (kDebugMode) print('✈️ FlightService: Adding flight to Firestore...');
      await addFlight(flight);
      if (kDebugMode) print('✅ FlightService: Flight added to Firestore.');

      return flight;
    } catch (e) {
      if (kDebugMode) {
        print('❌ FlightService Error processing natural language input: $e');
      }
      rethrow;
    }
  }

  /// Add a flight to Firestore and local cache
  /// Returns the new Flight ID
  Future<String> addFlight(Flight flight) async {
    if (kDebugMode) print('🔥 FlightService: addFlight called for ${flight.airline} ${flight.flightNumber}');
    try {
      // Add to Firestore
      if (kDebugMode) print('🔥 FlightService: Waiting for Firestore .add()...');
      
      // Add timeout to fail fast if Firestore is stuck
      final docRef = await _firestore.collection('flights').add(flight.toJson())
          .timeout(const Duration(seconds: 10), onTimeout: () {
            throw TimeoutException('Firestore add timed out');
          });
          
      if (kDebugMode) print('✅ FlightService: Firestore document created: ${docRef.id}');

      // Update local cache with the correct ID
      final flightWithId = Flight(
        id: docRef.id,
        userId: flight.userId,
        airline: flight.airline,
        flightNumber: flight.flightNumber,
        origin: flight.origin,
        destination: flight.destination,
        departureTime: flight.departureTime,
        arrivalTime: flight.arrivalTime,
        aircraftType: flight.aircraftType,
        seatNumber: flight.seatNumber,
        cabinClass: flight.cabinClass,
        experience: flight.experience,
        createdAt: flight.createdAt,
        updatedAt: flight.updatedAt,
      );

      _flights.insert(0, flightWithId);
      notifyListeners();
      return docRef.id;
    } catch (e) {
      if (kDebugMode) {
        print('❌ FlightService Error adding flight: $e');
      }
      rethrow;
    }
  }

  /// Update a flight in Firestore and local cache
  Future<void> updateFlight(Flight flight) async {
    try {
      final updatedFlight = flight.copyWith(updatedAt: DateTime.now());

      // Update in Firestore
      await _firestore
          .collection('flights')
          .doc(flight.id)
          .update(updatedFlight.toJson());

      // Update local cache
      final index = _flights.indexWhere((f) => f.id == flight.id);
      if (index != -1) {
        _flights[index] = updatedFlight;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating flight: $e');
      }
      rethrow;
    }
  }

  /// Delete a flight from Firestore and local cache
  Future<void> deleteFlight(String flightId) async {
    try {
      // Delete from Firestore
      await _firestore.collection('flights').doc(flightId).delete();

      // Remove from local cache
      _flights.removeWhere((f) => f.id == flightId);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting flight: $e');
      }
      rethrow;
    }
  }

  Flight? getFlightById(String id) {
    try {
      return _flights.firstWhere((f) => f.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Calculate great circle distance between two airport codes in miles
  int _calculateDistance(String origin, String destination) {
    // Airport coordinates database (major US airports)
    final airportCoords = _getAirportCoordinates();

    final originCoords = airportCoords[origin.toUpperCase()];
    final destCoords = airportCoords[destination.toUpperCase()];

    if (originCoords == null || destCoords == null) {
      // Return average flight distance if airports not found
      return 1500;
    }

    return _haversineDistance(
      originCoords['lat']!,
      originCoords['lng']!,
      destCoords['lat']!,
      destCoords['lng']!,
    );
  }

  /// Haversine formula to calculate distance between two coordinates
  int _haversineDistance(double lat1, double lon1, double lat2, double lon2) {
    const R = 3958.8; // Earth's radius in miles

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return (R * c).round();
  }

  double _toRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  /// Get coordinates for major airports
  Map<String, Map<String, double>> _getAirportCoordinates() {
    return {
      // US Major Airports
      'JFK': {'lat': 40.6413, 'lng': -73.7781}, // New York JFK
      'LAX': {'lat': 33.9416, 'lng': -118.4085}, // Los Angeles
      'ORD': {'lat': 41.9742, 'lng': -87.9073}, // Chicago O'Hare
      'DFW': {'lat': 32.8998, 'lng': -97.0403}, // Dallas/Fort Worth
      'DEN': {'lat': 39.8561, 'lng': -104.6737}, // Denver
      'SFO': {'lat': 37.6213, 'lng': -122.3790}, // San Francisco
      'SEA': {'lat': 47.4502, 'lng': -122.3088}, // Seattle
      'LAS': {'lat': 36.0840, 'lng': -115.1537}, // Las Vegas
      'MCO': {'lat': 28.4312, 'lng': -81.3081}, // Orlando
      'MIA': {'lat': 25.7959, 'lng': -80.2870}, // Miami
      'ATL': {'lat': 33.6407, 'lng': -84.4277}, // Atlanta
      'BOS': {'lat': 42.3656, 'lng': -71.0096}, // Boston
      'IAH': {'lat': 29.9902, 'lng': -95.3368}, // Houston
      'PHX': {'lat': 33.4352, 'lng': -112.0101}, // Phoenix
      'EWR': {'lat': 40.6895, 'lng': -74.1745}, // Newark
      'MSP': {'lat': 44.8848, 'lng': -93.2223}, // Minneapolis
      'DTW': {'lat': 42.2162, 'lng': -83.3554}, // Detroit
      'PHL': {'lat': 39.8744, 'lng': -75.2424}, // Philadelphia
      'LGA': {'lat': 40.7769, 'lng': -73.8740}, // New York LaGuardia
      'CLT': {'lat': 35.2144, 'lng': -80.9473}, // Charlotte
      'SAN': {'lat': 32.7338, 'lng': -117.1933}, // San Diego
      'PDX': {'lat': 45.5898, 'lng': -122.5951}, // Portland
      'BWI': {'lat': 39.1774, 'lng': -76.6684}, // Baltimore
      'DCA': {'lat': 38.8521, 'lng': -77.0377}, // Washington Reagan
      'IAD': {'lat': 38.9531, 'lng': -77.4565}, // Washington Dulles
      'AUS': {'lat': 30.1945, 'lng': -97.6699}, // Austin
      'BNA': {'lat': 36.1263, 'lng': -86.6774}, // Nashville
      'RDU': {'lat': 35.8776, 'lng': -78.7875}, // Raleigh-Durham
      'SLC': {'lat': 40.7899, 'lng': -111.9791}, // Salt Lake City
      'MSY': {'lat': 29.9934, 'lng': -90.2580}, // New Orleans
      
      // International
      'LHR': {'lat': 51.4700, 'lng': -0.4543}, // London Heathrow
      'CDG': {'lat': 49.0097, 'lng': 2.5479}, // Paris Charles de Gaulle
      'FRA': {'lat': 50.0379, 'lng': 8.5622}, // Frankfurt
      'AMS': {'lat': 52.3105, 'lng': 4.7683}, // Amsterdam
      'DXB': {'lat': 25.2532, 'lng': 55.3657}, // Dubai
      'NRT': {'lat': 35.7653, 'lng': 140.3854}, // Tokyo Narita
      'HND': {'lat': 35.5494, 'lng': 139.7798}, // Tokyo Haneda
      'YYZ': {'lat': 43.6777, 'lng': -79.6248}, // Toronto
      'YVR': {'lat': 49.1967, 'lng': -123.1815}, // Vancouver
      'MEX': {'lat': 19.4363, 'lng': -99.0721}, // Mexico City
      'GRU': {'lat': -23.4356, 'lng': -46.4731}, // São Paulo
      'SYD': {'lat': -33.9399, 'lng': 151.1753}, // Sydney
      'SIN': {'lat': 1.3644, 'lng': 103.9915}, // Singapore
      'ICN': {'lat': 37.4602, 'lng': 126.4407}, // Seoul Incheon
      'HKG': {'lat': 22.3080, 'lng': 113.9185}, // Hong Kong
    };
  }

  /// Generate insights using AI based on flight history
  Future<String> generateInsights() async {
    try {
      final flightData = _flights.map((f) => {
        'airline': f.airline,
        'flightNumber': f.flightNumber,
        'origin': f.origin,
        'destination': f.destination,
        'rating': f.experience?.overallRating,
        'sentiment': f.experience?.sentiment,
      }).toList();

      return await _aiService.generateInsights(flightData);
    } catch (e) {
      if (kDebugMode) {
        print('Error generating insights: $e');
      }
      return 'Keep logging flights to get personalized insights!';
    }
  }
}
