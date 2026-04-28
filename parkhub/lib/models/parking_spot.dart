// lib/models/parking_spot.dart

class ParkingSpot {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double pricePerHour;
  final int availableSpaces;
  final bool isCovered;

  const ParkingSpot({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.pricePerHour,
    required this.availableSpaces,
    this.isCovered = false,
  });
}
