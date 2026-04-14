import 'package:flutter/material.dart';

/// Shows password requirements with a live pass/fail indicator
/// as the user types. Pass the current password value to update it.
class PasswordRequirementsText extends StatelessWidget {
  final String password;

  const PasswordRequirementsText({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Password must have:',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        _Requirement(label: 'At least 8 characters', met: password.length >= 8),
        _Requirement(
          label: 'One uppercase letter (A–Z)',
          met: password.contains(RegExp(r'[A-Z]')),
        ),
        _Requirement(
          label: 'One lowercase letter (a–z)',
          met: password.contains(RegExp(r'[a-z]')),
        ),
        _Requirement(
          label: 'One number (0–9)',
          met: password.contains(RegExp(r'[0-9]')),
        ),
      ],
    );
  }
}

class _Requirement extends StatelessWidget {
  final String label;
  final bool met;

  const _Requirement({required this.label, required this.met});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 14,
            color: met ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: met ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
