import 'package:flutter/material.dart';
import '../models/favourite_area.dart';
import '../services/favourites_service.dart';
import '../widgets/favourite_area_card.dart';
import '../widgets/custom_bottom_nav_bar.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  final _service = FavouritesService();
  List<FavouriteArea> _favourites = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _service.getFavouriteAreas();
    if (mounted) {
      setState(() {
        _favourites = data;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourites'),
        automaticallyImplyLeading: false,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _favourites.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'No saved favourites yet.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Tap the bookmark icon on any parking spot to save it.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _favourites.length,
              itemBuilder: (_, index) => FavouriteAreaCard(
                area: _favourites[index],
                // Reload the list after an item is removed
                onRemoved: _load,
              ),
            ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}
