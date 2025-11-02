import 'package:flutter/material.dart';
import 'restaurant_detail_final.dart';

class AllRestaurantsScreen extends StatefulWidget {
  static const routeName = '/all-restaurants';
  const AllRestaurantsScreen({super.key});

  @override
  State<AllRestaurantsScreen> createState() => _AllRestaurantsScreenState();
}

class _AllRestaurantsScreenState extends State<AllRestaurantsScreen> {
  int _selectedTab = 0;

  final List<Map<String, dynamic>> _restaurants = [
    {
      'name': 'A2B Chennai',
      'cuisine': 'South Indian',
      'rating': '4.2',
      'time': '32 mins',
      'price': 'Rs 100 for two',
    },
    {
      'name': 'Biryani Express',
      'cuisine': 'South Indian',
      'rating': '4.18',
      'time': '18 mins',
      'price': 'Rs 200 for two',
    },
    {
      'name': 'Chai Truck',
      'cuisine': 'Continental, North Indian, South Indian',
      'rating': '4.1',
      'time': '25 mins',
      'price': 'Rs 200 for two',
    },
    {
      'name': 'Shiva Bhavan',
      'cuisine': 'South Indian',
      'rating': '4.15',
      'time': '15 mins',
      'price': 'Rs 150 for two',
    },
  ];

  final List<Map<String, dynamic>> _bestInSafety = [
    {
      'name': 'Namma Veedu Meenatta Bhavan',
      'cuisine': 'South Indian',
      'rating': '4.3',
      'time': '30 mins',
      'offer': 'SWIGGY1T',
    },
    {
      'name': 'Chai Kings',
      'cuisine': 'Desserts, Tea, Milk, Desserts, Bakery',
      'rating': '4.2',
      'time': '25 mins',
      'offer': 'SWIGGY1T',
    },
    {
      'name': 'Shiva Bhavan',
      'cuisine': 'South Indian',
      'rating': '4.1',
      'time': '18 mins',
      'price': 'Rs 150 for two',
    },
    {
      'name': 'Biryani Express',
      'cuisine': 'North Indian',
      'rating': '4.3',
      'time': '15 mins',
      'price': 'Rs 200 for two',
    },
    {
      'name': 'BBQ King',
      'cuisine': 'South Indian',
      'rating': '4.1',
      'time': '25 mins',
      'price': 'Rs 200 for two',
    },
    {
      'name': 'Pizza Corner',
      'cuisine': 'South Indian',
      'rating': '4.3',
      'time': '25 mins',
      'offer': 'SWIGGY1T',
    },
  ];

  final List<Map<String, dynamic>> _pepsiPartners = [
    {
      'name': 'Faasos',
      'cuisine': 'Fast Food, North Indian, Biryani, Desserts',
      'rating': '4.2',
    },
    {
      'name': 'Hungry Pizza',
      'cuisine': 'Pizzas',
      'rating': '4.3',
    },
    {
      'name': 'Biryani Express',
      'cuisine': 'South Indian',
      'rating': '4.18',
      'time': '18 mins',
      'price': 'Rs 200 for two',
    },
    {
      'name': 'Pizza Corner',
      'cuisine': 'South Indian',
      'rating': '4.5',
      'time': '27 mins',
      'price': 'Rs 350 for two',
    },
    {
      'name': 'Murugan Idly',
      'cuisine': 'South Indian',
      'rating': '4.1',
      'time': '33 mins',
      'price': 'Rs 90 for two',
    },
    {
      'name': 'Adyar Hotel',
      'cuisine': 'South Indian',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            const Text(
              'Now',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400]!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                children: [
                  Text(
                    'Other',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black),
                ],
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400]!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                children: [
                  Icon(Icons.local_offer_outlined, size: 14, color: Colors.black),
                  SizedBox(width: 4),
                  Text(
                    'Offer',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_selectedTab == 0) ...[
                  // Featured Section
                  _buildFeaturedSection(),
                  const SizedBox(height: 20),
                  
                  // Category Circles
                  _buildCategoryCircles(),
                  const SizedBox(height: 20),
                  
                  // All Restaurants
                  _buildSectionHeader('ALL RESTAURANTS', showFilter: true),
                  const SizedBox(height: 12),
                  ..._restaurants.map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildRestaurantCard(r),
                  )),
                ],
                
                if (_selectedTab == 2) ...[
                  // Best in Safety Section
                  _buildSafetyBanner(),
                  const SizedBox(height: 20),
                  
                  _buildSectionHeader('BEST IN SAFETY', subtitle: 'SAFEST RESTAURANTS WITH BEST IN CLASS SAFETY STANDARDS'),
                  const SizedBox(height: 12),
                  ..._bestInSafety.map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildRestaurantCard(r),
                  )),
                ],
                
                if (_selectedTab == 3) ...[
                  // Pepsi Partners
                  _buildPepsiHeader(),
                  const SizedBox(height: 20),
                  
                  _buildSectionHeader('PEPSI SAVE OUR RESTAURANTS',
                      subtitle: 'ORDER ANY SOFT DRINK & PEPSI WILL DONATE ANNAI...TO A...'),
                  const SizedBox(height: 12),
                  
                  // Top Row with circular images
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildCircularRestaurant('Faasos', 'Fast Food, North Indian, Biryani'),
                      _buildCircularRestaurant('Hungry Pizza', 'Pizzas'),
                      _buildCircularRestaurant('Biryani', 'Biryani, Mkt'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  ..._pepsiPartners.map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildRestaurantCard(r),
                  )),
                ],
              ],
            ),
          ),
          
          // Bottom Navigation
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedTab,
              onTap: (index) {
                setState(() {
                  _selectedTab = index;
                });
              },
              selectedItemColor: const Color(0xFF27a600),
              unselectedItemColor: Colors.grey,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  label: 'Swiggy',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: 'SEARCH',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_bag_outlined),
                  label: 'ORDERS',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  label: 'ACCOUNT',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'TRY NOW',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'New Launches',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 120,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: const Icon(Icons.restaurant, size: 60, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.green[100],
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'TRY NOW',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Indian Chef',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 120,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: const Icon(Icons.restaurant, size: 60, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCircles() {
    final categories = [
      {'icon': Icons.coffee, 'name': 'Offers\nCoffee tea'},
      {'icon': Icons.shopping_bag, 'name': 'Best\nBroker'},
      {'icon': Icons.local_pizza, 'name': 'Pocket\nFriendly'},
      {'icon': Icons.local_drink, 'name': 'Only on\nSwiggy'},
      {'icon': Icons.restaurant, 'name': 'Express\nDelivery'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(cat['icon'] as IconData, color: Colors.grey[700]),
                ),
                const SizedBox(height: 8),
                Text(
                  cat['name'] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? subtitle, bool showFilter = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (showFilter)
          const Row(
            children: [
              Icon(Icons.tune, size: 16, color: Color(0xFF27a600)),
              SizedBox(width: 4),
              Text(
                'SORT/FILTER',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF27a600),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildRestaurantCard(Map<String, dynamic> restaurant) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          RestaurantDetailFinalScreen.routeName,
          arguments: {
            'name': restaurant['name'],
            'cuisine': restaurant['cuisine'],
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.restaurant, size: 35, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant['cuisine'],
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 12, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        restaurant['rating'],
                        style: const TextStyle(fontSize: 11),
                      ),
                      if (restaurant['time'] != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '• ${restaurant['time']}',
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                      ],
                      if (restaurant['price'] != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          '• ${restaurant['price']}',
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                        ),
                      ],
                      if (restaurant['offer'] != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            restaurant['offer'],
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'BEST IN SAFETY',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'SAFEST RESTAURANTS WITH BEST IN CLASS\nSAFETY STANDARDS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPepsiHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            'PEPSI SAVE OUR RESTAURANTS',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ORDER ANY SOFT DRINK & PEPSI WILL DONATE ANNAI...TO A...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularRestaurant(String name, String cuisine) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.restaurant, size: 40, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          cuisine,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}