import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../features/auth/login_screen.dart';
import '../features/home/home_screen.dart';
import '../features/flight_log/flight_log_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/all_flights/all_flights_screen.dart';
import '../features/flight_details/flight_details_screen.dart';
import '../features/settings/notifications_settings_screen.dart';
import '../features/settings/privacy_settings_screen.dart';
import '../features/settings/help_support_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoginRoute = state.matchedLocation == '/login';

    // If not logged in and not on login page, redirect to login
    if (user == null && !isLoginRoute) {
      return '/login';
    }

    // If logged in and on login page, redirect to home
    if (user != null && isLoginRoute) {
      return '/home';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/log-flight',
      builder: (context, state) => const FlightLogScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/all-flights',
      builder: (context, state) => const AllFlightsScreen(),
    ),
    GoRoute(
      path: '/flight/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return FlightDetailsScreen(flightId: id);
      },
    ),
    GoRoute(
      path: '/settings/notifications',
      builder: (context, state) => const NotificationsSettingsScreen(),
    ),
    GoRoute(
      path: '/settings/privacy',
      builder: (context, state) => const PrivacySettingsScreen(),
    ),
    GoRoute(
      path: '/settings/help',
      builder: (context, state) => const HelpSupportScreen(),
    ),
  ],
);
