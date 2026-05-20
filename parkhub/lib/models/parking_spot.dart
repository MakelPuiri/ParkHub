// lib/models/parking_spot.dart
// Sprint 2 — availableSpaces is now mutable so refreshMockAvailability() can
// update it without recreating every spot object.

import 'package:flutter/material.dart';

class ParkingSpot {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double pricePerHour;
  int availableSpaces; // mutable for mock real-time refresh
  final bool isCovered;

  ParkingSpot({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.pricePerHour,
    required this.availableSpaces,
    this.isCovered = false,
  });

  // ── Availability helpers ─────────────────────────────────────────────────

  /// Returns a human-readable status string based on available spaces.
  String getAvailabilityStatus() {
    if (availableSpaces == 0) return 'Full';
    if (availableSpaces <= 10) return 'Limited';
    return 'Available';
  }

  /// Returns the marker / badge colour based on available spaces.
  /// Green  = > 10 spaces
  /// Orange = 1–10 spaces
  /// Red    = 0 spaces (full)
  Color getAvailabilityColor() {
    if (availableSpaces == 0) return Colors.red.shade600;
    if (availableSpaces <= 10) return Colors.orange.shade600;
    return const Color(0xFF1A7F4B); // ParkHub green
  }
}
