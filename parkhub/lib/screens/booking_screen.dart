import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book a Spot')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Booking Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // TODO: Display real ParkingSpotModel passed via route arguments
            const ListTile(
              leading: Icon(Icons.local_parking),
              title: Text('Parking Spot Name'),
              subtitle: Text('123 Sample Street, Auckland'),
            ),
            const Divider(),
            // TODO: Add real date/time pickers
            const ListTile(
              leading: Icon(Icons.access_time),
              title: Text('Start Time'),
              subtitle: Text('[Time picker placeholder]'),
            ),
            const ListTile(
              leading: Icon(Icons.access_time_filled),
              title: Text('End Time'),
              subtitle: Text('[Time picker placeholder]'),
            ),
            const Divider(),
            const ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Estimated Cost'),
              subtitle: Text('\$0.00'),
            ),
            const Spacer(),
            PrimaryButton(
              label: 'Confirm Booking',
              onPressed: () {
                // TODO: Call BookingService.createBooking() and show confirmation
              },
            ),
          ],
        ),
      ),
    );
  }
}
