import 'package:flutter/material.dart';

class ParkingCard extends StatelessWidget {
  final String name;
  final String address;
  final double pricePerHour;
  final int availableSpaces;

  const ParkingCard({
    super.key,
    required this.name,
    required this.address,
    required this.pricePerHour,
    required this.availableSpaces,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    );
  }
}
