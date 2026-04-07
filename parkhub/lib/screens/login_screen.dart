import 'package:flutter/material.dart';
import '../app/routes.dart';
import '../widgets/primary_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ParkHub – Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🅿️ ParkHub',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Find & book parking in seconds',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              // TODO: Replace with real TextFields
              const Text('[Email field placeholder]'),
              const SizedBox(height: 12),
              const Text('[Password field placeholder]'),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Login',
                onPressed: () {
                  // TODO: Call AuthService.login() then navigate on success
                  Navigator.pushReplacementNamed(context, AppRoutes.home);
                },
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to register screen
                },
                child: const Text("Don't have an account? Sign up"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
