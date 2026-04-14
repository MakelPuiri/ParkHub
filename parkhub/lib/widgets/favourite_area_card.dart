import 'package:flutter/material.dart';
import '../models/favourite_area.dart';
import '../services/favourites_service.dart';

/// Displays a saved favourite area with a remove action.
class FavouriteAreaCard extends StatelessWidget {
  final FavouriteArea area;
  final VoidCallback onRemoved;

  const FavouriteAreaCard({
    super.key,
    required this.area,
    required this.onRemoved,
  });

  Future<void> _remove(BuildContext context) async {
    await FavouritesService().removeFavourite(area.id);
    onRemoved();
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Removed from favourites.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            area.type == 'parking_location'
                ? Icons.local_parking
                : Icons.place_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          area.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          area.subtitle,
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.bookmark_remove_outlined, color: Colors.red),
          tooltip: 'Remove favourite',
          onPressed: () => _remove(context),
        ),
      ),
    );
  }
}
