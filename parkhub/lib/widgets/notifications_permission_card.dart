import 'package:flutter/material.dart';

class NotificationPermissionCard extends StatelessWidget {
  final VoidCallback onEnable;

  const NotificationPermissionCard({
    super.key,
    required this.onEnable,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.notifications_active),
        title: const Text('Enable Notifications'),
        subtitle: const Text(
          'Get reminders about your parking session.',
        ),
        trailing: ElevatedButton(
          onPressed: onEnable,
          child: const Text('Enable'),
        ),
      ),
    );
  }
}