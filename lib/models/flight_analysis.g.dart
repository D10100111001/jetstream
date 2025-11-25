// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_analysis.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FlightCandidateImpl _$$FlightCandidateImplFromJson(
  Map<String, dynamic> json,
) => _$FlightCandidateImpl(
  date: json['date'] as String?,
  status: json['status'] as String?,
  airline: json['airline'] as String?,
  flightNumber: json['flightNumber'] as String?,
  departure: json['departure'] == null
      ? null
      : FlightEndpoint.fromJson(json['departure'] as Map<String, dynamic>),
  arrival: json['arrival'] == null
      ? null
      : FlightEndpoint.fromJson(json['arrival'] as Map<String, dynamic>),
  aircraft: json['aircraft'] as String?,
);

Map<String, dynamic> _$$FlightCandidateImplToJson(
  _$FlightCandidateImpl instance,
) => <String, dynamic>{
  'date': instance.date,
  'status': instance.status,
  'airline': instance.airline,
  'flightNumber': instance.flightNumber,
  'departure': instance.departure,
  'arrival': instance.arrival,
  'aircraft': instance.aircraft,
};

_$FlightEndpointImpl _$$FlightEndpointImplFromJson(Map<String, dynamic> json) =>
    _$FlightEndpointImpl(
      airport: json['airport'] as String?,
      iata: json['iata'] as String?,
      scheduled: json['scheduled'] as String?,
      actual: json['actual'] as String?,
    );

Map<String, dynamic> _$$FlightEndpointImplToJson(
  _$FlightEndpointImpl instance,
) => <String, dynamic>{
  'airport': instance.airport,
  'iata': instance.iata,
  'scheduled': instance.scheduled,
  'actual': instance.actual,
};
