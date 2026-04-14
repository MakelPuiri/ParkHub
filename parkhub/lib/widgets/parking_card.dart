import 'package:flutter/material.dart';
import 'favourite_button.dart';

class ParkingCard extends StatelessWidget {
  final String locationId;
  final String name;
  final String address;
  final double pricePerHour;
  final int availableSpaces;
  final double distanceKm;
  final String timeLimit;
  final VoidCallback? onTap;

  const ParkingCard({
    super.key,
    required this.locationId,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 18),
                child: Icon(Icons.local_parking, size: 44, color: Colors.blue),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        FavouriteButton(
                          locationId: locationId,
                          locationTitle: name,
                          locationSubtitle: address,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      address,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$availableSpaces spaces available',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Distance: $distanceKm km',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Time limit: $timeLimit',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Padding(
                padding: const EdgeInsets.only(top: 26),
                child: Text(
                  '\$${pricePerHour.toStringAsFixed(2)}/hr',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
