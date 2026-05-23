// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../services/parking_service.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/parking_card.dart';
import '../screens/parking_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Pull all spots from the single source of truth in ParkingService
    final spots = ParkingService.getAllSpots;

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
            Text(
              'Nearby Parking (${spots.length})',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: spots.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final spot = spots[index];
                  return ParkingCard(
                    locationId: spot.id,
                    name: spot.name,
                    address: spot.address,
                    pricePerHour: spot.pricePerHour,
                    availableSpaces: spot.availableSpaces,
                    totalSpaces: spot.totalSpaces,
                    distanceKm: spot.distanceKm,
                    timeLimit: spot.timeLimit,
                    hasEvCharging: spot.hasEvCharging,
                    evChargersAvailable: spot.evChargersAvailable,
                    evChargerType: spot.evChargerType,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ParkingDetailScreen(spot: spot),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
    );
  }
}
