// lib/screens/map_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/parking_spot.dart';
import '../widgets/custom_bottom_nav_bar.dart';

// ---------------------------------------------------------------------------
// Demo data — Auckland CBD parking spots
// ---------------------------------------------------------------------------
const List<ParkingSpot> _kDemoSpots = [
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
    name: 'Sky City Parking',
    address: '71 Federal Street, Auckland',
    latitude: -36.8466,
    longitude: 174.7620,
    pricePerHour: 7.00,
    availableSpaces: 2,
    isCovered: true,
  ),
];

// ---------------------------------------------------------------------------
// Filter chip model
// ---------------------------------------------------------------------------
enum _Filter { cheapest, closest, available, covered }

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

  // Filters
  final Set<_Filter> _activeFilters = {};

  // Computed / visible spots (after filter)
  List<ParkingSpot> _visibleSpots = List.of(_kDemoSpots);

  // Selected spot for the bottom info card
  ParkingSpot? _selectedSpot;

  // -------------------------------------------------------------------------
  // Lifecycle
  // -------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _getLocation();
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
    List<ParkingSpot> result = List.of(_kDemoSpots);

    if (_activeFilters.contains(_Filter.available)) {
      result = result.where((s) => s.availableSpaces > 0).toList();
    }
    if (_activeFilters.contains(_Filter.covered)) {
      result = result.where((s) => s.isCovered).toList();
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

  // -------------------------------------------------------------------------
  // Markers
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

    // Parking spot markers
    for (final spot in _visibleSpots) {
      final isSelected = _selectedSpot?.id == spot.id;
      final isLow = spot.availableSpaces <= 3;

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
                color: isLow ? Colors.orange.shade600 : const Color(0xFF1A7F4B),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: isSelected ? 3 : 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isLow ? Colors.orange : Colors.green).withOpacity(
                      0.35,
                    ),
                    blurRadius: isSelected ? 14 : 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'P',
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

  // Bottom info card overlay (ambient / no spot selected)
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
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  // Bottom detail card (when a spot is selected)
  Widget _buildDetailCard(ParkingSpot spot) {
    final distance = _distanceKm(spot);
    final isLow = spot.availableSpaces <= 3;

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
                            color: const Color(0xFF1A7F4B).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.local_parking,
                            color: Color(0xFF1A7F4B),
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
                    const SizedBox(height: 14),

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
                          '${spot.availableSpaces}',
                          isLow ? Colors.orange.shade50 : Colors.green.shade50,
                          isLow
                              ? Colors.orange.shade700
                              : const Color(0xFF1A7F4B),
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
                    const SizedBox(height: 16),

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
                            onPressed: () {
                              setState(() => _selectedSpot = null);
                              _showMessage('Booking ${spot.name}…');
                            },
                            icon: const Icon(Icons.calendar_month, size: 18),
                            label: const Text('Book Now'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              backgroundColor: const Color(0xFF1A7F4B),
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
      // No AppBar — full screen map like Google Maps
      extendBodyBehindAppBar: true,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                // ── Map ──────────────────────────────────────────────────────
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentLocation ?? aucklandCbd,
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
                Positioned(
                  right: 14,
                  bottom: _selectedSpot != null ? 380 : 160,
                  child: FloatingActionButton(
                    heroTag: 'location_fab',
                    mini: true,
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF1A7F4B),
                    elevation: 4,
                    onPressed: () {
                      if (_currentLocation != null) {
                        _mapController.move(_currentLocation!, 14.5);
                      } else {
                        _getLocation();
                      }
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
