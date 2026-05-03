import 'package:flutter/material.dart';
import 'routes.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/map_screen.dart';
import '../screens/booking_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/favourites_screen.dart'; // NEW
import '../screens/register_screen.dart'; // NEW

import '../themes/theme_controller.dart';

class ParkHubApp extends StatelessWidget {
  const ParkHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return ValueListenableBuilder(
      valueListenable: themeNotifier,
      
      builder: (context, ThemeMode currentMode, child){
        return MaterialApp(
          title: 'ParkHub',
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB),
            brightness: Brightness.light,
           ),
            useMaterial3: true,
          ),
      
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB),
            brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),

          themeMode: currentMode,

          initialRoute: AppRoutes.login,
          routes: {
            AppRoutes.login: (_) => const LoginScreen(),
            AppRoutes.home: (_) => const HomeScreen(),
            AppRoutes.search: (_) => const SearchScreen(),
            AppRoutes.map: (_) => const MapScreen(),
            AppRoutes.booking: (_) => const BookingScreen(),
            AppRoutes.profile: (_) => const ProfileScreen(),
            AppRoutes.favourites: (_) => const FavouritesScreen(), // NEW
            AppRoutes.register: (_) => const RegisterScreen(), // NEW
          },
        );
      },
    );
  }
}
