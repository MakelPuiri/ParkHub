import 'package:geolocator/geolocator.dart';
import '../models/parking_spot.dart';

class ParkingFilterService {
  static List<ParkingSpot> sortByNearest(
    List<ParkingSpot> spots,
    double destinationLat,
    double destinationLng,
  ) {
    final sortedSpots = List<ParkingSpot>.from(spots);

    sortedSpots.sort((a, b) {
      final distanceA = Geolocator.distanceBetween(
        destinationLat,
        destinationLng,
        a.latitude,
        a.longitude,
      );

      final distanceB = Geolocator.distanceBetween(
        destinationLat,
        destinationLng,
        b.latitude,
        b.longitude,
      );

      return distanceA.compareTo(distanceB);
    });

    return sortedSpots;
  }
}