import 'package:flutter/material.dart';
import '../models/parking_spot_model.dart';
import '../services/parking_service.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/parking_card.dart';
import 'parking_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ParkingSpotModel> _searchResults = [];
  List<ParkingSpotModel> _filteredSpots = [];
  double _maxPrice = 20.0;


  void _handleSearch() {
    final query = _searchController.text;
    final results = ParkingService.searchByLocation(query);

    setState(() {
      _searchResults = results;
      });
      _applyFilters();
  }

  void _applyFilters() {
    setState((){
      _filteredSpots = _searchResults.where((spot) => 
      spot.pricePerHour <= _maxPrice && 
      spot.isAvailable &&
      spot.availableSpaces > 0)
      .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Parking'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search location...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _handleSearch,
                  child: const Text('Search'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            if (_searchResults.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Max Price',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                    Text(
                      '\$${_maxPrice.toStringAsFixed(0)}/hr',
                      style: const TextStyle(
                        color: Colors.blue, 
                        fontWeight: FontWeight.bold,
                        ),
                    ),
                  ],
                ),
                Slider(
                value: _maxPrice, 
                min: 0, 
                max: 50, 
                divisions: 50, 
                label: '\$${_maxPrice.toStringAsFixed(0)}/hr',
                onChanged: (value){
                  _maxPrice = value;
                  _applyFilters();
                },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('\$0', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    Text('\$50', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ],
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Search Results',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _searchResults.isEmpty
                  ? const Center(
                      child: Text(
                        'Enter a destination to search for parking.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      itemCount: _filteredSpots.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final spot = _filteredSpots[index];
                        return ParkingCard(
                          locationId: spot.id,
                          name: spot.name,
                          address: spot.address,
                          pricePerHour: spot.pricePerHour,
                          availableSpaces: spot.availableSpaces,
                          totalSpaces: spot.totalSpaces,
                          distanceKm: spot.distanceKm,
                          timeLimit: spot.timeLimit,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ParkingDetailScreen(spot: spot),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
    );
  }
}
