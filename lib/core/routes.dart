import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/home_screen.dart';
import '../screens/booking_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/history_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => SplashScreen(),
  '/login': (context) => LoginScreen(),
  '/register': (context) => RegisterScreen(),
  '/home': (context) => HomeScreen(),
  '/booking': (context) => BookingScreen(),
  // NOTE: Untuk navigasi via routes (misal dari pushNamed), harus isi semua parameter required.
  // Jika ingin data dinamis, gunakan MaterialPageRoute seperti di HomeScreen.
  '/detail':
      (context) => DetailScreen(
        name: 'PS Galaxy',
        address: 'Jl. Merdeka No. 10',
        image:
            'https://images.unsplash.com/photo-1511512578047-dfb367046420?auto=format&fit=crop&w=600&q=80',
        description: 'Deskripsi PlayStation Galaxy.',
        rating: 4.5,
        reviews: 100,
        facilities: ['AC', 'WiFi', 'Snack & Minuman'],
        price: 'Rp -',
      ),
  '/profile': (context) => ProfileScreen(),
  '/history': (context) => HistoryScreen(),
};
