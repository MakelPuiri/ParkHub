import 'package:flutter/material.dart';
import '../models/favourite_area.dart';
import '../services/favourites_service.dart';

/// A toggle button that saves or removes a location from favourites.
/// Drop this onto any card or detail screen.
class FavouriteButton extends StatefulWidget {
  final String locationId;
  final String locationTitle;
  final String locationSubtitle;
  final String locationType; // 'parking_location' or 'area'

  const FavouriteButton({
    super.key,
    required this.locationId,
    required this.locationTitle,
    required this.locationSubtitle,
    this.locationType = 'parking_location',
  });

  @override
  State<FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<FavouriteButton> {
  final _service = FavouritesService();
  bool _isFavourite = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final result = await _service.isFavourite(widget.locationId);
    if (mounted)
      setState(() {
        _isFavourite = result;
        _loading = false;
      });
  }

  Future<void> _toggle() async {
    if (_loading) return;
    setState(() => _loading = true);

    if (_isFavourite) {
      await _service.removeFavourite(widget.locationId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from favourites.')),
        );
      }
    } else {
      await _service.saveFavourite(
        FavouriteArea(
          id: widget.locationId,
          title: widget.locationTitle,
          subtitle: widget.locationSubtitle,
          type: widget.locationType,
          savedAt: DateTime.now(),
        ),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Saved to favourites!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isFavourite = !_isFavourite;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    return IconButton(
      icon: Icon(
        _isFavourite ? Icons.bookmark : Icons.bookmark_border,
        color: _isFavourite
            ? Theme.of(context).colorScheme.primary
            : Colors.grey,
      ),
      tooltip: _isFavourite ? 'Remove from favourites' : 'Save to favourites',
      onPressed: _toggle,
    );
  }
}
