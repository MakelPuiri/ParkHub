import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';
import '../services/vehicle_service.dart';
import '../services/auth_service.dart';

class VehiclesScreen extends StatefulWidget {
  const VehiclesScreen({super.key});

  @override
  State<VehiclesScreen> createState() => _VehiclesScreenState();
}

class _VehiclesScreenState extends State<VehiclesScreen> {
  final VehicleService _vehicleService = VehicleService();
  final String userId = AuthService().getCurrentUser()?.id ?? '';

  // ── Add or Edit Vehicle Dialog ───────────────────────────────────────────
  void _showVehicleDialog({VehicleModel? vehicle}) {
    final plateController = TextEditingController(text: vehicle?.plateNumber ?? '');
    final labelController = TextEditingController(text: vehicle?.label ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(vehicle == null ? 'Add Vehicle' : 'Edit Vehicle'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: labelController,
              decoration: const InputDecoration(labelText: 'Label (e.g. My Car)'),
            ),
            TextField(
              controller: plateController,
              decoration: const InputDecoration(labelText: 'Plate Number'),
              textCapitalization: TextCapitalization.characters,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final plate = plateController.text.trim().toUpperCase();
              final label = labelController.text.trim();
              if (plate.isEmpty) return;

              setState(() {
                if (vehicle == null) {
                  // Add new vehicle
                  _vehicleService.addVehicle(VehicleModel(
                    id: '',
                    plateNumber: plate,
                    label: label,
                    userId: userId,
                  ));
                } else {
                  // Update existing vehicle
                  _vehicleService.updateVehicle(vehicle.id, plate, label);
                }
              });
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // ── Delete Confirmation Dialog ───────────────────────────────────────────
  void _confirmDelete(String vehicleId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Vehicle'),
        content: const Text('Are you sure you want to remove this vehicle?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                // Remove vehicle from in-memory store
                _vehicleService.deleteVehicle(vehicleId);
              });
              Navigator.pop(ctx);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get all vehicles for current user from in-memory store
    final vehicles = _vehicleService.getUserVehicles(userId);

    return Scaffold(
      appBar: AppBar(title: const Text('My Vehicles')),
      body: vehicles.isEmpty
          ? const Center(child: Text('No vehicles added yet.'))
          : ListView.builder(
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final v = vehicles[index];
                return ListTile(
                  leading: const Icon(Icons.directions_car),
                  title: Text(v.plateNumber),
                  subtitle: Text(v.label),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit button
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showVehicleDialog(vehicle: v),
                      ),
                      // Delete button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(v.id),
                      ),
                    ],
                  ),
                );
              },
            ),
      // Button to add a new vehicle
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showVehicleDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}