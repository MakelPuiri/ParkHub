// lib/services/parking_service.dart

import 'dart:math';
import '../models/parking_spot.dart';
import '../models/parking_spot_model.dart';
import '../services/predicted_availability.dart';

class ParkingService {
  // ── Mock data — 12 Auckland CBD spots ────────────────────────────────────
  static final List<ParkingSpotModel> _parkingSpots = [
    const ParkingSpotModel(
      id: '1',
      name: 'Downtown Parking',
      address: '120 Queen Street, Auckland',
      latitude: -36.8485,
      longitude: 174.7633,
      pricePerHour: 4.00,
      isAvailable: true,
      totalSpaces: 50,
      availableSpaces: 18,
      distanceKm: 0.4,
      timeLimit: '2 hours',
      peakTimes: '8:00 AM - 10:00 AM, 4:00 PM - 6:00 PM',
      offPeakTimes: '11:00 AM - 3:00 PM',
      predictedBusyHours: 'Weekdays during commute hours',
    ),
    const ParkingSpotModel(
      id: '2',
      name: 'SkyCity Car Park',
      address: '72 Victoria Street West, Auckland',
      latitude: -36.8490,
      longitude: 174.7620,
      pricePerHour: 6.00,
      isAvailable: true,
      totalSpaces: 40,
      availableSpaces: 10,
      distanceKm: 0.8,
      timeLimit: '4 hours',
      peakTimes: '12:00 PM - 2:00 PM, 5:00 PM - 7:00 PM',
      offPeakTimes: '9:30 AM - 11:30 AM',
      predictedBusyHours: 'Lunch periods and evenings',
    ),
    const ParkingSpotModel(
      id: '3',
      name: 'Britomart Parking Hub',
      address: '8 Beach Road, Auckland',
      latitude: -36.8440,
      longitude: 174.7680,
      pricePerHour: 5.00,
      isAvailable: true,
      totalSpaces: 60,
      availableSpaces: 25,
      distanceKm: 1.1,
      timeLimit: '3 hours',
      peakTimes: '7:30 AM - 9:30 AM, 3:30 PM - 6:00 PM',
      offPeakTimes: '10:30 AM - 2:30 PM',
      predictedBusyHours: 'Office rush hours',
    ),
    const ParkingSpotModel(
      id: '4',
      name: 'City Centre Parking',
      address: '50 Albert Street, Auckland',
      latitude: -36.8475,
      longitude: 174.7645,
      pricePerHour: 3.50,
      isAvailable: true,
      totalSpaces: 35,
      availableSpaces: 6,
      distanceKm: 0.6,
      timeLimit: '90 minutes',
      peakTimes: '8:00 AM - 9:30 AM, 4:30 PM - 6:00 PM',
      offPeakTimes: '11:00 AM - 2:00 PM',
      predictedBusyHours: 'Morning and late afternoon',
    ),
    const ParkingSpotModel(
      id: '5',
      name: 'Wynyard Quarter Parking',
      address: '12 Jellicoe Street, Auckland',
      latitude: -36.8420,
      longitude: 174.7590,
      pricePerHour: 4.50,
      isAvailable: true,
      totalSpaces: 80,
      availableSpaces: 42,
      distanceKm: 1.5,
      timeLimit: 'No limit',
      peakTimes: '10:00 AM - 1:00 PM, 5:00 PM - 8:00 PM',
      offPeakTimes: '2:00 PM - 4:00 PM',
      predictedBusyHours: 'Weekend afternoons',
    ),
    const ParkingSpotModel(
      id: '6',
      name: 'Viaduct Harbour Parking',
      address: '85 Customs Street West, Auckland',
      latitude: -36.8432,
      longitude: 174.7618,
      pricePerHour: 7.00,
      isAvailable: true,
      totalSpaces: 30,
      availableSpaces: 3,
      distanceKm: 1.2,
      timeLimit: '3 hours',
      peakTimes: '6:00 PM - 10:00 PM',
      offPeakTimes: '10:00 AM - 12:00 PM',
      predictedBusyHours: 'Friday & Saturday evenings',
    ),
    const ParkingSpotModel(
      id: '7',
      name: 'Karangahape Road Parking',
      address: '310 K Road, Auckland',
      latitude: -36.8588,
      longitude: 174.7568,
      pricePerHour: 2.50,
      isAvailable: true,
      totalSpaces: 45,
      availableSpaces: 30,
      distanceKm: 2.0,
      timeLimit: '2 hours',
      peakTimes: '8:00 AM - 9:00 AM, 5:00 PM - 6:00 PM',
      offPeakTimes: '12:00 PM - 3:00 PM',
      predictedBusyHours: 'Weekday mornings',
    ),
    const ParkingSpotModel(
      id: '8',
      name: 'Federal Street Parking',
      address: '22 Federal Street, Auckland',
      latitude: -36.8470,
      longitude: 174.7628,
      pricePerHour: 5.50,
      isAvailable: true,
      totalSpaces: 55,
      availableSpaces: 14,
      distanceKm: 0.5,
      timeLimit: '4 hours',
      peakTimes: '8:00 AM - 10:00 AM, 4:00 PM - 6:30 PM',
      offPeakTimes: '11:30 AM - 2:30 PM',
      predictedBusyHours: 'Business hours weekdays',
    ),
    const ParkingSpotModel(
      id: '9',
      name: 'Shortland Street Parking',
      address: '41 Shortland Street, Auckland',
      latitude: -36.8462,
      longitude: 174.7655,
      pricePerHour: 6.50,
      isAvailable: false,
      totalSpaces: 25,
      availableSpaces: 0,
      distanceKm: 0.7,
      timeLimit: '2 hours',
      peakTimes: '7:30 AM - 9:30 AM, 4:30 PM - 6:30 PM',
      offPeakTimes: '1:00 PM - 3:00 PM',
      predictedBusyHours: 'All weekday mornings',
    ),
    const ParkingSpotModel(
      id: '10',
      name: 'Ponsonby Central Parking',
      address: '136 Ponsonby Road, Auckland',
      latitude: -36.8530,
      longitude: 174.7480,
      pricePerHour: 3.00,
      isAvailable: true,
      totalSpaces: 70,
      availableSpaces: 38,
      distanceKm: 2.4,
      timeLimit: 'No limit',
      peakTimes: '9:00 AM - 11:00 AM, 6:00 PM - 9:00 PM',
      offPeakTimes: '2:00 PM - 5:00 PM',
      predictedBusyHours: 'Brunch and dinner hours',
    ),
    const ParkingSpotModel(
      id: '11',
      name: 'Newmarket Park & Ride',
      address: '3 Teed Street, Newmarket, Auckland',
      latitude: -36.8700,
      longitude: 174.7760,
      pricePerHour: 2.00,
      isAvailable: true,
      totalSpaces: 120,
      availableSpaces: 85,
      distanceKm: 3.1,
      timeLimit: 'No limit',
      peakTimes: '7:00 AM - 9:00 AM, 4:00 PM - 6:00 PM',
      offPeakTimes: '10:00 AM - 3:00 PM',
      predictedBusyHours: 'Weekday commute times',
    ),
    const ParkingSpotModel(
      id: '12',
      name: 'Parnell Village Parking',
      address: '280 Parnell Road, Auckland',
      latitude: -36.8560,
      longitude: 174.7770,
      pricePerHour: 3.50,
      isAvailable: true,
      totalSpaces: 40,
      availableSpaces: 22,
      distanceKm: 2.8,
      timeLimit: '3 hours',
      peakTimes: '11:00 AM - 2:00 PM',
      offPeakTimes: '3:00 PM - 5:00 PM',
      predictedBusyHours: 'Weekend lunch crowds',
    ),
  ];

  // ── Getters ───────────────────────────────────────────────────────────────

  /// All spots — used by HomeScreen and ParkingListScreen.
  static List<ParkingSpotModel> get getAllSpots => List.of(_parkingSpots);

  static double get overallAvailabilityPercentage {
    if (_parkingSpots.isEmpty) return 0.0;
    int totalAvail = 0, totalSpaces = 0;
    for (final s in _parkingSpots) {
      totalAvail += s.availableSpaces;
      totalSpaces += s.totalSpaces;
    }
    return totalSpaces > 0 ? (totalAvail / totalSpaces) * 100 : 0.0;
  }

  /// Returns all spots when [query] is empty, filtered results otherwise.
  static List<ParkingSpotModel> searchByLocation(String query) {
    if (query.trim().isEmpty) return List.of(_parkingSpots);
    final q = query.toLowerCase();
    return _parkingSpots
        .where(
          (s) =>
              s.name.toLowerCase().contains(q) ||
              s.address.toLowerCase().contains(q),
        )
        .toList();
  }

  static Future<PredictedAvailability> getPredictedAvailability(
    String parkingId,
  ) async {
    await Future.delayed(const Duration(seconds: 1));
    return PredictedAvailability(
      lotId: parkingId,
      timestamp: DateTime.now(),
      predictedAvailableSpots: 15,
      totalSpaces: 50,
      peakTimes: [
        PeakTime(day: 'Monday', startTime: '8:00 AM', endTime: '10:00 AM'),
        PeakTime(day: 'Monday', startTime: '4:00 PM', endTime: '6:00 PM'),
      ],
      offPeakTimes: [
        PeakTime(day: 'Monday', startTime: '11:00 AM', endTime: '3:00 PM'),
      ],
    );
  }

  // ── Sprint 2: mock real-time refresh for MapScreen markers ────────────────
  static final _rng = Random();

  static void refreshMockAvailability(List<ParkingSpot> spots) {
    for (final spot in spots) {
      final roll = _rng.nextInt(10);
      if (roll == 0) {
        spot.availableSpaces = 0;
      } else if (roll <= 3) {
        spot.availableSpaces = _rng.nextInt(10) + 1;
      } else {
        spot.availableSpaces = _rng.nextInt(15) + 11;
      }
    }
  }
}
