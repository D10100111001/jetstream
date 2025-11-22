import 'dart:collection';
import 'package:flutter/material.dart';
import '../models/flight.dart';

class AppProvider with ChangeNotifier {
  final List<Flight> _flights = [];

  UnmodifiableListView<Flight> get flights => UnmodifiableListView(_flights);

  void addFlight(Flight flight) {
    _flights.add(flight);
    // Sort flights by date, most recent first
    _flights.sort((a, b) => b.departureTime.compareTo(a.departureTime));
    notifyListeners();
  }
}
