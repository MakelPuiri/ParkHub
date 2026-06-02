class SearchParkingService {
  static List<Map<String, dynamic>> search(
    List<Map<String, dynamic>> parkingSpots,
    String query,
  ) {
    final searchQuery = query.trim().toLowerCase();

    if (searchQuery.isEmpty) {
      return parkingSpots;
    }

    return parkingSpots.where((spot) {
      final name = spot['name'].toString().toLowerCase();
      final location = spot['location'].toString().toLowerCase();

      return name.contains(searchQuery) || location.contains(searchQuery);
    }).toList();
  }

  static String getAvailabilityStatus(Map<String, dynamic> parkingSpot) {
    final availableSpaces = parkingSpot['availableSpaces'] as int;

    if (availableSpaces == 0) {
      return 'Full';
    }

    if (availableSpaces <= 5) {
      return 'Limited spaces';
    }

    return 'Available';
  }
}
