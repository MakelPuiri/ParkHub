import 'package:flutter_test/flutter_test.dart';
import 'package:parkhub/services/search_parking_service.dart';

void main() {
  group('Search Parking Feature TDD', () {
    final parkingSpots = [
      {
        'name': 'Civic Car Park',
        'location': 'Auckland CBD',
        'price': 4.50,
        'distance': 0.4,
        'timeLimit': '2 hours',
        'availableSpaces': 25,
      },
      {
        'name': 'SkyCity Parking',
        'location': 'Victoria Street',
        'price': 6.00,
        'distance': 0.7,
        'timeLimit': 'All day',
        'availableSpaces': 10,
      },
      {
        'name': 'Britomart Car Park',
        'location': 'Quay Street',
        'price': 5.00,
        'distance': 1.1,
        'timeLimit': '3 hours',
        'availableSpaces': 0,
      },
    ];

    test('1. returns parking spaces near the searched destination', () {
      final results = SearchParkingService.search(parkingSpots, 'Auckland');

      expect(results.length, 1);
      expect(results.first['name'], 'Civic Car Park');
    });

    test('2. each parking result includes price, distance, and time limit', () {
      final results = SearchParkingService.search(parkingSpots, 'Victoria');

      expect(results.length, 1);
      expect(results.first['price'], isNotNull);
      expect(results.first['distance'], isNotNull);
      expect(results.first['timeLimit'], isNotNull);
    });

    test('3. parking availability updates when data changes', () {
      final updatedSpot = {
        'name': 'SkyCity Parking',
        'location': 'Victoria Street',
        'price': 6.00,
        'distance': 0.7,
        'timeLimit': 'All day',
        'availableSpaces': 3,
      };

      final status = SearchParkingService.getAvailabilityStatus(updatedSpot);

      expect(status, 'Limited spaces');
    });
  });
}
