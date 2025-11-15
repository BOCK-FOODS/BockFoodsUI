import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bock_foods/providers/cart_provider.dart';
import 'package:bock_foods/providers/instamart_cart_provider.dart';
import 'package:bock_foods/providers/auth_provider.dart';
import 'screens/home_screen.dart';
import 'screens/restaurants_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/instamart_screen.dart';
import 'screens/restaurant_detail_final.dart';
import 'screens/login_signup_screen.dart';

void main() {
  runApp(const BockFoodsApp());
}

class BockFoodsApp extends StatelessWidget {
  const BockFoodsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FoodCartProvider()),
        ChangeNotifierProvider(create: (_) => InstamartCartProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Bock Foods',
        theme: ThemeData(
          primaryColor: const Color(0xFF27A600),
          colorScheme: ColorScheme.fromSwatch().copyWith(primary: const Color(0xFF27A600)),
          scaffoldBackgroundColor: const Color(0xFFF7F9FB),
          useMaterial3: true,
        ),
        home: const _AppWrapper(),
        routes: {
          RestaurantsScreen.routeName: (_) => const RestaurantsScreen(),
         
          // RestaurantDetailScreen.routeName: (_) => const RestaurantDetailScreen(),
          RestaurantDetailFinalScreen.routeName: (_) => const RestaurantDetailFinalScreen(),
          CartScreen.routeName: (_) => const CartScreen(),
          CheckoutScreen.routeName: (_) => const CheckoutScreen(),
          InstamartScreen.routeName: (_) => const InstamartScreen(),
        
          //AccountScreen.routeName: (_) => const AccountScreen(),
        },
      ),
    );
  }
}

class _AppWrapper extends StatelessWidget {
  const _AppWrapper();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isLoggedIn) {
          return const HomeScreen();
        }
        return const LoginSignupScreen();
      },
    );
  }
}
