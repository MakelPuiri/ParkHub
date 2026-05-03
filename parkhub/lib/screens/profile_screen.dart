import 'package:flutter/material.dart';
import '../app/routes.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../themes/theme_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TODO: Load real user data from AuthService.getCurrentUser()
            const CircleAvatar(radius: 48, child: Icon(Icons.person, size: 48)),
            const SizedBox(height: 12),
            const Text(
              'User Name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text('user@email.com', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),


            
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Booking History'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Navigate to booking history screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Settings'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // TODO: Navigate to settings screen
              },
            ),

            ValueListenableBuilder(
              valueListenable: themeNotifier,

              builder: (context, ThemeMode currentMode, child){
                final bool isDark = 
                currentMode == ThemeMode.dark;

                return ListTile(
                  leading: Icon(
                    isDark ? Icons.dark_mode : Icons.light_mode,
                  ),

                  title: const Text('DarkMode'),

                  trailing: Switch(
                    value: isDark,

                    onChanged: (value) {
                      themeNotifier.value = 
                        value ? ThemeMode.dark : ThemeMode.light;
                    },
                  ),
                );
              },
            ),

            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                // TODO: Call AuthService.logout() before navigating
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 4),
    );
  }
}
