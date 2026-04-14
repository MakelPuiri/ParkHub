class FavouriteArea {
  final String id;
  final String title;
  final String subtitle;
  final String type; // 'area' or 'parking_location'
  final String? imageUrl;
  final DateTime savedAt;

  const FavouriteArea({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.type,
    this.imageUrl,
    required this.savedAt,
  });

  @override
  bool operator ==(Object other) => other is FavouriteArea && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
