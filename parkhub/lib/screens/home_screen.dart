import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/parking_card.dart';
import '../models/parking_spot_model.dart';
import '../screens/parking_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Sample spots — replace with ParkingService.getAllParkingSpots() later
  static final List<ParkingSpotModel> _sampleSpots = [
    ParkingSpotModel(
      id: '1',
      name: 'Sample Parking Spot',
      address: '123 Queen Street, Auckland',
      latitude: -36.8485,
      longitude: 174.7633,
      pricePerHour: 5.00,
      isAvailable: true,
      totalSpaces: 20,
      availableSpaces: 12,
      distanceKm: 1.2,
      timeLimit: '2 hours',
      peakTimes: '8:00 AM, 5:00 PM',
      offPeakTimes: '11:00 AM, 2:00 PM',
      predictedBusyHours: '7:30 AM - 9:00 AM, 4:30 PM - 6:00 PM',
    ),
    ParkingSpotModel(
      id: '2',
      name: 'Another Car Park',
      address: '456 K-Road, Auckland',
      latitude: -36.8599,
      longitude: 174.7568,
      pricePerHour: 3.50,
      isAvailable: true,
      totalSpaces: 10,
      availableSpaces: 4,
      distanceKm: 0.8,
      timeLimit: '1 hour',
      peakTimes: '8:00 AM, 5:00 PM',
      offPeakTimes: '11:00 AM, 2:00 PM',
      predictedBusyHours: '7:30 AM - 9:00 AM, 4:30 PM - 6:00 PM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ParkHub'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nearby Parking',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            // Tapping a card opens the detail screen
            ...(_sampleSpots.map(
              (spot) => GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ParkingDetailScreen(spot: spot),
                  ),
                ),
                child: ParkingCard(
                  locationId: spot.id,
                  name: spot.name,
                  address: spot.address,
                  pricePerHour: spot.pricePerHour,
                  availableSpaces: spot.availableSpaces,
                  distanceKm: spot.distanceKm,
                  timeLimit: spot.timeLimit,
                ),
              ),
            )),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }
}
