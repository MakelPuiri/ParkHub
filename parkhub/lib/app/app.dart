import 'package:flutter/material.dart';

import 'routes.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/map_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/favourites_screen.dart';
import '../screens/register_screen.dart';
import '../themes/theme_controller.dart';

class ParkHubApp extends StatelessWidget {
  const ParkHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          title: 'ParkHub',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2563EB),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2563EB),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          themeMode: currentMode,
          initialRoute: AppRoutes.login,
          routes: {
            AppRoutes.login: (context) => const LoginScreen(),
            AppRoutes.home: (context) => const HomeScreen(),
            AppRoutes.search: (context) => const SearchScreen(),
            AppRoutes.map: (context) => const MapScreen(),
            AppRoutes.profile: (context) => const ProfileScreen(),
            AppRoutes.favourites: (context) => const FavouritesScreen(),
            AppRoutes.register: (context) => const RegisterScreen(),
          },
        );
      },
    );
  }
}
