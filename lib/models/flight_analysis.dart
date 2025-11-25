import 'package:freezed_annotation/freezed_annotation.dart';
import 'ai_flight_extraction.dart';

part 'flight_analysis.freezed.dart';
part 'flight_analysis.g.dart';

@freezed
class FlightCandidate with _$FlightCandidate {
  const factory FlightCandidate({
    required String? date,
    required String? status,
    required String? airline,
    required String? flightNumber,
    required FlightEndpoint? departure,
    required FlightEndpoint? arrival,
    required String? aircraft,
  }) = _FlightCandidate;

  factory FlightCandidate.fromJson(Map<String, Object?> json) =>
      _$FlightCandidateFromJson(json);
}

@freezed
class FlightEndpoint with _$FlightEndpoint {
  const factory FlightEndpoint({
    required String? airport,
    required String? iata,
    required String? scheduled,
    required String? actual,
  }) = _FlightEndpoint;

  factory FlightEndpoint.fromJson(Map<String, Object?> json) =>
      _$FlightEndpointFromJson(json);
}

class FlightLogAnalysis {
  final AIFlightExtraction extraction;
  final List<FlightCandidate> candidates;

  FlightLogAnalysis({
    required this.extraction,
    required this.candidates,
  });
}

