import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/ai_flight_extraction.dart';
import '../models/flight_analysis.dart';
import '../utils/schema_generator.dart';
import 'flight_search_service.dart';

class AiService {
  static const String _defaultModel = 'gemini-2.5-flash';
  final String _apiKey;
  final FlightSearchService _flightSearchService = FlightSearchService();
  
  // Initialize with API key from .env file
  AiService({String? apiKey})
      : _apiKey = apiKey ?? dotenv.env['GEMINI_API_KEY'] ?? '' {
    if (kDebugMode) {
      if (_apiKey.isEmpty || _apiKey == 'your_api_key_here') {
        print('⚠️  WARNING: Gemini API key not configured!');
        print('   Add your API key to .env file');
      } else {
        print('✅ Gemini API key configured (Model: $_defaultModel)');
      }
    }
  }

  // ===== Model Factory Methods =====

  /// Create a model for structured JSON output with custom schema
  GenerativeModel _createStructuredModel({
    required Schema schema,
    String model = _defaultModel,
  }) {
    return GenerativeModel(
      model: model,
      apiKey: _apiKey.isEmpty ? 'dummy-key-for-fallback' : _apiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: schema,
      ),
    );
  }

  /// Create a model for plain text output
  GenerativeModel _createTextModel({
    String model = _defaultModel,
    double? temperature,
    int? maxOutputTokens,
  }) {
    return GenerativeModel(
      model: model,
      apiKey: _apiKey.isEmpty ? 'dummy-key-for-fallback' : _apiKey,
      generationConfig: temperature != null || maxOutputTokens != null
          ? GenerationConfig(
              temperature: temperature,
              maxOutputTokens: maxOutputTokens,
            )
          : null,
    );
  }

  // ===== Public API Methods =====

  /// Full analysis: Extract details + Search for real candidates
  /// This is the main entry point for the UI
  Future<FlightLogAnalysis> analyzeFlightLog(String log) async {
    // 1. Extract intent and details from text (Subjective + Objective)
    final extraction = await extractFlightDetails(log);

    // 2. Search for real flights based on extraction
    // We use the extracted data as search parameters
    if (kDebugMode) print('🔎 AI Service: Searching for candidates based on extraction...');
    
    // Clean up flight number for search (remove airline code if present and duplicated)
    String? searchFlightNum = extraction.flightNumber;
    
    // Default to today if no date provided
    String searchDate = extraction.date ?? DateTime.now().toString().substring(0, 10);
    
    final candidatesData = await _flightSearchService.searchFlights(
      flightNumber: searchFlightNum,
      airlineName: extraction.airline,
      originIata: extraction.origin == 'XXX' ? null : extraction.origin,
      destinationIata: extraction.destination == 'YYY' ? null : extraction.destination,
      date: searchDate,
    );

    // 3. Convert raw maps to typed candidates
    final candidates = candidatesData.map((data) {
      return FlightCandidate(
        date: data['date'],
        status: data['status'],
        airline: data['airline'],
        flightNumber: data['flight_number'],
        aircraft: data['aircraft'],
        departure: data['departure'] != null ? FlightEndpoint(
          airport: data['departure']['airport'],
          iata: data['departure']['iata'],
          scheduled: data['departure']['scheduled'],
          actual: data['departure']['actual'],
        ) : null,
        arrival: data['arrival'] != null ? FlightEndpoint(
          airport: data['arrival']['airport'],
          iata: data['arrival']['iata'],
          scheduled: data['arrival']['scheduled'],
          actual: data['arrival']['actual'],
        ) : null,
      );
    }).toList();

    if (kDebugMode) print('✅ AI Service: Found ${candidates.length} candidates');

    return FlightLogAnalysis(
      extraction: extraction,
      candidates: candidates,
    );
  }

  /// Process natural language flight log (Direct Extraction)
  /// Returns extracted data without verifying against real API
  Future<AIFlightExtraction> extractFlightDetails(String log) async {
    if (kDebugMode) {
      print('🤖 AI Processing (Direct Mode): Flight Log');
    }

    // Create model specifically for flight extraction with structured output
    final model = _createStructuredModel(
      schema: SchemaGenerator.generateFlightExtractionSchema(),
      model: _defaultModel, // Using latest efficient model
    );

    try {
      final today = DateTime.now();
      final prompt = '''
Extract flight information from this natural language description.

Context:
- Today's date and time is: ${today.toIso8601String().split('T')[0]} (${today.weekday})
- Interpret "yesterday", "tomorrow", etc. relative to this date.

User description: "$log"

Instructions:
- Extract airline name (full name, e.g., "Delta Air Lines" -> "Delta")
- Generate flight number if not mentioned (format: 2-letter airline code + 4 digits)
- Extract airport codes (must be 3-letter IATA codes like JFK, LAX)
- Determine sentiment based on tone and content
- Rate overall experience from 1-5
- Extract specific highlights (positive aspects)
- Extract specific issues (problems or complaints)
- List relevant tags to categorize the experience
- Extract aircraft type, seat number, and cabin class if mentioned
''';

      if (kDebugMode) print('🚀 Sending request to Gemini...');
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      if (kDebugMode) print('✅ Response received from Gemini');
      
      if (response.text == null || response.text!.isEmpty) {
        throw Exception('Empty response from AI');
      }
      
      if (kDebugMode) {
        print('📦 Raw JSON response:');
        print(response.text);
      }

      // Parse JSON response into type-safe model
      final json = jsonDecode(response.text!) as Map<String, dynamic>;
      final result = AIFlightExtraction.fromJson(json);
      
      if (kDebugMode) print('✨ Parsed successfully: ${result.airline} ${result.flightNumber}');
      return result;
      
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ Error processing flight log with AI: $e');
        print('Stack trace: $stackTrace');
        print('⚠️ Falling back to simple extraction');
      }
      
      // Fallback: Return basic extracted data using simple parsing
      return _fallbackExtraction(log);
    }
  }

  // Legacy alias for backward compatibility until refactor complete
  Future<AIFlightExtraction> processFlightLog(String log) => extractFlightDetails(log);

  /// Generate personalized insights based on flight history
  /// Returns plain text (no structured output needed)
  /// 
  /// Model: gemini-2.5-flash with text output, creative temperature
  Future<String> generateInsights(List<Map<String, dynamic>> flights) async {
    if (kDebugMode) print('🤖 Generating insights for ${flights.length} flights...');

    if (flights.isEmpty) {
      return "Log your first flight to start getting personalized insights!";
    }

    // Create model for creative text generation
    final model = _createTextModel(
      model: _defaultModel,
      temperature: 0.7, // More creative for insights
    );
    
    try {
      final flightSummary = flights.map((f) => 
        '${f['airline']} ${f['flightNumber']}: ${f['origin']} → ${f['destination']} (Rating: ${f['rating'] ?? 'N/A'})'
      ).join('\n');
      
      final prompt = '''
You are a travel insights AI assistant. Based on the following flight history, provide personalized insights, patterns, and recommendations.

Flight History:
$flightSummary

Provide insights about:
1. Travel patterns (favorite routes, airlines, destinations)
2. Experience trends (are flights getting better or worse?)
3. Recommendations for future travel
4. Any notable patterns or statistics

Keep the response concise, friendly, and actionable (max 200 words).
''';

      if (kDebugMode) print('🚀 Sending insights request to Gemini...');
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      if (kDebugMode) print('✅ Insights response received');
      
      return response.text ?? "Unable to generate insights at this time.";
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ Error generating insights: $e');
        print('Stack trace: $stackTrace');
      }
      return _generateBasicInsights(flights);
    }
  }

  /// Generate a narrative summary of a flight experience
  /// Returns plain text (no structured output needed)
  /// 
  /// Model: gemini-2.5-flash with text output, higher temperature for creativity
  Future<String> generateFlightNarrative(Map<String, dynamic> flightData) async {
    // Create model for creative narrative generation
    final model = _createTextModel(
      model: _defaultModel,
      temperature: 0.8, // More creative for narrative
      maxOutputTokens: 150, // Short narrative
    );

    try {
      final prompt = '''
Create a brief, engaging narrative summary (2-3 sentences) of this flight experience:

Airline: ${flightData['airline']}
Route: ${flightData['origin']} to ${flightData['destination']}
Rating: ${flightData['rating']}/5
Highlights: ${flightData['highlights']?.join(', ') ?? 'None'}
Issues: ${flightData['issues']?.join(', ') ?? 'None'}
User comment: ${flightData['comment'] ?? 'No comment'}

Make it personal and conversational.
''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      
      return response.text ?? "Had a flight on ${flightData['airline']}.";
    } catch (e) {
      if (kDebugMode) {
        print('Error generating narrative: $e');
      }
      return "Flew ${flightData['airline']} from ${flightData['origin']} to ${flightData['destination']}.";
    }
  }

  // ===== Helper Methods =====

  // Fallback extraction when AI is unavailable
  // Returns type-safe AIFlightExtraction
  AIFlightExtraction _fallbackExtraction(String log) {
    final logLower = log.toLowerCase();
    
    // Simple airline detection
    final airlines = {
      'delta': 'Delta',
      'united': 'United',
      'american': 'American Airlines',
      'southwest': 'Southwest',
      'jetblue': 'JetBlue',
      'alaska': 'Alaska',
      'spirit': 'Spirit',
      'frontier': 'Frontier',
    };
    
    String airline = 'Unknown Airline';
    for (final entry in airlines.entries) {
      if (logLower.contains(entry.key)) {
        airline = entry.value;
        break;
      }
    }
    
    // Simple airport code extraction (3 uppercase letters)
    final airportRegex = RegExp(r'\b[A-Z]{3}\b');
    final airports = airportRegex.allMatches(log).map((m) => m.group(0)!).toList();
    
    final origin = airports.isNotEmpty ? airports.first : 'XXX';
    final destination = airports.length > 1 ? airports[1] : 'YYY';
    
    // Sentiment analysis
    final positiveWords = ['great', 'excellent', 'amazing', 'wonderful', 'good', 'comfortable', 'friendly'];
    final negativeWords = ['terrible', 'bad', 'awful', 'delayed', 'poor', 'uncomfortable', 'rude'];
    
    String sentiment = 'neutral';
    int rating = 3;
    final List<String> highlights = [];
    final List<String> issues = [];
    final List<String> tags = [];
    
    // Analyze sentiment
    final hasPositive = positiveWords.any((word) => logLower.contains(word));
    final hasNegative = negativeWords.any((word) => logLower.contains(word));
    
    if (hasPositive && !hasNegative) {
      sentiment = 'positive';
      rating = 4;
      highlights.add('Pleasant experience');
      tags.add('Good Experience');
    } else if (hasNegative && !hasPositive) {
      sentiment = 'negative';
      rating = 2;
      issues.add('Had some issues');
      tags.add('Needs Improvement');
    } else {
      tags.add('Standard Flight');
    }
    
    // Check for specific mentions
    if (logLower.contains('delay')) {
      issues.add('Flight delayed');
      tags.add('Delayed');
      rating = rating > 1 ? rating - 1 : 1;
    }
    
    if (logLower.contains('crew') && sentiment == 'positive') {
      highlights.add('Friendly crew');
      tags.add('Great Crew');
    }
    
    // Extract cabin class
    String? cabinClass;
    if (logLower.contains('first class')) {
      cabinClass = 'First Class';
    } else if (logLower.contains('business')) {
      cabinClass = 'Business';
    } else if (logLower.contains('premium economy')) {
      cabinClass = 'Premium Economy';
    } else if (logLower.contains('economy')) {
      cabinClass = 'Economy';
    }
    
    return AIFlightExtraction(
      airline: airline,
      flightNumber: '${airline.substring(0, 2).toUpperCase()}000',
      origin: origin,
      destination: destination,
      date: DateTime.now().toIso8601String(),
      sentiment: sentiment,
      rating: rating,
      tags: tags,
      highlights: highlights,
      issues: issues,
      cabinClass: cabinClass,
    );
  }

  String _generateBasicInsights(List<Map<String, dynamic>> flights) {
    final totalFlights = flights.length;
    final ratingsWithValues = flights.where((f) => f['rating'] != null).toList();
    
    if (ratingsWithValues.isEmpty) {
      return '''
You've logged $totalFlights flight${totalFlights > 1 ? 's' : ''}!

Keep logging flights with ratings to get personalized insights and travel recommendations!
''';
    }
    
    final avgRating = ratingsWithValues
        .map((f) => (f['rating'] as num).toDouble())
        .fold(0.0, (a, b) => a + b) / ratingsWithValues.length;
    
    return '''
You've logged $totalFlights flight${totalFlights > 1 ? 's' : ''} with an average rating of ${avgRating.toStringAsFixed(1)}/5.

${avgRating >= 4 ? "Your travel experiences have been mostly positive!" : avgRating >= 3 ? "Your flights have been fairly standard." : "There's room for improvement in your travel experiences."}

Keep logging flights to get more detailed insights and travel recommendations!
''';
  }
}
