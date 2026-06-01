import 'dart:math';
import 'package:flutter/material.dart';
import 'package:parkhub/models/notifications_types.dart';
import 'package:parkhub/services/in_app_notification_service.dart';
import '../models/parking_spot.dart';
import '../models/vehicle_model.dart';
import '../services/vehicle_service.dart';
import '../services/auth_service.dart';
import '../services/reward_service.dart';
import '../app/routes.dart';
import '../services/notification_service.dart';

// ---------------------------------------------------------------------------
// BookingScreen
// ---------------------------------------------------------------------------
class BookingScreen extends StatefulWidget {
  /// The parking spot passed from MapScreen when the user taps "Book Now".
  final ParkingSpot spot;

  const BookingScreen({super.key, required this.spot});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // Duration options (hours)
  static const List<int> _durationOptions = [1, 2, 3, 4];
  int _selectedDuration = 1;

  // Mock payment state
  bool _isProcessing = false;
  bool _paymentSuccess = false;
  late String _referenceNumber;
  int _earnedPoints = 0;
  bool _pointsAdded = false;
  bool _bookingNotificationShown = false;

  // Vehicle selection
  VehicleModel? _selectedVehicle;
  final VehicleService _vehicleService = VehicleService();
  final String _userId = AuthService().getCurrentUser()?.id ?? '';

  @override
  void initState() {
    super.initState();
    // Generate a mock booking reference (e.g. PH-38472)
    _referenceNumber = 'PH-${Random().nextInt(90000) + 10000}';
  }

  // -------------------------------------------------------------------------
  // Computed values
  // -------------------------------------------------------------------------
  double get _totalPrice => widget.spot.pricePerHour * _selectedDuration;

  // -------------------------------------------------------------------------
  // Mock payment
  // -------------------------------------------------------------------------
  Future<void> _handlePayNow() async {
    setState(() => _isProcessing = true);

    await Future.delayed(const Duration(milliseconds: 1800));

    if (!_pointsAdded) {
      _earnedPoints = RewardService().addParkingActivity(
        widget.spot,
        _selectedDuration,
      );
      _pointsAdded = true;

      InAppNotificationService.show(
        context,
        title: 'Reward Earned',
        message: '+$_earnedPoints ParkHub points earned',
        icon: Icons.stars_rounded,
        color: Colors.amber.shade700,
      );
    }

    setState(() {
      _isProcessing = false;
      _paymentSuccess = true;
    });

    InAppNotificationService.show(
      context,
      title: 'Booking Confirmed',
      message:
          '${widget.spot.name} booked for $_selectedDuration hour${_selectedDuration > 1 ? 's' : ''}',
      icon: Icons.check_circle,
      color: const Color(0xFF1A7F4B),
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          elevation: 8,
          duration: const Duration(seconds: 4),
          backgroundColor: const Color(0xFF1A7F4B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 26),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Confirmed',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${widget.spot.name} booked successfully',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          //Action Button to extend booking (for demo purposes)
          action: SnackBarAction(
            label: 'Extend',
            textColor: Colors.white,
            onPressed: () {
              // Example: extend booking by 1 hour
              setState(() {
                _selectedDuration += 1;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking extended by 1 hour'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ),
      );
    }
  }

  // -------------------------------------------------------------------------
  // Widgets
  // -------------------------------------------------------------------------

  // ── Booking form view ────────────────────────────────────────────────────
  Widget _buildBookingForm() {
    final spot = widget.spot;
    final statusColor = spot.getAvailabilityColor();
    final status = spot.getAvailabilityStatus();

    // Get vehicles for current user
    final vehicles = _vehicleService.getUserVehicles(_userId);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Car park card ────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        size: 22,
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
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            spot.address,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1),
                const SizedBox(height: 14),
                // Info row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _detailChip(
                      Icons.attach_money,
                      '\$${spot.pricePerHour.toStringAsFixed(2)}/hr',
                      Colors.blue,
                    ),
                    _detailChip(
                      Icons.local_parking,
                      '${spot.availableSpaces} spaces',
                      statusColor,
                    ),
                    _detailChip(
                      spot.isCovered
                          ? Icons.garage_outlined
                          : Icons.wb_sunny_outlined,
                      spot.isCovered ? 'Covered' : 'Open',
                      Colors.amber.shade700,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Status badge
                _statusBadge(status, statusColor),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Vehicle selector ─────────────────────────────────────────────
          const Text(
            'Select Vehicle',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          vehicles.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange.shade700),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'No vehicles added yet. Add one in your Profile.',
                          style: TextStyle(color: Colors.orange.shade800),
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<VehicleModel>(
                      value: _selectedVehicle,
                      isExpanded: true,
                      hint: const Text('Choose your vehicle'),
                      items: vehicles
                          .map(
                            (v) => DropdownMenuItem(
                              value: v,
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.directions_car,
                                    size: 18,
                                    color: Color(0xFF1A7F4B),
                                  ),
                                  const SizedBox(width: 8),
                                  Text('${v.label} — ${v.plateNumber}'),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _selectedVehicle = v),
                    ),
                  ),
                ),

          const SizedBox(height: 24),

          // ── Duration selector ────────────────────────────────────────────
          const Text(
            'Select Duration',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: _durationOptions.map((hours) {
              final isSelected = _selectedDuration == hours;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedDuration = hours),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF1A7F4B)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF1A7F4B)
                              : Colors.grey.shade200,
                          width: 1.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF1A7F4B,
                                  ).withOpacity(0.25),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : [],
                      ),
                      child: Column(
                        children: [
                          Text(
                            '$hours',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade800,
                            ),
                          ),
                          Text(
                            hours == 1 ? 'hour' : 'hours',
                            style: TextStyle(
                              fontSize: 11,
                              color: isSelected
                                  ? Colors.white70
                                  : Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // ── Price summary ────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _summaryRow(
                  'Rate per hour',
                  '\$${spot.pricePerHour.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 10),
                _summaryRow(
                  'Duration',
                  '$_selectedDuration ${_selectedDuration == 1 ? "hour" : "hours"}',
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Divider(height: 1),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${_totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A7F4B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ── Pay Now button ───────────────────────────────────────────────
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _handlePayNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A7F4B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: _isProcessing
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Pay Now',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          const SizedBox(height: 12),
          // Mock payment notice
          Center(
            child: Text(
              '🔒 Mock payment — Sprint 2 demo only',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── Payment success view ─────────────────────────────────────────────────
  Widget _buildSuccessView() {
    final spot = widget.spot;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success icon
            Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                color: const Color(0xFF1A7F4B).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF1A7F4B),
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Mock Parking Activity Complete',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Your simulated parking activity has been recorded.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.stars_rounded, color: Colors.amber.shade800),
                  const SizedBox(width: 8),
                  Text(
                    '+$_earnedPoints ParkHub points earned',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber.shade900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Booking summary card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _confirmRow(
                    Icons.location_on_outlined,
                    'Location',
                    spot.name,
                  ),
                  const Divider(height: 20),
                  _confirmRow(
                    Icons.access_time,
                    'Duration',
                    '$_selectedDuration ${_selectedDuration == 1 ? "hour" : "hours"}',
                  ),
                  const Divider(height: 20),
                  // ── Selected vehicle shown on confirmation ───────────────
                  _confirmRow(
                    Icons.directions_car,
                    'Vehicle',
                    _selectedVehicle != null
                        ? '${_selectedVehicle!.label} — ${_selectedVehicle!.plateNumber}'
                        : 'No vehicle selected',
                  ),
                  const Divider(height: 20),
                  _confirmRow(
                    Icons.attach_money,
                    'Total Paid',
                    '\$${_totalPrice.toStringAsFixed(2)}',
                    valueColor: const Color(0xFF1A7F4B),
                  ),
                  const Divider(height: 20),
                  _confirmRow(
                    Icons.confirmation_number_outlined,
                    'Reference',
                    _referenceNumber,
                    valueColor: Colors.blue.shade700,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Back to Map button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.map_outlined, size: 20),
                label: const Text(
                  'Back to Map',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A7F4B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.profile,
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.card_giftcard, size: 20),
                label: const Text(
                  'View My Rewards',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1A7F4B),
                  side: const BorderSide(color: Color(0xFF1A7F4B)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helper widgets ───────────────────────────────────────────────────────

  Widget _detailChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.35)),
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

  Widget _summaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _confirmRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade400),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: valueColor ?? Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _paymentSuccess
          ? null
          : AppBar(
              title: const Text(
                'Book a Spot',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 0,
              surfaceTintColor: Colors.white,
              centerTitle: true,
            ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _paymentSuccess ? _buildSuccessView() : _buildBookingForm(),
      ),
    );
  }
}
