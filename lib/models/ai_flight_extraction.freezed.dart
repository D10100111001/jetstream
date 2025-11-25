// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_flight_extraction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AIFlightExtraction _$AIFlightExtractionFromJson(Map<String, dynamic> json) {
  return _AIFlightExtraction.fromJson(json);
}

/// @nodoc
mixin _$AIFlightExtraction {
  /// Airline name (e.g., "Delta", "United", "American Airlines")
  /// Schema: string, required
  String get airline => throw _privateConstructorUsedError;

  /// Flight number (e.g., "DL1234", "UA5678")
  /// Schema: string, required
  String get flightNumber => throw _privateConstructorUsedError;

  /// Origin airport IATA code (3 letters, e.g., "JFK", "LAX")
  /// Schema: string, required, pattern: ^[A-Z]{3}$
  String get origin => throw _privateConstructorUsedError;

  /// Destination airport IATA code (3 letters, e.g., "LAX", "SFO")
  /// Schema: string, required, pattern: ^[A-Z]{3}$
  String get destination => throw _privateConstructorUsedError;

  /// Flight date in ISO 8601 format (e.g., "2024-01-15")
  /// Schema: string, nullable
  String? get date => throw _privateConstructorUsedError;

  /// Overall sentiment: "positive", "neutral", or "negative"
  /// Schema: enum, required, default: "neutral"
  String get sentiment => throw _privateConstructorUsedError;

  /// Descriptive tags (e.g., ["Delayed", "Great Service", "Comfortable"])
  /// Schema: array of strings, required, default: []
  List<String> get tags => throw _privateConstructorUsedError;

  /// Overall rating from 1-5
  /// Schema: integer, required, min: 1, max: 5, default: 3
  int get rating => throw _privateConstructorUsedError;

  /// Positive aspects mentioned (e.g., ["Friendly crew", "On-time departure"])
  /// Schema: array of strings, required, default: []
  List<String> get highlights => throw _privateConstructorUsedError;

  /// Negative aspects or problems (e.g., ["Flight delayed", "Uncomfortable seat"])
  /// Schema: array of strings, required, default: []
  List<String> get issues => throw _privateConstructorUsedError;

  /// Aircraft type if mentioned (e.g., "Boeing 737", "Airbus A320")
  /// Schema: string, nullable
  String? get aircraftType => throw _privateConstructorUsedError;

  /// Seat number if mentioned (e.g., "12A", "8C")
  /// Schema: string, nullable
  String? get seatNumber => throw _privateConstructorUsedError;

  /// Cabin class: "Economy", "Premium Economy", "Business", or "First Class"
  /// Schema: enum, nullable
  String? get cabinClass => throw _privateConstructorUsedError;

  /// Serializes this AIFlightExtraction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIFlightExtraction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIFlightExtractionCopyWith<AIFlightExtraction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIFlightExtractionCopyWith<$Res> {
  factory $AIFlightExtractionCopyWith(
    AIFlightExtraction value,
    $Res Function(AIFlightExtraction) then,
  ) = _$AIFlightExtractionCopyWithImpl<$Res, AIFlightExtraction>;
  @useResult
  $Res call({
    String airline,
    String flightNumber,
    String origin,
    String destination,
    String? date,
    String sentiment,
    List<String> tags,
    int rating,
    List<String> highlights,
    List<String> issues,
    String? aircraftType,
    String? seatNumber,
    String? cabinClass,
  });
}

/// @nodoc
class _$AIFlightExtractionCopyWithImpl<$Res, $Val extends AIFlightExtraction>
    implements $AIFlightExtractionCopyWith<$Res> {
  _$AIFlightExtractionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIFlightExtraction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? airline = null,
    Object? flightNumber = null,
    Object? origin = null,
    Object? destination = null,
    Object? date = freezed,
    Object? sentiment = null,
    Object? tags = null,
    Object? rating = null,
    Object? highlights = null,
    Object? issues = null,
    Object? aircraftType = freezed,
    Object? seatNumber = freezed,
    Object? cabinClass = freezed,
  }) {
    return _then(
      _value.copyWith(
            airline: null == airline
                ? _value.airline
                : airline // ignore: cast_nullable_to_non_nullable
                      as String,
            flightNumber: null == flightNumber
                ? _value.flightNumber
                : flightNumber // ignore: cast_nullable_to_non_nullable
                      as String,
            origin: null == origin
                ? _value.origin
                : origin // ignore: cast_nullable_to_non_nullable
                      as String,
            destination: null == destination
                ? _value.destination
                : destination // ignore: cast_nullable_to_non_nullable
                      as String,
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String?,
            sentiment: null == sentiment
                ? _value.sentiment
                : sentiment // ignore: cast_nullable_to_non_nullable
                      as String,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as int,
            highlights: null == highlights
                ? _value.highlights
                : highlights // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            issues: null == issues
                ? _value.issues
                : issues // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            aircraftType: freezed == aircraftType
                ? _value.aircraftType
                : aircraftType // ignore: cast_nullable_to_non_nullable
                      as String?,
            seatNumber: freezed == seatNumber
                ? _value.seatNumber
                : seatNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            cabinClass: freezed == cabinClass
                ? _value.cabinClass
                : cabinClass // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AIFlightExtractionImplCopyWith<$Res>
    implements $AIFlightExtractionCopyWith<$Res> {
  factory _$$AIFlightExtractionImplCopyWith(
    _$AIFlightExtractionImpl value,
    $Res Function(_$AIFlightExtractionImpl) then,
  ) = __$$AIFlightExtractionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String airline,
    String flightNumber,
    String origin,
    String destination,
    String? date,
    String sentiment,
    List<String> tags,
    int rating,
    List<String> highlights,
    List<String> issues,
    String? aircraftType,
    String? seatNumber,
    String? cabinClass,
  });
}

/// @nodoc
class __$$AIFlightExtractionImplCopyWithImpl<$Res>
    extends _$AIFlightExtractionCopyWithImpl<$Res, _$AIFlightExtractionImpl>
    implements _$$AIFlightExtractionImplCopyWith<$Res> {
  __$$AIFlightExtractionImplCopyWithImpl(
    _$AIFlightExtractionImpl _value,
    $Res Function(_$AIFlightExtractionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AIFlightExtraction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? airline = null,
    Object? flightNumber = null,
    Object? origin = null,
    Object? destination = null,
    Object? date = freezed,
    Object? sentiment = null,
    Object? tags = null,
    Object? rating = null,
    Object? highlights = null,
    Object? issues = null,
    Object? aircraftType = freezed,
    Object? seatNumber = freezed,
    Object? cabinClass = freezed,
  }) {
    return _then(
      _$AIFlightExtractionImpl(
        airline: null == airline
            ? _value.airline
            : airline // ignore: cast_nullable_to_non_nullable
                  as String,
        flightNumber: null == flightNumber
            ? _value.flightNumber
            : flightNumber // ignore: cast_nullable_to_non_nullable
                  as String,
        origin: null == origin
            ? _value.origin
            : origin // ignore: cast_nullable_to_non_nullable
                  as String,
        destination: null == destination
            ? _value.destination
            : destination // ignore: cast_nullable_to_non_nullable
                  as String,
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String?,
        sentiment: null == sentiment
            ? _value.sentiment
            : sentiment // ignore: cast_nullable_to_non_nullable
                  as String,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as int,
        highlights: null == highlights
            ? _value._highlights
            : highlights // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        issues: null == issues
            ? _value._issues
            : issues // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        aircraftType: freezed == aircraftType
            ? _value.aircraftType
            : aircraftType // ignore: cast_nullable_to_non_nullable
                  as String?,
        seatNumber: freezed == seatNumber
            ? _value.seatNumber
            : seatNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        cabinClass: freezed == cabinClass
            ? _value.cabinClass
            : cabinClass // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AIFlightExtractionImpl implements _AIFlightExtraction {
  const _$AIFlightExtractionImpl({
    required this.airline,
    required this.flightNumber,
    required this.origin,
    required this.destination,
    this.date,
    this.sentiment = 'neutral',
    final List<String> tags = const [],
    this.rating = 3,
    final List<String> highlights = const [],
    final List<String> issues = const [],
    this.aircraftType,
    this.seatNumber,
    this.cabinClass,
  }) : _tags = tags,
       _highlights = highlights,
       _issues = issues;

  factory _$AIFlightExtractionImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIFlightExtractionImplFromJson(json);

  /// Airline name (e.g., "Delta", "United", "American Airlines")
  /// Schema: string, required
  @override
  final String airline;

  /// Flight number (e.g., "DL1234", "UA5678")
  /// Schema: string, required
  @override
  final String flightNumber;

  /// Origin airport IATA code (3 letters, e.g., "JFK", "LAX")
  /// Schema: string, required, pattern: ^[A-Z]{3}$
  @override
  final String origin;

  /// Destination airport IATA code (3 letters, e.g., "LAX", "SFO")
  /// Schema: string, required, pattern: ^[A-Z]{3}$
  @override
  final String destination;

  /// Flight date in ISO 8601 format (e.g., "2024-01-15")
  /// Schema: string, nullable
  @override
  final String? date;

  /// Overall sentiment: "positive", "neutral", or "negative"
  /// Schema: enum, required, default: "neutral"
  @override
  @JsonKey()
  final String sentiment;

  /// Descriptive tags (e.g., ["Delayed", "Great Service", "Comfortable"])
  /// Schema: array of strings, required, default: []
  final List<String> _tags;

  /// Descriptive tags (e.g., ["Delayed", "Great Service", "Comfortable"])
  /// Schema: array of strings, required, default: []
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  /// Overall rating from 1-5
  /// Schema: integer, required, min: 1, max: 5, default: 3
  @override
  @JsonKey()
  final int rating;

  /// Positive aspects mentioned (e.g., ["Friendly crew", "On-time departure"])
  /// Schema: array of strings, required, default: []
  final List<String> _highlights;

  /// Positive aspects mentioned (e.g., ["Friendly crew", "On-time departure"])
  /// Schema: array of strings, required, default: []
  @override
  @JsonKey()
  List<String> get highlights {
    if (_highlights is EqualUnmodifiableListView) return _highlights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_highlights);
  }

  /// Negative aspects or problems (e.g., ["Flight delayed", "Uncomfortable seat"])
  /// Schema: array of strings, required, default: []
  final List<String> _issues;

  /// Negative aspects or problems (e.g., ["Flight delayed", "Uncomfortable seat"])
  /// Schema: array of strings, required, default: []
  @override
  @JsonKey()
  List<String> get issues {
    if (_issues is EqualUnmodifiableListView) return _issues;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_issues);
  }

  /// Aircraft type if mentioned (e.g., "Boeing 737", "Airbus A320")
  /// Schema: string, nullable
  @override
  final String? aircraftType;

  /// Seat number if mentioned (e.g., "12A", "8C")
  /// Schema: string, nullable
  @override
  final String? seatNumber;

  /// Cabin class: "Economy", "Premium Economy", "Business", or "First Class"
  /// Schema: enum, nullable
  @override
  final String? cabinClass;

  @override
  String toString() {
    return 'AIFlightExtraction(airline: $airline, flightNumber: $flightNumber, origin: $origin, destination: $destination, date: $date, sentiment: $sentiment, tags: $tags, rating: $rating, highlights: $highlights, issues: $issues, aircraftType: $aircraftType, seatNumber: $seatNumber, cabinClass: $cabinClass)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIFlightExtractionImpl &&
            (identical(other.airline, airline) || other.airline == airline) &&
            (identical(other.flightNumber, flightNumber) ||
                other.flightNumber == flightNumber) &&
            (identical(other.origin, origin) || other.origin == origin) &&
            (identical(other.destination, destination) ||
                other.destination == destination) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.sentiment, sentiment) ||
                other.sentiment == sentiment) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            const DeepCollectionEquality().equals(
              other._highlights,
              _highlights,
            ) &&
            const DeepCollectionEquality().equals(other._issues, _issues) &&
            (identical(other.aircraftType, aircraftType) ||
                other.aircraftType == aircraftType) &&
            (identical(other.seatNumber, seatNumber) ||
                other.seatNumber == seatNumber) &&
            (identical(other.cabinClass, cabinClass) ||
                other.cabinClass == cabinClass));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    airline,
    flightNumber,
    origin,
    destination,
    date,
    sentiment,
    const DeepCollectionEquality().hash(_tags),
    rating,
    const DeepCollectionEquality().hash(_highlights),
    const DeepCollectionEquality().hash(_issues),
    aircraftType,
    seatNumber,
    cabinClass,
  );

  /// Create a copy of AIFlightExtraction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIFlightExtractionImplCopyWith<_$AIFlightExtractionImpl> get copyWith =>
      __$$AIFlightExtractionImplCopyWithImpl<_$AIFlightExtractionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AIFlightExtractionImplToJson(this);
  }
}

abstract class _AIFlightExtraction implements AIFlightExtraction {
  const factory _AIFlightExtraction({
    required final String airline,
    required final String flightNumber,
    required final String origin,
    required final String destination,
    final String? date,
    final String sentiment,
    final List<String> tags,
    final int rating,
    final List<String> highlights,
    final List<String> issues,
    final String? aircraftType,
    final String? seatNumber,
    final String? cabinClass,
  }) = _$AIFlightExtractionImpl;

  factory _AIFlightExtraction.fromJson(Map<String, dynamic> json) =
      _$AIFlightExtractionImpl.fromJson;

  /// Airline name (e.g., "Delta", "United", "American Airlines")
  /// Schema: string, required
  @override
  String get airline;

  /// Flight number (e.g., "DL1234", "UA5678")
  /// Schema: string, required
  @override
  String get flightNumber;

  /// Origin airport IATA code (3 letters, e.g., "JFK", "LAX")
  /// Schema: string, required, pattern: ^[A-Z]{3}$
  @override
  String get origin;

  /// Destination airport IATA code (3 letters, e.g., "LAX", "SFO")
  /// Schema: string, required, pattern: ^[A-Z]{3}$
  @override
  String get destination;

  /// Flight date in ISO 8601 format (e.g., "2024-01-15")
  /// Schema: string, nullable
  @override
  String? get date;

  /// Overall sentiment: "positive", "neutral", or "negative"
  /// Schema: enum, required, default: "neutral"
  @override
  String get sentiment;

  /// Descriptive tags (e.g., ["Delayed", "Great Service", "Comfortable"])
  /// Schema: array of strings, required, default: []
  @override
  List<String> get tags;

  /// Overall rating from 1-5
  /// Schema: integer, required, min: 1, max: 5, default: 3
  @override
  int get rating;

  /// Positive aspects mentioned (e.g., ["Friendly crew", "On-time departure"])
  /// Schema: array of strings, required, default: []
  @override
  List<String> get highlights;

  /// Negative aspects or problems (e.g., ["Flight delayed", "Uncomfortable seat"])
  /// Schema: array of strings, required, default: []
  @override
  List<String> get issues;

  /// Aircraft type if mentioned (e.g., "Boeing 737", "Airbus A320")
  /// Schema: string, nullable
  @override
  String? get aircraftType;

  /// Seat number if mentioned (e.g., "12A", "8C")
  /// Schema: string, nullable
  @override
  String? get seatNumber;

  /// Cabin class: "Economy", "Premium Economy", "Business", or "First Class"
  /// Schema: enum, nullable
  @override
  String? get cabinClass;

  /// Create a copy of AIFlightExtraction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIFlightExtractionImplCopyWith<_$AIFlightExtractionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
