import 'package:flutter/material.dart';

class ParkingCard extends StatelessWidget {
  final String name;
  final String address;
  final double pricePerHour;
  final int availableSpaces;
  final double distanceKm;
  final String timeLimit;
  final VoidCallback? onTap;

  const ParkingCard({
    super.key,
    required this.name,
    required this.address,
    required this.pricePerHour,
    required this.availableSpaces,
    required this.distanceKm,
    required this.timeLimit,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.local_parking, size: 40, color: Colors.blueAccent),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$availableSpaces spaces available',
                      style: TextStyle(
                        fontSize: 12,
                        color: availableSpaces > 0 ? Colors.green : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Distance: ${distanceKm.toStringAsFixed(1)} km',
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      'Time limit: $timeLimit',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${pricePerHour.toStringAsFixed(2)}/hr',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
