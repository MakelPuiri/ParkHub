import '../models/favourite_area.dart';

/// Manages saving and removing favourite areas.
/// Uses in-memory storage for MVP.
/// TODO: Replace _favourites list with Supabase/API calls when backend is ready.
class FavouritesService {
  // Singleton so all screens share the same in-memory list.
  static final FavouritesService _instance = FavouritesService._internal();
  factory FavouritesService() => _instance;
  FavouritesService._internal();

  final List<FavouriteArea> _favourites = [];

  /// Returns the current list of saved favourites, newest first.
  Future<List<FavouriteArea>> getFavouriteAreas() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_favourites)
      ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  /// Saves an area to favourites (ignores duplicate IDs).
  Future<void> saveFavourite(FavouriteArea area) async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!_favourites.any((f) => f.id == area.id)) {
      _favourites.add(area);
    }
  }

  /// Removes a favourite by its ID.
  Future<void> removeFavourite(String favouriteId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _favourites.removeWhere((f) => f.id == favouriteId);
  }

  /// Returns true if an item with this ID is already saved.
  Future<bool> isFavourite(String id) async {
    return _favourites.any((f) => f.id == id);
  }
}
