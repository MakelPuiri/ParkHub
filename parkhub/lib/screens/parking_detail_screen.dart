import 'package:flutter/material.dart';
import '../models/parking_spot_model.dart';

class ParkingDetailScreen extends StatelessWidget {
  final ParkingSpotModel parkingSpot;

  const ParkingDetailScreen({
    super.key,
    required this.parkingSpot,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(parkingSpot.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      parkingSpot.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(parkingSpot.address),
                    const SizedBox(height: 12),
                    Text('Price: \$${parkingSpot.pricePerHour.toStringAsFixed(2)}/hr'),
                    Text('Available spaces: ${parkingSpot.availableSpaces}/${parkingSpot.totalSpaces}'),
                    Text('Distance: ${parkingSpot.distanceKm.toStringAsFixed(1)} km'),
                    Text('Time limit: ${parkingSpot.timeLimit}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Parking Demand Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Peak times: ${parkingSpot.peakTimes}'),
                    const SizedBox(height: 12),
                    Text('Off-peak times: ${parkingSpot.offPeakTimes}'),
                    const SizedBox(height: 12),
                    Text('Predicted busy hours: ${parkingSpot.predictedBusyHours}'),
                    const SizedBox(height: 16),
                    const Text(
                      'These times are based on historical parking demand data.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
