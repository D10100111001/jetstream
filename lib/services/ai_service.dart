import 'dart:developer' as developer;

class AiService {
  // Mock implementation due to incompatible Dart SDK for firebase_ai

  Future<String> processFlightLog(String log) async {
    developer.log('Mock processing flight log: $log');
    await Future.delayed(const Duration(seconds: 1)); // Simulate delay
    
    // Return dummy JSON
    return '''
    {
      "airline": "Mock Airline",
      "flightNumber": "MK123",
      "origin": "JFK",
      "destination": "LHR",
      "date": "2023-10-27",
      "sentiment": "positive",
      "narrative": "This is a mock narrative generated because the AI service is disabled due to SDK incompatibility.",
      "tags": ["mock", "test"],
      "rating": 4.5
    }
    ''';
  }

  Future<String> generateInsights(String flightHistory) async {
    developer.log('Mock generating insights');
    await Future.delayed(const Duration(seconds: 1));
    return "These are mock insights. Fly more to see real data (once AI is enabled).";
  }
}
