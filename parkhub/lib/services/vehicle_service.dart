import '../models/vehicle_model.dart';

/// Handles vehicle storage for ParkHub.
/// Uses in-memory mock storage for MVP.
/// TODO: Replace mock logic with Supabase when backend is connected.
class VehicleService {
  // Singleton so the same vehicle store is shared across the app.
  static final VehicleService _instance = VehicleService._internal();
  factory VehicleService() => _instance;
  VehicleService._internal();

  // In-memory vehicle store (id → VehicleModel).
  final List<VehicleModel> _vehicles = [];

  // ── Get all vehicles for a user ──────────────────────────────────────────
  List<VehicleModel> getUserVehicles(String userId) {
    return _vehicles.where((v) => v.userId == userId).toList();
  }

  // ── Add a vehicle ────────────────────────────────────────────────────────
  void addVehicle(VehicleModel vehicle) {
    final newVehicle = VehicleModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      plateNumber: vehicle.plateNumber,
      label: vehicle.label,
      userId: vehicle.userId,
    );
    _vehicles.add(newVehicle);
  }

  // ── Update a vehicle ─────────────────────────────────────────────────────
  void updateVehicle(String vehicleId, String plateNumber, String label) {
    final index = _vehicles.indexWhere((v) => v.id == vehicleId);
    if (index != -1) {
      _vehicles[index] = VehicleModel(
        id: vehicleId,
        plateNumber: plateNumber,
        label: label,
        userId: _vehicles[index].userId,
      );
    }
  }

  // ── Delete a vehicle ─────────────────────────────────────────────────────
  void deleteVehicle(String vehicleId) {
    _vehicles.removeWhere((v) => v.id == vehicleId);
  }
}