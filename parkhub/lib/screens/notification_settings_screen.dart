import 'package:flutter/material.dart';
import '../services/in_app_notification_service.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Tests')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ───────── Booking Confirmed ─────────
          _testButton(
            context: context,
            icon: Icons.check_circle,
            color: Colors.green,
            title: 'Booking Confirmed',
            subtitle: 'Simulate booking success notification',
            onTap: () {
              InAppNotificationService.show(
                context,
                title: 'Booking Confirmed',
                message: 'Your parking spot has been successfully booked.',
                icon: Icons.check_circle,
                color: Colors.green,
              );
            },
          ),

          const SizedBox(height: 12),

          // ───────── Parking Ending ─────────
          _testButton(
            context: context,
            icon: Icons.timer,
            color: Colors.orange,
            title: 'Parking Ending Soon',
            subtitle: 'Simulate 15 min warning',
            onTap: () {
              InAppNotificationService.show(
                context,
                title: 'Parking Ending Soon',
                message: 'Your parking session ends in 15 minutes.',
                icon: Icons.timer,
                color: Colors.orange,

                action: SnackBarAction(
                  label: 'Extend',
                  textColor: Colors.white,
                  onPressed: () {
                    InAppNotificationService.show(
                      context,
                      title: 'Booking Extended',
                      message: 'Your parking session was extended by 1 hour.',
                      icon: Icons.access_time_filled,
                      color: const Color(0xFF1A7F4B),
                    );
                  },
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          // ───────── Expired ─────────
          _testButton(
            context: context,
            icon: Icons.warning,
            color: Colors.red,
            title: 'Session Expired',
            subtitle: 'Simulate expiry notification',
            onTap: () {
              InAppNotificationService.show(
                context,
                title: 'Session Expired',
                message: 'Your parking session has ended.',
                icon: Icons.warning,
                color: Colors.red,
              );
            },
          ),

          const SizedBox(height: 12),

          // ───────── Reward ─────────
          _testButton(
            context: context,
            icon: Icons.star,
            color: Colors.amber,
            title: 'Reward Earned',
            subtitle: 'Simulate points reward',
            onTap: () {
              InAppNotificationService.show(
                context,
                title: 'Reward Earned',
                message: 'You earned 20 ParkHub points!',
                icon: Icons.star,
                color: Colors.amber,
              );
            },
          ),

          const SizedBox(height: 12),

          // ───────── Nearby Spot ─────────
          _testButton(
            context: context,
            icon: Icons.local_parking,
            color: Colors.blue,
            title: 'Nearby Spot Available',
            subtitle: 'Simulate live availability alert',
            onTap: () {
              InAppNotificationService.show(
                context,
                title: 'Spot Available Nearby',
                message: 'A parking spot just opened near you.',
                icon: Icons.local_parking,
                color: Colors.blue,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _testButton({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF1E1E1E)
              : Colors.white,

          borderRadius: BorderRadius.circular(16),

          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withOpacity(0.4)
                  : Colors.black.withOpacity(0.05),

              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? color.withOpacity(0.2)
                    : color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.chevron_right,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white54
                  : Colors.black54,
            ),
          ],
        ),
      ),
    );
  }
}
