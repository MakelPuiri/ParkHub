import 'package:flutter/material.dart';
import 'routes.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/map_screen.dart';
import '../screens/booking_screen.dart';
import '../screens/profile_screen.dart';

class ParkHubApp extends StatelessWidget {
  const ParkHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.search: (_) => const SearchScreen(),
        AppRoutes.map: (_) => const MapScreen(),
        AppRoutes.booking: (_) => const BookingScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
      },
    );
  }
}
