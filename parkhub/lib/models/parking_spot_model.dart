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
  });

  @override
  String toString() => 'ParkingSpotModel(id: $id, name: $name)';
}
