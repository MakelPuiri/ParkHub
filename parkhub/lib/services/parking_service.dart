import '../models/parking_spot_model.dart';
import '../models/predicted_availability.dart';

class ParkingService {
  static final List<ParkingSpotModel> _parkingSpots = [
    ParkingSpotModel(
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

    ParkingSpotModel(
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
    ParkingSpotModel(
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
    ParkingSpotModel(
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
  ];

  static List<ParkingSpotModel> searchByLocation(String query) {
    if (query.trim().isEmpty) {
      return [];
    }

    return _parkingSpots.where((spot) {
      final lowerQuery = query.toLowerCase();
      return spot.name.toLowerCase().contains(lowerQuery) ||
          spot.address.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  static Future<PredictedAvailability> getPredictedAvailability(String parkingId) async 
      {
        // Simulate network delay
        await Future.delayed(const Duration(seconds: 1));

        // Return mock predicted availability data
        return PredictedAvailability(
          lotId: parkingId,
          timestamp: DateTime.now(),
          predictedAvailableSpots: 15,
          totalSpaces: 50,
          peakTimes: [
            PeakTime(day: 'Monday', startTime: '8:00 AM', endTime: '10:00 AM'),
            PeakTime(day: 'Monday', startTime: '4:00 PM', endTime: '6:00 PM'),
            PeakTime(day: 'Tuesday', startTime: '8:00 AM', endTime: '10:00 AM'),
            PeakTime(day: 'Tuesday', startTime: '4:00 PM', endTime: '6:00 PM'),
            // Add more peak times as needed
          ],
          offPeakTimes: [
            PeakTime(day: 'Monday', startTime: '11:00 AM', endTime: '3:00 PM'),
            PeakTime(day: 'Tuesday', startTime: '11:00 AM', endTime: '3:00 PM'),
            // Add more off-peak times as needed
          ],
        );
      }
}
