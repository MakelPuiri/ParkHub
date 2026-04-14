import 'package:flutter/material.dart';
import '../models/parking_spot_model.dart';

class ParkingDetailScreen extends StatelessWidget {
  final ParkingSpotModel spot;

  const ParkingDetailScreen({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(spot.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SpotInfoCard(spot: spot),
            const SizedBox(height: 16),
            _DetailRow(
              icon: Icons.location_on,
              label: 'Address',
              value: spot.address,
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.attach_money,
              label: 'Price',
              value: '\$${spot.pricePerHour.toStringAsFixed(2)}/hr',
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.directions_car,
              label: 'Availability',
              value: spot.isAvailable
                  ? '${spot.availableSpaces} of ${spot.totalSpaces} spaces available'
                  : 'Full',
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.straighten,
              label: 'Distance',
              value: '${spot.distanceKm} km',
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.timer,
              label: 'Time limit',
              value: spot.timeLimit,
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.schedule,
              label: 'Peak times',
              value: spot.peakTimes,
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.wb_sunny_outlined,
              label: 'Off-peak times',
              value: spot.offPeakTimes,
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.trending_up,
              label: 'Predicted busy hours',
              value: spot.predictedBusyHours,
            ),
          ],
        ),
      ),
    );
  }
}

class _SpotInfoCard extends StatelessWidget {
  final ParkingSpotModel spot;

  const _SpotInfoCard({required this.spot});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              spot.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(spot.address, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.attach_money, size: 18),
                Text('\$${spot.pricePerHour.toStringAsFixed(2)}/hr'),
                const SizedBox(width: 16),
                Icon(
                  Icons.circle,
                  size: 12,
                  color: spot.isAvailable ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 4),
                Text(
                  spot.isAvailable
                      ? '${spot.availableSpaces} spaces available'
                      : 'Full',
                  style: TextStyle(
                    color: spot.isAvailable ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
