import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/cities_screen.dart';
import 'screens/cloud_kitchens_screen.dart';
import 'screens/menu_management_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/customers_screen.dart';
import 'screens/delivery_partners_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const BockFoodsAdminApp());
}

class BockFoodsAdminApp extends StatelessWidget {
  const BockFoodsAdminApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bock Foods Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      ),
      home: const LoginScreen(),
    );
  }
}

class AdminLayout extends StatefulWidget {
  const AdminLayout({Key? key}) : super(key: key);

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const DashboardScreen(),
    const CitiesScreen(),
    const CloudKitchensScreen(),
    const MenuManagementScreen(),
    const OrdersScreen(),
    const CustomersScreen(),
    const DeliveryPartnersScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.green[800]!, Colors.green[600]!],
              ),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Icon(Icons.restaurant_menu, color: Colors.white, size: 48),
                      const SizedBox(height: 12),
                      Text(
                        'BOCK FOODS',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Admin Dashboard',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white30),
                Expanded(
                  child: ListView(
                    children: [
                      _buildNavItem(0, Icons.dashboard, 'Dashboard'),
                      _buildNavItem(1, Icons.location_city, 'Cities'),
                      _buildNavItem(2, Icons.store, 'Cloud Kitchens'),
                      _buildNavItem(3, Icons.menu_book, 'Menu Management'),
                      _buildNavItem(4, Icons.shopping_bag, 'Orders'),
                      _buildNavItem(5, Icons.people, 'Customers'),
                      _buildNavItem(6, Icons.delivery_dining, 'Delivery Partners'),
                      _buildNavItem(7, Icons.settings, 'Settings'),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Logout'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green[800],
                      minimumSize: const Size(double.infinity, 45),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.white : Colors.white70),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 15,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Colors.white.withOpacity(0.2),
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
    );
  }
}