import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_flight_extraction.freezed.dart';
part 'ai_flight_extraction.g.dart';

/// Structured output from AI flight extraction
/// 
/// This model serves as the **single source of truth** for both:
/// 1. Dart type system (via Freezed)
/// 2. JSON Schema for Gemini AI (generated in SchemaGenerator)
/// 
/// When you add/modify fields here, the schema is automatically kept in sync
/// via the SchemaGenerator utility.
@freezed
class AIFlightExtraction with _$AIFlightExtraction {
  const factory AIFlightExtraction({
    /// Airline name (e.g., "Delta", "United", "American Airlines")
    /// Schema: string, required
    required String airline,

    /// Flight number (e.g., "DL1234", "UA5678")
    /// Schema: string, required
    required String flightNumber,

    /// Origin airport IATA code (3 letters, e.g., "JFK", "LAX")
    /// Schema: string, required, pattern: ^[A-Z]{3}$
    required String origin,

    /// Destination airport IATA code (3 letters, e.g., "LAX", "SFO")
    /// Schema: string, required, pattern: ^[A-Z]{3}$
    required String destination,

    /// Flight date in ISO 8601 format (e.g., "2024-01-15")
    /// Schema: string, nullable
    String? date,

    /// Overall sentiment: "positive", "neutral", or "negative"
    /// Schema: enum, required, default: "neutral"
    @Default('neutral') String sentiment,

    /// Descriptive tags (e.g., ["Delayed", "Great Service", "Comfortable"])
    /// Schema: array of strings, required, default: []
    @Default([]) List<String> tags,

    /// Overall rating from 1-5
    /// Schema: integer, required, min: 1, max: 5, default: 3
    @Default(3) int rating,

    /// Positive aspects mentioned (e.g., ["Friendly crew", "On-time departure"])
    /// Schema: array of strings, required, default: []
    @Default([]) List<String> highlights,

    /// Negative aspects or problems (e.g., ["Flight delayed", "Uncomfortable seat"])
    /// Schema: array of strings, required, default: []
    @Default([]) List<String> issues,

    /// Aircraft type if mentioned (e.g., "Boeing 737", "Airbus A320")
    /// Schema: string, nullable
    String? aircraftType,

    /// Seat number if mentioned (e.g., "12A", "8C")
    /// Schema: string, nullable
    String? seatNumber,

    /// Cabin class: "Economy", "Premium Economy", "Business", or "First Class"
    /// Schema: enum, nullable
    String? cabinClass,
  }) = _AIFlightExtraction;

  factory AIFlightExtraction.fromJson(Map<String, dynamic> json) =>
      _$AIFlightExtractionFromJson(json);
}

/// JSON Schema for Gemini structured output
class AIFlightExtractionSchema {
  static Map<String, dynamic> get schema => {
        'type': 'object',
        'properties': {
          'airline': {
            'type': 'string',
            'description': 'The airline name (e.g., Delta, United, American Airlines)',
          },
          'flightNumber': {
            'type': 'string',
            'description': 'The flight number (e.g., DL1234)',
          },
          'origin': {
            'type': 'string',
            'description': 'Origin airport code (3-letter IATA code, e.g., JFK)',
            'pattern': r'^[A-Z]{3}$',
          },
          'destination': {
            'type': 'string',
            'description': 'Destination airport code (3-letter IATA code, e.g., LAX)',
            'pattern': r'^[A-Z]{3}$',
          },
          'date': {
            'type': 'string',
            'description': 'Flight date in ISO 8601 format (e.g., 2024-01-15)',
            'format': 'date',
          },
          'sentiment': {
            'type': 'string',
            'description': 'Overall sentiment of the flight experience',
            'enum': ['positive', 'neutral', 'negative'],
          },
          'tags': {
            'type': 'array',
            'description': 'Relevant tags describing the flight',
            'items': {'type': 'string'},
            'examples': [
              ['Delayed', 'Great Service'],
              ['Comfortable', 'On Time']
            ],
          },
          'rating': {
            'type': 'integer',
            'description': 'Overall rating from 1-5',
            'minimum': 1,
            'maximum': 5,
          },
          'highlights': {
            'type': 'array',
            'description': 'Positive aspects mentioned in the description',
            'items': {'type': 'string'},
          },
          'issues': {
            'type': 'array',
            'description': 'Negative aspects or problems mentioned',
            'items': {'type': 'string'},
          },
          'aircraftType': {
            'type': 'string',
            'description': 'Aircraft type if mentioned (e.g., Boeing 737, Airbus A320)',
          },
          'seatNumber': {
            'type': 'string',
            'description': 'Seat number if mentioned (e.g., 12A, 8C)',
          },
          'cabinClass': {
            'type': 'string',
            'description': 'Cabin class if mentioned',
            'enum': ['Economy', 'Premium Economy', 'Business', 'First Class'],
          },
        },
        'required': ['airline', 'flightNumber', 'origin', 'destination', 'rating'],
      };
}

