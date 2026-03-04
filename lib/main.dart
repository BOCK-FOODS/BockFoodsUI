import 'package:bock_foods/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Import your providers
import 'providers/food_cart_provider.dart';
import 'providers/instamart_cart_provider.dart';
import 'screens/home_screen.dart'; 

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FoodCartProvider()),
        ChangeNotifierProvider(create: (_) => InstamartCartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bock Foods',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // We removed the syncCart logic from here to prevent the crash
      home: const LoginScreen(),
    );
  }
}