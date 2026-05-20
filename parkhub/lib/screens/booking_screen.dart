// lib/screens/booking_screen.dart
// Sprint 2 — Mock in-app parking payment flow (Feature 2)
// NOTE: This is a MOCK payment screen for Sprint 2 MVP demonstration.
//       No real payment processing is performed.

import 'dart:math';
import 'package:flutter/material.dart';
import '../models/parking_spot.dart';

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
    // Simulate a brief network / processing delay
    await Future.delayed(const Duration(milliseconds: 1800));
    setState(() {
      _isProcessing = false;
      _paymentSuccess = true;
    });
  }

  // -------------------------------------------------------------------------
  // Widgets
  // -------------------------------------------------------------------------

  // ── Booking form view ────────────────────────────────────────────────────
  Widget _buildBookingForm() {
    final spot = widget.spot;
    final statusColor = spot.getAvailabilityColor();
    final status = spot.getAvailabilityStatus();

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
              'Payment Successful',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Your parking has been booked.',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
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
