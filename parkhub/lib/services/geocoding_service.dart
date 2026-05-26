import 'package:geocoding/geocoding.dart';

class GeocodingService {
  static Future<Location?> searchLocation(String query) async {
    if (query.isEmpty) return null;

    final locations = await locationFromAddress(query);

    if (locations.isEmpty) return null;

    return locations.first;
  }
}