class BookingModel {
  final String id;
  final String userId;
  final String parkingSpotId;
  final DateTime startTime;
  final DateTime endTime;
  final double totalCost;
  final String status; // 'pending', 'confirmed', 'cancelled'

  const BookingModel({
    required this.id,
    required this.userId,
    required this.parkingSpotId,
    required this.startTime,
    required this.endTime,
    required this.totalCost,
    required this.status,
  });

  @override
  String toString() => 'BookingModel(id: $id, status: $status)';
}
