import 'package:flutter/material.dart';
import '../services/parking_service.dart';

class ParkingListScreen extends StatelessWidget {
  const ParkingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Grab the percentage from your service
    final double overallPercent = ParkingService.overallAvailabilityPercentage;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Auckland Parking Spots'),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
      ),
      body: Column(
        children: [
          // THE BLUE HEADER SECTION
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade800,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // THIS STACK IS WHAT PUTS THE TEXT INSIDE THE CIRCLE
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 80,
                      height: 80,
                      child: CircularProgressIndicator(
                        value: overallPercent / 100,
                        strokeWidth: 10,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                      ),
                    ),
                    // This Text is now correctly layered inside the Stack
                    Text(
                      "${overallPercent.toStringAsFixed(0)}%",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overall Availability',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Text(
                      'Available Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // LIST HEADER
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Parking Spots near you",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // THE LIST
          Expanded(
            child: ListView.builder(
              // We pass an empty string to get all spots from your service
              itemCount: ParkingService.searchByLocation("").isEmpty 
                  ? 4 // Fallback if search returns empty initially
                  : ParkingService.searchByLocation("").length,
              itemBuilder: (context, index) {
                // Since your searchByLocation needs a query, we'll use a placeholder or 
                // you can create a getAllSpots() method in your service.
                // For now, let's use the first 4 spots manually or from search.
                final spots = ParkingService.searchByLocation(""); 
                // If search is empty (because query is empty), we can't see the list.
                // PRO TIP: Add a 'static List<ParkingSpotModel> get allSpots => _parkingSpots;' to your service!
                
                // Let's assume you added that getter or use the search result
                if (spots.isEmpty) return const SizedBox(); 
                
                final spot = spots[index];
                double spotPercent = (spot.availableSpaces / spot.totalSpaces) * 100;

                return ListTile(
                  leading: const Icon(Icons.local_parking, color: Colors.blue),
                  title: Text(spot.name),
                  subtitle: Text("${spot.availableSpaces} / ${spot.totalSpaces} spots free"),
                  trailing: Text(
                    "${spotPercent.toStringAsFixed(1)}%",
                    style: const TextStyle(
                      color: Colors.green, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}