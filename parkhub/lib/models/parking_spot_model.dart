class ParkingSpotModel {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double pricePerHour;
  final bool isAvailable;
  final int totalSpaces;
  final int availableSpaces;
  final double distanceKm;
  final String timeLimit;
  final String peakTimes;
  final String offPeakTimes;
  final String predictedBusyHours;

  const ParkingSpotModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.pricePerHour,
    required this.isAvailable,
    required this.totalSpaces,
    required this.availableSpaces,
    required this.distanceKm,
    required this.timeLimit,
    required this.peakTimes,
    required this.offPeakTimes,
    required this.predictedBusyHours,
  });

  @override
  String toString() => 'ParkingSpotModel(id: $id, name: $name)';
}
