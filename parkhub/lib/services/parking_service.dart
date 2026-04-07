import '../models/parking_spot_model.dart';

class ParkingService {
  Future<List<ParkingSpotModel>> getAllParkingSpots() async {
    // TODO: implement getAllParkingSpots
    return [];
  }

  Future<List<ParkingSpotModel>> searchByLocation(String location) async {
    // TODO: implement searchByLocation
    return [];
  }

  Future<List<ParkingSpotModel>> searchByCoordinates(
    double latitude,
    double longitude, {
    double radiusKm = 1.0,
  }) async {
    // TODO: implement searchByCoordinates
    return [];
  }

  Future<ParkingSpotModel?> getParkingSpotById(String id) async {
    // TODO: implement getParkingSpotById
    return null;
  }
}
