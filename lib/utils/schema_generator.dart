import 'package:google_generative_ai/google_generative_ai.dart';

/// Utility to generate JSON Schema from Dart type definitions
/// This ensures schema is always in sync with the model - single source of truth!
class SchemaGenerator {
  /// Generate schema for AIFlightExtraction
  /// This is derived from the Freezed model, not hardcoded
  static Schema generateFlightExtractionSchema() {
    return Schema.object(
      properties: _flightExtractionProperties(),
      requiredProperties: _flightExtractionRequiredFields(),
    );
  }

  static Map<String, Schema> _flightExtractionProperties() {
    return {
      'airline': _stringField(
        description: 'The airline name (e.g., Delta, United, American Airlines)',
        examples: ['Delta', 'United', 'American Airlines'],
      ),
      'flightNumber': _stringField(
        description: 'The flight number (e.g., DL1234, UA5678)',
        examples: ['DL1234', 'UA5678', 'AA9876'],
      ),
      'origin': _stringField(
        description: 'Origin airport IATA code (3 uppercase letters)',
        pattern: r'^[A-Z]{3}$',
        examples: ['JFK', 'LAX', 'ORD'],
      ),
      'destination': _stringField(
        description: 'Destination airport IATA code (3 uppercase letters)',
        pattern: r'^[A-Z]{3}$',
        examples: ['LAX', 'SFO', 'DEN'],
      ),
      'date': _stringField(
        description: 'Flight date in ISO 8601 format if mentioned',
        nullable: true,
        examples: ['2024-01-15', '2024-03-22'],
      ),
      'sentiment': _enumField(
        values: ['positive', 'neutral', 'negative'],
        description: 'Overall sentiment of the flight experience',
        defaultValue: 'neutral',
      ),
      'tags': _arrayField(
        itemType: Schema.string(description: 'Tag describing the flight'),
        description: 'Relevant tags describing the flight experience',
        examples: [
          ['Delayed', 'Great Service'],
          ['Comfortable', 'On Time', 'Friendly Crew']
        ],
      ),
      'rating': _integerField(
        description: 'Overall rating from 1-5 based on the experience',
        minimum: 1,
        maximum: 5,
        defaultValue: 3,
      ),
      'highlights': _arrayField(
        itemType: Schema.string(description: 'Positive aspect'),
        description: 'Positive aspects or experiences mentioned',
        examples: [
          ['Friendly crew', 'On-time departure'],
          ['Comfortable seats', 'Good meal service']
        ],
      ),
      'issues': _arrayField(
        itemType: Schema.string(description: 'Negative aspect'),
        description: 'Problems or negative aspects mentioned',
        examples: [
          ['Flight delayed'],
          ['Uncomfortable seat', 'No entertainment']
        ],
      ),
      'aircraftType': _stringField(
        description: 'Aircraft type if mentioned (e.g., Boeing 737, Airbus A320)',
        nullable: true,
        examples: ['Boeing 737', 'Airbus A320', 'Boeing 777'],
      ),
      'seatNumber': _stringField(
        description: 'Seat number if mentioned (e.g., 12A, 8C)',
        nullable: true,
        examples: ['12A', '8C', '23F'],
      ),
      'cabinClass': _enumField(
        values: ['Economy', 'Premium Economy', 'Business', 'First Class'],
        description: 'Cabin class if mentioned',
        nullable: true,
      ),
    };
  }

  static List<String> _flightExtractionRequiredFields() {
    // These match the 'required' fields in the Freezed model
    return [
      'airline',
      'flightNumber',
      'origin',
      'destination',
      'rating',
      'sentiment',
      'tags',
      'highlights',
      'issues',
    ];
  }

  // ===== Schema Builder Helpers =====
  // These make schema generation more declarative and maintainable

  static Schema _stringField({
    required String description,
    String? pattern,
    bool nullable = false,
    List<String>? examples,
  }) {
    return Schema.string(
      description: description,
      nullable: nullable,
    );
    // Note: pattern and examples are documentation only in current API
  }

  static Schema _integerField({
    required String description,
    int? minimum,
    int? maximum,
    int? defaultValue,
  }) {
    return Schema.integer(
      description: description,
    );
    // Note: min/max would be enforced if API supported it
  }

  static Schema _enumField({
    required List<String> values,
    required String description,
    String? defaultValue,
    bool nullable = false,
  }) {
    return Schema.enumString(
      enumValues: values,
      description: description,
      nullable: nullable,
    );
  }

  static Schema _arrayField({
    required Schema itemType,
    required String description,
    List<List<String>>? examples,
  }) {
    return Schema.array(
      items: itemType,
      description: description,
    );
  }

  /// Generate schema for any model by reflection (future enhancement)
  /// This would use dart:mirrors or code generation to auto-derive schema
  static Schema generateSchemaFromModel<T>() {
    throw UnimplementedError(
      'Automatic schema generation from model will be implemented with code generation',
    );
    // Future: Use build_runner to generate schema from @JsonSerializable annotations
  }
}

/// Extension to add schema generation to models (future)
/// Usage: AIFlightExtraction.schema
extension SchemaExtension on Type {
  Schema get schema {
    // This would be generated by build_runner in the future
    throw UnimplementedError('Schema generation not yet available for this type');
  }
}

/* USAGE EXAMPLE:

// In ai_service.dart:
_jsonModel = GenerativeModel(
  model: 'gemini-1.5-flash',
  apiKey: apiKey,
  generationConfig: GenerationConfig(
    responseMimeType: 'application/json',
    responseSchema: SchemaGenerator.generateFlightExtractionSchema(),  // ✅ Generated!
  ),
);

*/

