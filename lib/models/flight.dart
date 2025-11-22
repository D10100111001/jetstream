import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class Flight {
  final String id;
  final String userId;
  final String airline;
  final String flightNumber;
  final String origin;
  final String destination;
  final DateTime departureTime;
  final DateTime? arrivalTime;
  final String? aircraftType;
  final String? seatNumber;
  final String? cabinClass;
  final FlightExperience? experience;
  final DateTime createdAt;
  final DateTime updatedAt;

  Flight({
    String? id,
    required this.userId,
    required this.airline,
    required this.flightNumber,
    required this.origin,
    required this.destination,
    required this.departureTime,
    this.arrivalTime,
    this.aircraftType,
    this.seatNumber,
    this.cabinClass,
    this.experience,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : id = id ?? _uuid.v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Flight copyWith({
    String? userId,
    String? airline,
    String? flightNumber,
    String? origin,
    String? destination,
    DateTime? departureTime,
    DateTime? arrivalTime,
    String? aircraftType,
    String? seatNumber,
    String? cabinClass,
    FlightExperience? experience,
    DateTime? updatedAt,
  }) {
    return Flight(
      id: id,
      userId: userId ?? this.userId,
      airline: airline ?? this.airline,
      flightNumber: flightNumber ?? this.flightNumber,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      departureTime: departureTime ?? this.departureTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      aircraftType: aircraftType ?? this.aircraftType,
      seatNumber: seatNumber ?? this.seatNumber,
      cabinClass: cabinClass ?? this.cabinClass,
      experience: experience ?? this.experience,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'airline': airline,
      'flightNumber': flightNumber,
      'origin': origin,
      'destination': destination,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime?.toIso8601String(),
      'aircraftType': aircraftType,
      'seatNumber': seatNumber,
      'cabinClass': cabinClass,
      'experience': experience?.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      id: json['id'] as String,
      userId: json['userId'] as String,
      airline: json['airline'] as String,
      flightNumber: json['flightNumber'] as String,
      origin: json['origin'] as String,
      destination: json['destination'] as String,
      departureTime: DateTime.parse(json['departureTime'] as String),
      arrivalTime: json['arrivalTime'] != null
          ? DateTime.parse(json['arrivalTime'] as String)
          : null,
      aircraftType: json['aircraftType'] as String?,
      seatNumber: json['seatNumber'] as String?,
      cabinClass: json['cabinClass'] as String?,
      experience: json['experience'] != null
          ? FlightExperience.fromJson(
              json['experience'] as Map<String, dynamic>)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

class FlightExperience {
  final int overallRating; // 1-5
  final String? comment;
  final List<String> tags; // AI-generated tags
  final Map<String, int>
      categoryRatings; // e.g., {'crew': 5, 'boarding': 3, 'comfort': 4}
  final String? sentiment; // 'positive', 'neutral', 'negative'
  final List<String> highlights; // AI-extracted highlights
  final List<String> issues; // AI-extracted issues

  FlightExperience({
    required this.overallRating,
    this.comment,
    this.tags = const [],
    this.categoryRatings = const {},
    this.sentiment,
    this.highlights = const [],
    this.issues = const [],
  });

  FlightExperience copyWith({
    int? overallRating,
    String? comment,
    List<String>? tags,
    Map<String, int>? categoryRatings,
    String? sentiment,
    List<String>? highlights,
    List<String>? issues,
  }) {
    return FlightExperience(
      overallRating: overallRating ?? this.overallRating,
      comment: comment ?? this.comment,
      tags: tags ?? this.tags,
      categoryRatings: categoryRatings ?? this.categoryRatings,
      sentiment: sentiment ?? this.sentiment,
      highlights: highlights ?? this.highlights,
      issues: issues ?? this.issues,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overallRating': overallRating,
      'comment': comment,
      'tags': tags,
      'categoryRatings': categoryRatings,
      'sentiment': sentiment,
      'highlights': highlights,
      'issues': issues,
    };
  }

  factory FlightExperience.fromJson(Map<String, dynamic> json) {
    return FlightExperience(
      overallRating: json['overallRating'] as int,
      comment: json['comment'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      categoryRatings: (json['categoryRatings'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value as int)) ??
          {},
      sentiment: json['sentiment'] as String?,
      highlights: (json['highlights'] as List<dynamic>?)?.cast<String>() ?? [],
      issues: (json['issues'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}

class UserStats {
  final int totalFlights;
  final int totalMiles;
  final int totalHours;
  final Map<String, int> airlineBreakdown;
  final Map<String, int> aircraftBreakdown;
  final String? favoriteAirline;
  final String? favoriteAircraft;
  final double averageRating;

  UserStats({
    this.totalFlights = 0,
    this.totalMiles = 0,
    this.totalHours = 0,
    this.airlineBreakdown = const {},
    this.aircraftBreakdown = const {},
    this.favoriteAirline,
    this.favoriteAircraft,
    this.averageRating = 0.0,
  });

  UserStats copyWith({
    int? totalFlights,
    int? totalMiles,
    int? totalHours,
    Map<String, int>? airlineBreakdown,
    Map<String, int>? aircraftBreakdown,
    String? favoriteAirline,
    String? favoriteAircraft,
    double? averageRating,
  }) {
    return UserStats(
      totalFlights: totalFlights ?? this.totalFlights,
      totalMiles: totalMiles ?? this.totalMiles,
      totalHours: totalHours ?? this.totalHours,
      airlineBreakdown: airlineBreakdown ?? this.airlineBreakdown,
      aircraftBreakdown: aircraftBreakdown ?? this.aircraftBreakdown,
      favoriteAirline: favoriteAirline ?? this.favoriteAirline,
      favoriteAircraft: favoriteAircraft ?? this.favoriteAircraft,
      averageRating: averageRating ?? this.averageRating,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalFlights': totalFlights,
      'totalMiles': totalMiles,
      'totalHours': totalHours,
      'airlineBreakdown': airlineBreakdown,
      'aircraftBreakdown': aircraftBreakdown,
      'favoriteAirline': favoriteAirline,
      'favoriteAircraft': favoriteAircraft,
      'averageRating': averageRating,
    };
  }

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalFlights: json['totalFlights'] as int? ?? 0,
      totalMiles: json['totalMiles'] as int? ?? 0,
      totalHours: json['totalHours'] as int? ?? 0,
      airlineBreakdown: (json['airlineBreakdown'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value as int)) ??
          {},
      aircraftBreakdown: (json['aircraftBreakdown'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value as int)) ??
          {},
      favoriteAirline: json['favoriteAirline'] as String?,
      favoriteAircraft: json['favoriteAircraft'] as String?,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
