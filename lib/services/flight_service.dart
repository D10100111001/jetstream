import 'package:flutter/foundation.dart';
import '../models/flight.dart';
import 'dart:math' as math;

class FlightService extends ChangeNotifier {
  final List<Flight> _flights = [];
  final math.Random _random = math.Random();

  List<Flight> get flights => List.unmodifiable(_flights);

  UserStats get userStats {
    if (_flights.isEmpty) {
      return UserStats();
    }

    final airlineBreakdown = <String, int>{};
    final aircraftBreakdown = <String, int>{};
    var totalRating = 0.0;
    var ratingCount = 0;

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
    }

    // Find favorite airline (most flights)
    String? favoriteAirline;
    var maxFlights = 0;
    airlineBreakdown.forEach((airline, count) {
      if (count > maxFlights) {
        maxFlights = count;
        favoriteAirline = airline;
      }
    });

    // Find favorite aircraft
    String? favoriteAircraft;
    var maxAircraftFlights = 0;
    aircraftBreakdown.forEach((aircraft, count) {
      if (count > maxAircraftFlights) {
        maxAircraftFlights = count;
        favoriteAircraft = aircraft;
      }
    });

    return UserStats(
      totalFlights: _flights.length,
      totalMiles: _flights.length * 1500, // Mock calculation
      totalHours: _flights.length * 3, // Mock calculation
      airlineBreakdown: airlineBreakdown,
      aircraftBreakdown: aircraftBreakdown,
      favoriteAirline: favoriteAirline,
      favoriteAircraft: favoriteAircraft,
      averageRating: ratingCount > 0 ? totalRating / ratingCount : 0.0,
    );
  }

  // Mock AI processing of natural language input
  Future<Flight> processNaturalLanguageInput(
      String input, String userId) async {
    // Simulate AI processing delay
    await Future.delayed(const Duration(seconds: 2));

    // Mock AI extraction (in reality, this would call an LLM API)
    final mockData = _mockExtractFlightData(input);

    // Create flight with AI-generated experience
    final flight = Flight(
      userId: userId,
      airline: mockData['airline'] as String,
      flightNumber: mockData['flightNumber'] as String,
      origin: mockData['origin'] as String,
      destination: mockData['destination'] as String,
      departureTime: mockData['departureTime'] as DateTime,
      arrivalTime: mockData['arrivalTime'] as DateTime?,
      aircraftType: mockData['aircraftType'] as String?,
      seatNumber: mockData['seatNumber'] as String?,
      cabinClass: mockData['cabinClass'] as String?,
      experience: mockData['experience'] as FlightExperience?,
    );

    _flights.insert(0, flight); // Add to beginning
    notifyListeners();

    return flight;
  }

  // Mock AI data extraction
  Map<String, dynamic> _mockExtractFlightData(String input) {
    final inputLower = input.toLowerCase();

    // Extract airline (mock)
    String airline = 'Delta';
    if (inputLower.contains('united')) airline = 'United';
    if (inputLower.contains('american')) airline = 'American Airlines';
    if (inputLower.contains('southwest')) airline = 'Southwest';
    if (inputLower.contains('jetblue')) airline = 'JetBlue';

    // Extract airports (mock)
    String origin = 'JFK';
    String destination = 'LAX';

    if (inputLower.contains('lax')) {
      if (inputLower.indexOf('lax') < inputLower.indexOf('jfk')) {
        origin = 'LAX';
        destination = 'JFK';
      }
    }
    if (inputLower.contains('sfo')) {
      destination = 'SFO';
    }
    if (inputLower.contains('ord')) {
      if (inputLower.contains('from')) {
        origin = 'ORD';
      } else {
        destination = 'ORD';
      }
    }

    // Extract date (mock - use recent past)
    final departureTime =
        DateTime.now().subtract(Duration(days: _random.nextInt(30)));
    final arrivalTime =
        departureTime.add(Duration(hours: 3 + _random.nextInt(3)));

    // Extract sentiment from input
    String sentiment = 'neutral';
    final List<String> tags = [];
    final List<String> highlights = [];
    final List<String> issues = [];
    int rating = 3;

    if (inputLower.contains('amazing') ||
        inputLower.contains('great') ||
        inputLower.contains('excellent')) {
      sentiment = 'positive';
      rating = 5;
      highlights.add('Exceptional service');
      tags.add('Excellent Experience');
    } else if (inputLower.contains('terrible') ||
        inputLower.contains('bad') ||
        inputLower.contains('awful')) {
      sentiment = 'negative';
      rating = 2;
      issues.add('Poor experience');
      tags.add('Needs Improvement');
    }

    if (inputLower.contains('delay')) {
      issues.add('Flight delayed');
      tags.add('Delayed');
      rating = math.max(1, rating - 1);
    }

    if (inputLower.contains('crew')) {
      if (sentiment == 'positive') {
        highlights.add('Friendly crew');
        tags.add('Great Crew');
      } else {
        issues.add('Crew issues');
      }
    }

    if (inputLower.contains('turbulence')) {
      tags.add('Turbulence');
      issues.add('Significant turbulence');
    }

    if (inputLower.contains('comfort')) {
      if (sentiment == 'positive') {
        highlights.add('Comfortable seating');
        tags.add('Comfortable');
      }
    }

    // Extract seat info (mock)
    String? seatNumber;
    String? cabinClass;

    if (inputLower.contains('first class')) {
      cabinClass = 'First Class';
      seatNumber = '${_random.nextInt(4) + 1}A';
    } else if (inputLower.contains('business')) {
      cabinClass = 'Business';
      seatNumber = '${_random.nextInt(10) + 1}A';
    } else if (inputLower.contains('middle seat')) {
      cabinClass = 'Economy';
      seatNumber = '${_random.nextInt(30) + 10}B';
      tags.add('Middle Seat');
    } else {
      cabinClass = 'Economy';
      seatNumber = '${_random.nextInt(30) + 10}${[
        'A',
        'C',
        'D',
        'F'
      ][_random.nextInt(4)]}';
    }

    // Mock aircraft type
    final aircraftTypes = [
      'Boeing 737',
      'Airbus A320',
      'Boeing 777',
      'Airbus A350'
    ];
    final aircraftType = aircraftTypes[_random.nextInt(aircraftTypes.length)];

    // Create experience
    final experience = FlightExperience(
      overallRating: rating,
      comment: input,
      tags: tags,
      categoryRatings: {
        'crew': rating,
        'comfort': rating,
        'boarding': rating,
        'entertainment': rating - 1,
      },
      sentiment: sentiment,
      highlights: highlights,
      issues: issues,
    );

    return {
      'airline': airline,
      'flightNumber':
          '${airline.substring(0, 2).toUpperCase()}${_random.nextInt(9000) + 1000}',
      'origin': origin,
      'destination': destination,
      'departureTime': departureTime,
      'arrivalTime': arrivalTime,
      'aircraftType': aircraftType,
      'seatNumber': seatNumber,
      'cabinClass': cabinClass,
      'experience': experience,
    };
  }

  void addFlight(Flight flight) {
    _flights.insert(0, flight);
    notifyListeners();
  }

  void updateFlight(Flight flight) {
    final index = _flights.indexWhere((f) => f.id == flight.id);
    if (index != -1) {
      _flights[index] = flight;
      notifyListeners();
    }
  }

  void deleteFlight(String flightId) {
    _flights.removeWhere((f) => f.id == flightId);
    notifyListeners();
  }

  Flight? getFlightById(String id) {
    try {
      return _flights.firstWhere((f) => f.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add some mock flights for demo
  void addMockFlights(String userId) {
    final mockFlights = [
      Flight(
        userId: userId,
        airline: 'Delta',
        flightNumber: 'DL1234',
        origin: 'JFK',
        destination: 'LAX',
        departureTime: DateTime.now().subtract(const Duration(days: 5)),
        arrivalTime:
            DateTime.now().subtract(const Duration(days: 5, hours: -5)),
        aircraftType: 'Boeing 737',
        seatNumber: '12A',
        cabinClass: 'Economy',
        experience: FlightExperience(
          overallRating: 4,
          comment: 'Great flight, smooth landing!',
          tags: ['On Time', 'Smooth Flight'],
          categoryRatings: {'crew': 5, 'comfort': 4, 'boarding': 4},
          sentiment: 'positive',
          highlights: ['Friendly crew', 'On-time departure'],
          issues: [],
        ),
      ),
      Flight(
        userId: userId,
        airline: 'United',
        flightNumber: 'UA5678',
        origin: 'SFO',
        destination: 'ORD',
        departureTime: DateTime.now().subtract(const Duration(days: 15)),
        arrivalTime:
            DateTime.now().subtract(const Duration(days: 15, hours: -4)),
        aircraftType: 'Airbus A320',
        seatNumber: '8C',
        cabinClass: 'Business',
        experience: FlightExperience(
          overallRating: 5,
          comment: 'Amazing business class experience!',
          tags: ['Business Class', 'Excellent Service'],
          categoryRatings: {
            'crew': 5,
            'comfort': 5,
            'boarding': 5,
            'entertainment': 5
          },
          sentiment: 'positive',
          highlights: [
            'Lie-flat seats',
            'Excellent meal service',
            'Attentive crew'
          ],
          issues: [],
        ),
      ),
    ];

    _flights.addAll(mockFlights);
    notifyListeners();
  }
}
