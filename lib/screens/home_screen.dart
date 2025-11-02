import 'package:flutter/material.dart';
import '../widgets/food_card.dart';
import '../models/sample_data.dart';
import 'restaurants_screen.dart';
import 'cart_screen.dart';
import 'instamart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = <Widget>[
    const _FoodHome(),
    const RestaurantsScreen(),
    const InstamartScreen(),
    const CartScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 600;

    if (isWide) {
      // Web / wide layout: show top nav as AppBar actions
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              const Text('Bock Foods', 
                style: TextStyle(
                  color: Color(0xFF2D3142),
                  fontWeight: FontWeight.bold,
                )),
              const Spacer(),
              TextButton.icon(
                onPressed: () => setState(() => _selectedIndex = 0),
                icon: const Icon(Icons.home, color: Color(0xFF5B67CA)),
                label: const Text('Home', style: TextStyle(color: Color(0xFF2D3142))),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => setState(() => _selectedIndex = 1),
                icon: const Icon(Icons.restaurant, color: Color(0xFF5B67CA)),
                label: const Text('Food', style: TextStyle(color: Color(0xFF2D3142))),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => setState(() => _selectedIndex = 2),
                icon: const Icon(Icons.local_grocery_store, color: Color(0xFF5B67CA)),
                label: const Text('Instamart', style: TextStyle(color: Color(0xFF2D3142))),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: () => setState(() => _selectedIndex = 3),
                icon: const Icon(Icons.shopping_cart, color: Color(0xFF5B67CA)),
                label: const Text('Cart', style: TextStyle(color: Color(0xFF2D3142))),
              ),
            ],
          ),
        ),
        body: _tabs[_selectedIndex],
      );
    }

    // Mobile layout: bottom navigation
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF5B67CA),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Food'),
          BottomNavigationBarItem(icon: Icon(Icons.local_grocery_store), label: 'Instamart'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
        ],
      ),
    );
  }
}

class _FoodHome extends StatefulWidget {
  const _FoodHome();

  @override
  State<_FoodHome> createState() => _FoodHomeState();
}

class _FoodHomeState extends State<_FoodHome> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 600;
    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = isWeb ? screenWidth * 0.75 : screenWidth;

    return SafeArea(
      child: Center(
        child: SizedBox(
          width: contentWidth,
          child: CustomScrollView(
            slivers: [
              // Hero Section with Green Gradient
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF27A600), Color(0xFF34D058)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Decorative vegetables on left
                      Positioned(
                        left: -50,
                        top: 20,
                        child: Opacity(
                          opacity: 0.3,
                          child: Icon(
                            Icons.emoji_food_beverage,
                            size: 150,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      // Decorative food on right
                      Positioned(
                        right: -30,
                        top: 40,
                        child: Opacity(
                          opacity: 0.3,
                          child: Icon(
                            Icons.restaurant,
                            size: 120,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20),
                            // Main Heading
                            const Text(
                              'Order food & groceries. Discover',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            const Text(
                              'best restaurants. Swiggy it!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 32),
                            
                            // Search Bars
                            Row(
                              children: [
                                // Location Input
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.location_on, color: Color(0xFFFF6B35), size: 24),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: TextField(
                                            controller: _locationController,
                                            decoration: const InputDecoration(
                                              hintText: 'Enter your delivery location',
                                              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                
                                // Search Input
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: _searchController,
                                            decoration: const InputDecoration(
                                              hintText: 'Search for restaurant, item or more',
                                              hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                        const Icon(Icons.search, color: Colors.grey),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Service Cards Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ServiceCard(
                          title: 'FOOD DELIVERY',
                          subtitle: 'FROM RESTAURANTS',
                          offer: 'UPTO 20% OFF',
                          icon: Icons.restaurant,
                          color: const Color(0xFFFF6B35),
                          imagePath: 'food_delivery',
                          onTap: () {
                            final homeState = context.findAncestorStateOfType<_HomeScreenState>();
                            homeState?.setState(() {
                              homeState._selectedIndex = 1;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _ServiceCard(
                          title: 'INSTAMART',
                          subtitle: 'INSTANT GROCERY',
                          offer: 'UPTO 20% OFF',
                          icon: Icons.shopping_basket,
                          color: const Color(0xFF27A600),
                          imagePath: 'instamart',
                          onTap: () {
                            final homeState = context.findAncestorStateOfType<_HomeScreenState>();
                            homeState?.setState(() {
                              homeState._selectedIndex = 2;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
              ),

              // Live it up section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Live',
                          style: TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB8B8B8),
                            height: 1.0,
                          ),
                        ),
                        const Text(
                          'it up!',
                          style: TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB8B8B8),
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Crafted with ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFB8B8B8),
                              ),
                            ),
                            const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 16,
                            ),
                            const Text(
                              ' in Bengaluru, India',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFFB8B8B8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        ),
      ),
    );
  }
}

// Service Card Widget
class _ServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String offer;
  final IconData icon;
  final Color color;
  final String imagePath;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.title,
    required this.subtitle,
    required this.offer,
    required this.icon,
    required this.color,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 340,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    offer,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  // Image placeholder with icon
                  Positioned(
                    right: 20,
                    bottom: 20,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: 80,
                        color: color.withOpacity(0.3),
                      ),
                    ),
                  ),
                  // Arrow button
                  Positioned(
                    left: 20,
                    bottom: 20,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}