// lib/screens/map_screen.dart
// Sprint 2 — Mock real-time availability (Feature 1) + Book Now navigation (Feature 2)

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/parking_spot_model.dart';
import '../models/parking_spot.dart';
import '../services/parking_service.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import 'booking_screen.dart';

// ---------------------------------------------------------------------------
// Sprint 2 mock data — Auckland CBD parking spots
// NOT const so availableSpaces can be mutated by refreshMockAvailability().
// ---------------------------------------------------------------------------
List<ParkingSpot> _buildDemoSpots() => [
  ParkingSpot(
    id: '1',
    name: 'CBD Secure Parking',
    address: '123 Queen Street, Auckland',
    latitude: -36.8485,
    longitude: 174.7633,
    pricePerHour: 4.50,
    availableSpaces: 12,
    isCovered: true,
  ),
  ParkingSpot(
    id: '2',
    name: 'Downtown Car Park',
    address: '89 Customs Street, Auckland',
    latitude: -36.8442,
    longitude: 174.7660,
    pricePerHour: 5.00,
    availableSpaces: 7,
    isCovered: false,
  ),
  ParkingSpot(
    id: '3',
    name: 'Britomart Parking',
    address: '10 Beach Road, Auckland',
    latitude: -36.8448,
    longitude: 174.7695,
    pricePerHour: 6.00,
    availableSpaces: 4,
    isCovered: true,
    hasEvCharging: true,
    evChargersAvailable: 3,
    evChargerType: 'Type 2 Fast Charger',
    evChargingStatus: 'Mock live status: 3 chargers currently available',
  ),
  ParkingSpot(
    id: '4',
    name: 'Victoria St Car Park',
    address: '46 Victoria Street West, Auckland',
    latitude: -36.8500,
    longitude: 174.7610,
    pricePerHour: 3.50,
    availableSpaces: 20,
    isCovered: false,
  ),
  ParkingSpot(
    id: '5',
    name: 'SkyCity Parking',
    address: '71 Federal Street, Auckland',
    latitude: -36.8466,
    longitude: 174.7620,
    pricePerHour: 7.00,
    availableSpaces: 2,
    isCovered: true,
  ),
  ParkingSpot(
    id: '6',
    name: 'Wynyard Quarter Parking',
    address: '12 Jellicoe Street, Auckland',
    latitude: -36.8420,
    longitude: 174.7590,
    pricePerHour: 4.50,
    availableSpaces: 42,
    isCovered: true,
    hasEvCharging: true,
    evChargersAvailable: 4,
    evChargerType: 'Fast Charger',
    evChargingStatus: 'Mock live status: 4 chargers currently available',
  ),
  ParkingSpot(
    id: '7',
    name: 'Viaduct Harbour Parking',
    address: '85 Customs Street West, Auckland',
    latitude: -36.8432,
    longitude: 174.7618,
    pricePerHour: 7.00,
    availableSpaces: 3,
    isCovered: true,
  ),
  ParkingSpot(
    id: '8',
    name: 'Federal Street Parking',
    address: '22 Federal Street, Auckland',
    latitude: -36.8470,
    longitude: 174.7628,
    pricePerHour: 5.50,
    availableSpaces: 14,
    isCovered: true,
  ),
  ParkingSpot(
    id: '9',
    name: 'Shortland Street Parking',
    address: '41 Shortland Street, Auckland',
    latitude: -36.8462,
    longitude: 174.7655,
    pricePerHour: 6.50,
    availableSpaces: 0,
    isCovered: true,
  ),
  ParkingSpot(
    id: '10',
    name: 'Ponsonby Central Parking',
    address: '136 Ponsonby Road, Auckland',
    latitude: -36.8530,
    longitude: 174.7480,
    pricePerHour: 3.00,
    availableSpaces: 38,
    isCovered: false,
  ),
  ParkingSpot(
    id: '11',
    name: 'Newmarket Park & Ride',
    address: '3 Teed Street, Newmarket',
    latitude: -36.8700,
    longitude: 174.7760,
    pricePerHour: 2.00,
    availableSpaces: 85,
    isCovered: false,
    hasEvCharging: true,
    evChargersAvailable: 6,
    evChargerType: 'Standard EV Charger',
    evChargingStatus: 'Mock live status: 6 chargers currently available',
  ),
  ParkingSpot(
    id: '12',
    name: 'Parnell Village Parking',
    address: '280 Parnell Road, Auckland',
    latitude: -36.8560,
    longitude: 174.7770,
    pricePerHour: 3.50,
    availableSpaces: 22,
    isCovered: false,
  ),
  ParkingSpot(
    id: '13',
    name: 'Aotea Centre Parking',
    address: 'Mayoral Drive, Auckland CBD',
    latitude: -36.8520,
    longitude: 174.7622,
    pricePerHour: 5.00,
    availableSpaces: 19,
    isCovered: true,
  ),
  ParkingSpot(
    id: '14',
    name: 'AUT City Campus Parking',
    address: 'Wakefield Street, Auckland CBD',
    latitude: -36.8536,
    longitude: 174.7653,
    pricePerHour: 4.50,
    availableSpaces: 21,
    isCovered: true,
  ),
  ParkingSpot(
    id: '15',
    name: 'Auckland University Parking',
    address: 'Princes Street, Auckland CBD',
    latitude: -36.8507,
    longitude: 174.7690,
    pricePerHour: 4.00,
    availableSpaces: 12,
    isCovered: false,
  ),
  ParkingSpot(
    id: '16',
    name: 'Hobson Street Parking',
    address: 'Hobson Street, Auckland CBD',
    latitude: -36.8498,
    longitude: 174.7588,
    pricePerHour: 3.80,
    availableSpaces: 28,
    isCovered: true,
  ),
  ParkingSpot(
    id: '17',
    name: 'Nelson Street Parking',
    address: 'Nelson Street, Auckland CBD',
    latitude: -36.8509,
    longitude: 174.7564,
    pricePerHour: 3.20,
    availableSpaces: 44,
    isCovered: false,
  ),
  ParkingSpot(
    id: '18',
    name: 'Cook Street Parking',
    address: 'Cook Street, Auckland CBD',
    latitude: -36.8527,
    longitude: 174.7582,
    pricePerHour: 3.70,
    availableSpaces: 9,
    isCovered: false,
  ),
  ParkingSpot(
    id: '19',
    name: 'Fanshawe Street Parking',
    address: 'Fanshawe Street, Auckland CBD',
    latitude: -36.8450,
    longitude: 174.7592,
    pricePerHour: 5.20,
    availableSpaces: 33,
    isCovered: true,
  ),
  ParkingSpot(
    id: '20',
    name: 'Auckland Hospital Parking',
    address: 'Park Road, Grafton',
    latitude: -36.8590,
    longitude: 174.7685,
    pricePerHour: 4.80,
    availableSpaces: 16,
    isCovered: true,
  ),
  ParkingSpot(
    id: '21',
    name: 'Grafton Bridge Parking',
    address: 'Grafton Road, Auckland',
    latitude: -36.8563,
    longitude: 174.7669,
    pricePerHour: 3.90,
    availableSpaces: 7,
    isCovered: false,
  ),
  ParkingSpot(
    id: '22',
    name: 'Myers Park Parking',
    address: 'Greys Avenue, Auckland CBD',
    latitude: -36.8550,
    longitude: 174.7614,
    pricePerHour: 3.00,
    availableSpaces: 15,
    isCovered: false,
  ),
  ParkingSpot(
    id: '23',
    name: 'Eden Terrace Parking',
    address: 'New North Road, Eden Terrace',
    latitude: -36.8662,
    longitude: 174.7581,
    pricePerHour: 2.80,
    availableSpaces: 40,
    isCovered: false,
  ),
  ParkingSpot(
    id: '24',
    name: 'Freemans Bay Parking',
    address: 'Wellington Street, Freemans Bay',
    latitude: -36.8500,
    longitude: 174.7522,
    pricePerHour: 3.30,
    availableSpaces: 24,
    isCovered: false,
  ),
  ParkingSpot(
    id: '25',
    name: 'Sale Street Parking',
    address: 'Sale Street, Auckland CBD',
    latitude: -36.8469,
    longitude: 174.7550,
    pricePerHour: 4.20,
    availableSpaces: 11,
    isCovered: true,
  ),
  ParkingSpot(
    id: '26',
    name: 'Quay Street Parking',
    address: 'Quay Street, Auckland CBD',
    latitude: -36.8431,
    longitude: 174.7662,
    pricePerHour: 6.20,
    availableSpaces: 31,
    isCovered: true,
    hasEvCharging: true,
    evChargersAvailable: 2,
    evChargerType: 'Type 2 Charger',
    evChargingStatus: 'Mock live status: 2 chargers currently available',
  ),
  ParkingSpot(
    id: '27',
    name: 'Ferry Terminal Parking',
    address: '99 Quay Street, Auckland CBD',
    latitude: -36.8419,
    longitude: 174.7683,
    pricePerHour: 6.80,
    availableSpaces: 5,
    isCovered: true,
  ),
  ParkingSpot(
    id: '28',
    name: 'Spark Arena Parking',
    address: 'Mahuhu Crescent, Auckland',
    latitude: -36.8471,
    longitude: 174.7767,
    pricePerHour: 5.80,
    availableSpaces: 50,
    isCovered: false,
    hasEvCharging: true,
    evChargersAvailable: 5,
    evChargerType: 'Fast Charger',
    evChargingStatus: 'Mock live status: 5 chargers currently available',
  ),
  ParkingSpot(
    id: '29',
    name: 'Mount Eden Station Parking',
    address: 'Mount Eden Road, Auckland',
    latitude: -36.8668,
    longitude: 174.7616,
    pricePerHour: 2.50,
    availableSpaces: 36,
    isCovered: false,
  ),
  ParkingSpot(
    id: '30',
    name: 'Kingsland Parking',
    address: 'New North Road, Kingsland',
    latitude: -36.8715,
    longitude: 174.7460,
    pricePerHour: 2.20,
    availableSpaces: 18,
    isCovered: false,
  ),
];

// ---------------------------------------------------------------------------
// Filter chip model
// ---------------------------------------------------------------------------
enum _Filter { cheapest, closest, available, covered, evCharging }

// ---------------------------------------------------------------------------
// MapScreen
// ---------------------------------------------------------------------------
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Map & location state
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  bool _isLoading = true;

  // Sprint 2 — mutable spot list managed in state so refresh rebuilds markers
  late List<ParkingSpot> _allSpots;

  // Filters
  final Set<_Filter> _activeFilters = {};

  // Computed / visible spots (after filter)
  List<ParkingSpot> _visibleSpots = [];

  // Selected spot for the bottom info card
  ParkingSpot? _selectedSpot;

  // Tracks when we last refreshed (shown in detail card)
  String _lastUpdated = 'Just now';

  // -------------------------------------------------------------------------
  // Lifecycle
  // -------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _allSpots = _buildDemoSpots();
    _visibleSpots = List.of(_allSpots);

    // Auckland CBD only — do not ask for user's live location.
    _currentLocation = const LatLng(-36.8485, 174.7633);
    _isLoading = false;
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // Location
  // -------------------------------------------------------------------------
  Future<void> _getLocation() async {
    setState(() => _isLoading = true);

    if (!await Geolocator.isLocationServiceEnabled()) {
      _showMessage('Location services are off.');
      setState(() => _isLoading = false);
      return;
    }

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) {
      _showMessage('Location permission denied.');
      setState(() => _isLoading = false);
      return;
    }

    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(pos.latitude, pos.longitude);
      _isLoading = false;
    });

    _mapController.move(_currentLocation!, 14.5);
  }

  // -------------------------------------------------------------------------
  // Sprint 2 — Mock refresh
  // -------------------------------------------------------------------------
  void _refreshAvailability() {
    ParkingService.refreshMockAvailability(_allSpots);
    _applyFilters(); // re-filter in case "Available Now" is active
    setState(() {
      _lastUpdated = 'Just now';
      // Keep the selected spot reference up to date
      if (_selectedSpot != null) {
        _selectedSpot = _allSpots.firstWhere(
          (s) => s.id == _selectedSpot!.id,
          orElse: () => _selectedSpot!,
        );
      }
    });
    _showMessage('Mock availability updated');
  }

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------
  double _distanceKm(ParkingSpot spot) {
    if (_currentLocation == null) return 0;
    return Geolocator.distanceBetween(
          _currentLocation!.latitude,
          _currentLocation!.longitude,
          spot.latitude,
          spot.longitude,
        ) /
        1000;
  }

  void _applyFilters() {
    List<ParkingSpot> result = List.of(_allSpots);

    if (_activeFilters.contains(_Filter.available)) {
      result = result.where((s) => s.availableSpaces > 0).toList();
    }
    if (_activeFilters.contains(_Filter.covered)) {
      result = result.where((s) => s.isCovered).toList();
    }
    if (_activeFilters.contains(_Filter.evCharging)) {
      result = result.where((s) => s.hasEvCharging).toList();
    }
    if (_activeFilters.contains(_Filter.cheapest)) {
      result.sort((a, b) => a.pricePerHour.compareTo(b.pricePerHour));
    }
    if (_activeFilters.contains(_Filter.closest)) {
      result.sort((a, b) => _distanceKm(a).compareTo(_distanceKm(b)));
    }

    setState(() => _visibleSpots = result);
  }

  void _toggleFilter(_Filter filter) {
    setState(() {
      if (_activeFilters.contains(filter)) {
        _activeFilters.remove(filter);
      } else {
        _activeFilters.add(filter);
      }
    });
    _applyFilters();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openNavigation(ParkingSpot spot) async {
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${spot.latitude},${spot.longitude}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      _showMessage('Could not open Google Maps.');
    }
  }

  // Sprint 2 — navigate to the booking screen passing the selected spot
  void _goToBooking(ParkingSpot spot) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BookingScreen(spot: spot)),
    );
  }

  // -------------------------------------------------------------------------
  // Markers — Sprint 2: colour based on availability
  // -------------------------------------------------------------------------
  List<Marker> _buildMarkers() {
    final markers = <Marker>[];

    // User location marker
    if (_currentLocation != null) {
      markers.add(
        Marker(
          point: _currentLocation!,
          width: 56,
          height: 56,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue.shade300, width: 1.5),
            ),
            child: Center(
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Parking spot markers — colour driven by getAvailabilityColor()
    for (final spot in _visibleSpots) {
      final isSelected = _selectedSpot?.id == spot.id;
      final markerColor = spot.getAvailabilityColor();

      markers.add(
        Marker(
          point: LatLng(spot.latitude, spot.longitude),
          width: isSelected ? 62 : 52,
          height: isSelected ? 62 : 52,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _selectedSpot = (_selectedSpot?.id == spot.id) ? null : spot;
              });
              _mapController.move(LatLng(spot.latitude, spot.longitude), 15.0);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: markerColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: isSelected ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: markerColor.withOpacity(0.4),
                    blurRadius: isSelected ? 14 : 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                 spot.hasEvCharging ? '⚡' : 'P',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: isSelected ? 26 : 22,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return markers;
  }

  // -------------------------------------------------------------------------
  // Widgets
  // -------------------------------------------------------------------------

  // Search bar overlay
  Widget _buildSearchBar() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 12,
      right: 12,
      child: Material(
        elevation: 6,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              Icon(Icons.menu, color: Colors.grey.shade600, size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Search parking near you',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Icon(Icons.search, color: Colors.grey.shade600, size: 22),
              const SizedBox(width: 14),
            ],
          ),
        ),
      ),
    );
  }

  // Filter chips overlay
  Widget _buildFilterChips() {
    final chips = [
      (_Filter.cheapest, 'Cheapest', Icons.attach_money),
      (_Filter.closest, 'Closest', Icons.near_me),
      (_Filter.available, 'Available Now', Icons.check_circle_outline),
      (_Filter.covered, 'Covered', Icons.garage_outlined),
      (_Filter.evCharging, 'EV Charging', Icons.electric_bolt),
    ];

    return Positioned(
      top: MediaQuery.of(context).padding.top + 68,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          scrollDirection: Axis.horizontal,
          itemCount: chips.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, i) {
            final (filter, label, icon) = chips[i];
            final active = _activeFilters.contains(filter);
            return GestureDetector(
              onTap: () => _toggleFilter(filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: active ? const Color(0xFF1A7F4B) : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.13),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 14,
                      color: active ? Colors.white : Colors.grey.shade700,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: active ? Colors.white : Colors.grey.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Bottom ambient card (no spot selected)
  Widget _buildAmbientCard() {
    return Positioned(
      bottom: 96,
      left: 12,
      right: 12,
      child: Material(
        elevation: 5,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A7F4B).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.local_parking,
                  color: Color(0xFF1A7F4B),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Auckland CBD',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    '${_visibleSpots.length} parking spots nearby',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
              const Spacer(),
              // Sprint 2 — Refresh button in ambient card
              TextButton.icon(
                onPressed: _refreshAvailability,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Refresh', style: TextStyle(fontSize: 13)),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF1A7F4B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Sprint 2 — Status badge widget
  Widget _statusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Sprint 2 — Full detail card with availability status, last updated, Book Now
  Widget _buildDetailCard(ParkingSpot spot) {
    final distance = _distanceKm(spot);
    final status = spot.getAvailabilityStatus();
    final statusColor = spot.getAvailabilityColor();
    final isFull = spot.availableSpaces == 0;

    return Positioned(
      bottom: 88,
      left: 12,
      right: 12,
      child: Material(
        elevation: 10,
        shadowColor: Colors.black38,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              const SizedBox(height: 10),
              Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.local_parking,
                            color: statusColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                spot.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                spot.address,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _selectedSpot = null),
                          child: Icon(
                            Icons.close,
                            color: Colors.grey.shade400,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Sprint 2 — Status row: badge + last updated
                    Row(
                      children: [
                        _statusBadge(status, statusColor),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.access_time,
                          size: 13,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Last updated: $_lastUpdated',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        const Spacer(),
                        // Inline refresh button
                        GestureDetector(
                          onTap: _refreshAvailability,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A7F4B).withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.refresh,
                                  size: 13,
                                  color: Color(0xFF1A7F4B),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  'Refresh',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF1A7F4B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Info tiles
                    Row(
                      children: [
                        _infoTile(
                          Icons.attach_money,
                          'Price',
                          '\$${spot.pricePerHour.toStringAsFixed(2)}/hr',
                          Colors.blue.shade50,
                          Colors.blue.shade700,
                        ),
                        const SizedBox(width: 8),
                        _infoTile(
                          Icons.local_parking,
                          'Spaces',
                          isFull ? 'Full' : '${spot.availableSpaces}',
                          statusColor.withOpacity(0.1),
                          statusColor,
                        ),
                        const SizedBox(width: 8),
                        _infoTile(
                          Icons.near_me,
                          'Distance',
                          '${distance.toStringAsFixed(2)} km',
                          Colors.purple.shade50,
                          Colors.purple.shade700,
                        ),
                        const SizedBox(width: 8),
                        _infoTile(
                          spot.isCovered
                              ? Icons.garage_outlined
                              : Icons.wb_sunny_outlined,
                          'Type',
                          spot.isCovered ? 'Covered' : 'Open',
                          Colors.amber.shade50,
                          Colors.amber.shade700,
                        ),
                      ],
                    ),
                    if (spot.hasEvCharging) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green.shade200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.electric_bolt,
                                color: Colors.green.shade800,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'EV Charging Available',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade800,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${spot.evChargersAvailable} chargers free • ${spot.evChargerType}',
                                    style: TextStyle(
                                      color: Colors.green.shade700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    // Sprint 2 — Full warning banner
                    if (isFull) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.red.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red.shade600,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'This car park is currently full.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 14),

                    // Action buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _openNavigation(spot),
                            icon: const Icon(Icons.directions, size: 18),
                            label: const Text('Navigate'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              foregroundColor: const Color(0xFF1A7F4B),
                              side: const BorderSide(
                                color: Color(0xFF1A7F4B),
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            // Sprint 2 — disable Book Now when full
                            onPressed: isFull ? null : () => _goToBooking(spot),
                            icon: const Icon(Icons.calendar_month, size: 18),
                            label: Text(isFull ? 'Full' : 'Book Now'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              backgroundColor: isFull
                                  ? Colors.grey.shade300
                                  : const Color(0xFF1A7F4B),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Compact stat tile used inside the detail card
  Widget _infoTile(
    IconData icon,
    String label,
    String value,
    Color bg,
    Color fg,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: fg),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: fg.withOpacity(0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    const aucklandCbd = LatLng(-36.8485, 174.7633);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // ── Map ──────────────────────────────────────────────────────
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: aucklandCbd,
                    initialZoom: 14.5,
                    onTap: (_, __) => setState(() => _selectedSpot = null),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                      subdomains: const ['a', 'b', 'c', 'd'],
                      userAgentPackageName: 'com.example.parkhub',
                    ),
                    MarkerLayer(markers: _buildMarkers()),
                  ],
                ),

                // ── Search bar ───────────────────────────────────────────────
                _buildSearchBar(),

                // ── Filter chips ─────────────────────────────────────────────
                _buildFilterChips(),

                // ── My location FAB ──────────────────────────────────────────
                // ── Auckland CBD location FAB ──────────────────────────────────────────
                Positioned(
                  right: 14,
                  bottom: _selectedSpot != null ? 420 : 160,
                  child: FloatingActionButton(
                    heroTag: 'location_fab',
                    mini: true,
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1A7F4B),
                    elevation: 4,
                    onPressed: () {
                      _mapController.move(
                        const LatLng(-36.8485, 174.7633),
                        14.5,
                      );
                    },
                    child: const Icon(Icons.my_location, size: 20),
                  ),
                ),

                // ── Bottom card: detail OR ambient ───────────────────────────
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  transitionBuilder: (child, anim) => SlideTransition(
                    position:
                        Tween<Offset>(
                          begin: const Offset(0, 0.3),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: anim,
                            curve: Curves.easeOutCubic,
                          ),
                        ),
                    child: FadeTransition(opacity: anim, child: child),
                  ),
                  child: _selectedSpot != null
                      ? _buildDetailCard(_selectedSpot!)
                      : _buildAmbientCard(),
                ),
              ],
            ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 3),
    );
  }
}
