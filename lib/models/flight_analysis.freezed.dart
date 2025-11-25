// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flight_analysis.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

FlightCandidate _$FlightCandidateFromJson(Map<String, dynamic> json) {
  return _FlightCandidate.fromJson(json);
}

/// @nodoc
mixin _$FlightCandidate {
  String? get date => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get airline => throw _privateConstructorUsedError;
  String? get flightNumber => throw _privateConstructorUsedError;
  FlightEndpoint? get departure => throw _privateConstructorUsedError;
  FlightEndpoint? get arrival => throw _privateConstructorUsedError;
  String? get aircraft => throw _privateConstructorUsedError;

  /// Serializes this FlightCandidate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FlightCandidate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FlightCandidateCopyWith<FlightCandidate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlightCandidateCopyWith<$Res> {
  factory $FlightCandidateCopyWith(
    FlightCandidate value,
    $Res Function(FlightCandidate) then,
  ) = _$FlightCandidateCopyWithImpl<$Res, FlightCandidate>;
  @useResult
  $Res call({
    String? date,
    String? status,
    String? airline,
    String? flightNumber,
    FlightEndpoint? departure,
    FlightEndpoint? arrival,
    String? aircraft,
  });

  $FlightEndpointCopyWith<$Res>? get departure;
  $FlightEndpointCopyWith<$Res>? get arrival;
}

/// @nodoc
class _$FlightCandidateCopyWithImpl<$Res, $Val extends FlightCandidate>
    implements $FlightCandidateCopyWith<$Res> {
  _$FlightCandidateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FlightCandidate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = freezed,
    Object? status = freezed,
    Object? airline = freezed,
    Object? flightNumber = freezed,
    Object? departure = freezed,
    Object? arrival = freezed,
    Object? aircraft = freezed,
  }) {
    return _then(
      _value.copyWith(
            date: freezed == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as String?,
            status: freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String?,
            airline: freezed == airline
                ? _value.airline
                : airline // ignore: cast_nullable_to_non_nullable
                      as String?,
            flightNumber: freezed == flightNumber
                ? _value.flightNumber
                : flightNumber // ignore: cast_nullable_to_non_nullable
                      as String?,
            departure: freezed == departure
                ? _value.departure
                : departure // ignore: cast_nullable_to_non_nullable
                      as FlightEndpoint?,
            arrival: freezed == arrival
                ? _value.arrival
                : arrival // ignore: cast_nullable_to_non_nullable
                      as FlightEndpoint?,
            aircraft: freezed == aircraft
                ? _value.aircraft
                : aircraft // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }

  /// Create a copy of FlightCandidate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FlightEndpointCopyWith<$Res>? get departure {
    if (_value.departure == null) {
      return null;
    }

    return $FlightEndpointCopyWith<$Res>(_value.departure!, (value) {
      return _then(_value.copyWith(departure: value) as $Val);
    });
  }

  /// Create a copy of FlightCandidate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FlightEndpointCopyWith<$Res>? get arrival {
    if (_value.arrival == null) {
      return null;
    }

    return $FlightEndpointCopyWith<$Res>(_value.arrival!, (value) {
      return _then(_value.copyWith(arrival: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FlightCandidateImplCopyWith<$Res>
    implements $FlightCandidateCopyWith<$Res> {
  factory _$$FlightCandidateImplCopyWith(
    _$FlightCandidateImpl value,
    $Res Function(_$FlightCandidateImpl) then,
  ) = __$$FlightCandidateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? date,
    String? status,
    String? airline,
    String? flightNumber,
    FlightEndpoint? departure,
    FlightEndpoint? arrival,
    String? aircraft,
  });

  @override
  $FlightEndpointCopyWith<$Res>? get departure;
  @override
  $FlightEndpointCopyWith<$Res>? get arrival;
}

/// @nodoc
class __$$FlightCandidateImplCopyWithImpl<$Res>
    extends _$FlightCandidateCopyWithImpl<$Res, _$FlightCandidateImpl>
    implements _$$FlightCandidateImplCopyWith<$Res> {
  __$$FlightCandidateImplCopyWithImpl(
    _$FlightCandidateImpl _value,
    $Res Function(_$FlightCandidateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FlightCandidate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = freezed,
    Object? status = freezed,
    Object? airline = freezed,
    Object? flightNumber = freezed,
    Object? departure = freezed,
    Object? arrival = freezed,
    Object? aircraft = freezed,
  }) {
    return _then(
      _$FlightCandidateImpl(
        date: freezed == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: freezed == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String?,
        airline: freezed == airline
            ? _value.airline
            : airline // ignore: cast_nullable_to_non_nullable
                  as String?,
        flightNumber: freezed == flightNumber
            ? _value.flightNumber
            : flightNumber // ignore: cast_nullable_to_non_nullable
                  as String?,
        departure: freezed == departure
            ? _value.departure
            : departure // ignore: cast_nullable_to_non_nullable
                  as FlightEndpoint?,
        arrival: freezed == arrival
            ? _value.arrival
            : arrival // ignore: cast_nullable_to_non_nullable
                  as FlightEndpoint?,
        aircraft: freezed == aircraft
            ? _value.aircraft
            : aircraft // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FlightCandidateImpl implements _FlightCandidate {
  const _$FlightCandidateImpl({
    required this.date,
    required this.status,
    required this.airline,
    required this.flightNumber,
    required this.departure,
    required this.arrival,
    required this.aircraft,
  });

  factory _$FlightCandidateImpl.fromJson(Map<String, dynamic> json) =>
      _$$FlightCandidateImplFromJson(json);

  @override
  final String? date;
  @override
  final String? status;
  @override
  final String? airline;
  @override
  final String? flightNumber;
  @override
  final FlightEndpoint? departure;
  @override
  final FlightEndpoint? arrival;
  @override
  final String? aircraft;

  @override
  String toString() {
    return 'FlightCandidate(date: $date, status: $status, airline: $airline, flightNumber: $flightNumber, departure: $departure, arrival: $arrival, aircraft: $aircraft)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlightCandidateImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.airline, airline) || other.airline == airline) &&
            (identical(other.flightNumber, flightNumber) ||
                other.flightNumber == flightNumber) &&
            (identical(other.departure, departure) ||
                other.departure == departure) &&
            (identical(other.arrival, arrival) || other.arrival == arrival) &&
            (identical(other.aircraft, aircraft) ||
                other.aircraft == aircraft));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    date,
    status,
    airline,
    flightNumber,
    departure,
    arrival,
    aircraft,
  );

  /// Create a copy of FlightCandidate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlightCandidateImplCopyWith<_$FlightCandidateImpl> get copyWith =>
      __$$FlightCandidateImplCopyWithImpl<_$FlightCandidateImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FlightCandidateImplToJson(this);
  }
}

abstract class _FlightCandidate implements FlightCandidate {
  const factory _FlightCandidate({
    required final String? date,
    required final String? status,
    required final String? airline,
    required final String? flightNumber,
    required final FlightEndpoint? departure,
    required final FlightEndpoint? arrival,
    required final String? aircraft,
  }) = _$FlightCandidateImpl;

  factory _FlightCandidate.fromJson(Map<String, dynamic> json) =
      _$FlightCandidateImpl.fromJson;

  @override
  String? get date;
  @override
  String? get status;
  @override
  String? get airline;
  @override
  String? get flightNumber;
  @override
  FlightEndpoint? get departure;
  @override
  FlightEndpoint? get arrival;
  @override
  String? get aircraft;

  /// Create a copy of FlightCandidate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlightCandidateImplCopyWith<_$FlightCandidateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FlightEndpoint _$FlightEndpointFromJson(Map<String, dynamic> json) {
  return _FlightEndpoint.fromJson(json);
}

/// @nodoc
mixin _$FlightEndpoint {
  String? get airport => throw _privateConstructorUsedError;
  String? get iata => throw _privateConstructorUsedError;
  String? get scheduled => throw _privateConstructorUsedError;
  String? get actual => throw _privateConstructorUsedError;

  /// Serializes this FlightEndpoint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FlightEndpoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FlightEndpointCopyWith<FlightEndpoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlightEndpointCopyWith<$Res> {
  factory $FlightEndpointCopyWith(
    FlightEndpoint value,
    $Res Function(FlightEndpoint) then,
  ) = _$FlightEndpointCopyWithImpl<$Res, FlightEndpoint>;
  @useResult
  $Res call({String? airport, String? iata, String? scheduled, String? actual});
}

/// @nodoc
class _$FlightEndpointCopyWithImpl<$Res, $Val extends FlightEndpoint>
    implements $FlightEndpointCopyWith<$Res> {
  _$FlightEndpointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FlightEndpoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? airport = freezed,
    Object? iata = freezed,
    Object? scheduled = freezed,
    Object? actual = freezed,
  }) {
    return _then(
      _value.copyWith(
            airport: freezed == airport
                ? _value.airport
                : airport // ignore: cast_nullable_to_non_nullable
                      as String?,
            iata: freezed == iata
                ? _value.iata
                : iata // ignore: cast_nullable_to_non_nullable
                      as String?,
            scheduled: freezed == scheduled
                ? _value.scheduled
                : scheduled // ignore: cast_nullable_to_non_nullable
                      as String?,
            actual: freezed == actual
                ? _value.actual
                : actual // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FlightEndpointImplCopyWith<$Res>
    implements $FlightEndpointCopyWith<$Res> {
  factory _$$FlightEndpointImplCopyWith(
    _$FlightEndpointImpl value,
    $Res Function(_$FlightEndpointImpl) then,
  ) = __$$FlightEndpointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? airport, String? iata, String? scheduled, String? actual});
}

/// @nodoc
class __$$FlightEndpointImplCopyWithImpl<$Res>
    extends _$FlightEndpointCopyWithImpl<$Res, _$FlightEndpointImpl>
    implements _$$FlightEndpointImplCopyWith<$Res> {
  __$$FlightEndpointImplCopyWithImpl(
    _$FlightEndpointImpl _value,
    $Res Function(_$FlightEndpointImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FlightEndpoint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? airport = freezed,
    Object? iata = freezed,
    Object? scheduled = freezed,
    Object? actual = freezed,
  }) {
    return _then(
      _$FlightEndpointImpl(
        airport: freezed == airport
            ? _value.airport
            : airport // ignore: cast_nullable_to_non_nullable
                  as String?,
        iata: freezed == iata
            ? _value.iata
            : iata // ignore: cast_nullable_to_non_nullable
                  as String?,
        scheduled: freezed == scheduled
            ? _value.scheduled
            : scheduled // ignore: cast_nullable_to_non_nullable
                  as String?,
        actual: freezed == actual
            ? _value.actual
            : actual // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FlightEndpointImpl implements _FlightEndpoint {
  const _$FlightEndpointImpl({
    required this.airport,
    required this.iata,
    required this.scheduled,
    required this.actual,
  });

  factory _$FlightEndpointImpl.fromJson(Map<String, dynamic> json) =>
      _$$FlightEndpointImplFromJson(json);

  @override
  final String? airport;
  @override
  final String? iata;
  @override
  final String? scheduled;
  @override
  final String? actual;

  @override
  String toString() {
    return 'FlightEndpoint(airport: $airport, iata: $iata, scheduled: $scheduled, actual: $actual)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlightEndpointImpl &&
            (identical(other.airport, airport) || other.airport == airport) &&
            (identical(other.iata, iata) || other.iata == iata) &&
            (identical(other.scheduled, scheduled) ||
                other.scheduled == scheduled) &&
            (identical(other.actual, actual) || other.actual == actual));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, airport, iata, scheduled, actual);

  /// Create a copy of FlightEndpoint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FlightEndpointImplCopyWith<_$FlightEndpointImpl> get copyWith =>
      __$$FlightEndpointImplCopyWithImpl<_$FlightEndpointImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$FlightEndpointImplToJson(this);
  }
}

abstract class _FlightEndpoint implements FlightEndpoint {
  const factory _FlightEndpoint({
    required final String? airport,
    required final String? iata,
    required final String? scheduled,
    required final String? actual,
  }) = _$FlightEndpointImpl;

  factory _FlightEndpoint.fromJson(Map<String, dynamic> json) =
      _$FlightEndpointImpl.fromJson;

  @override
  String? get airport;
  @override
  String? get iata;
  @override
  String? get scheduled;
  @override
  String? get actual;

  /// Create a copy of FlightEndpoint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FlightEndpointImplCopyWith<_$FlightEndpointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
