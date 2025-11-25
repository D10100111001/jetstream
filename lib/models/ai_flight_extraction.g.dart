// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_flight_extraction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AIFlightExtractionImpl _$$AIFlightExtractionImplFromJson(
  Map<String, dynamic> json,
) => _$AIFlightExtractionImpl(
  airline: json['airline'] as String,
  flightNumber: json['flightNumber'] as String,
  origin: json['origin'] as String,
  destination: json['destination'] as String,
  date: json['date'] as String?,
  sentiment: json['sentiment'] as String? ?? 'neutral',
  tags:
      (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  rating: (json['rating'] as num?)?.toInt() ?? 3,
  highlights:
      (json['highlights'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  issues:
      (json['issues'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  aircraftType: json['aircraftType'] as String?,
  seatNumber: json['seatNumber'] as String?,
  cabinClass: json['cabinClass'] as String?,
);

Map<String, dynamic> _$$AIFlightExtractionImplToJson(
  _$AIFlightExtractionImpl instance,
) => <String, dynamic>{
  'airline': instance.airline,
  'flightNumber': instance.flightNumber,
  'origin': instance.origin,
  'destination': instance.destination,
  'date': instance.date,
  'sentiment': instance.sentiment,
  'tags': instance.tags,
  'rating': instance.rating,
  'highlights': instance.highlights,
  'issues': instance.issues,
  'aircraftType': instance.aircraftType,
  'seatNumber': instance.seatNumber,
  'cabinClass': instance.cabinClass,
};
