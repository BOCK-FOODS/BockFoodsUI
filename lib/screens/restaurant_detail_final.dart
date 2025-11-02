import 'package:flutter/material.dart';

class RestaurantDetailFinalScreen extends StatefulWidget {
  static const routeName = '/restaurant-detail-final';
  const RestaurantDetailFinalScreen({super.key});

  @override
  State<RestaurantDetailFinalScreen> createState() => _RestaurantDetailFinalScreenState();
}

class _RestaurantDetailFinalScreenState extends State<RestaurantDetailFinalScreen> {
  final Map<String, int> _cart = {};
  final TextEditingController _searchController = TextEditingController();
  
  // Menu items for different locations
  final Map<String, List<Map<String, dynamic>>> _locationMenus = {
    'Koramangala': [
      {
        'name': 'Paneer Butter Masala',
        'price': 189,
        'originalPrice': 249,
        'rating': 4.6,
        'ratingCount': '2.3K+',
        'isBestseller': true,
        'isVeg': true,
      },
      {
        'name': 'Dal Makhani',
        'price': 149,
        'originalPrice': 199,
        'rating': 4.5,
        'ratingCount': '1.8K+',
        'isBestseller': true,
        'isVeg': true,
      },
      {
        'name': 'Veg Biryani',
        'price': 179,
        'rating': 4.4,
        'ratingCount': '3.2K+',
        'isBestseller': true,
        'isVeg': true,
      },
      {
        'name': 'Hakka Noodles',
        'price': 129,
        'rating': 4.3,
        'ratingCount': '1.5K+',
        'isBestseller': false,
        'isVeg': true,
      },
      {
        'name': 'Gobi Manchurian',
        'price': 139,
        'rating': 4.5,
        'ratingCount': '2.1K+',
        'isBestseller': true,
        'isVeg': true,
      },
      {
        'name': 'Veg Fried Rice',
        'price': 119,
        'rating': 4.2,
        'ratingCount': '1.2K+',
        'isBestseller': false,
        'isVeg': true,
      },
    ],
    'Indiranagar': [
      {
        'name': 'Margherita Pizza',
        'price': 249,
        'originalPrice': 349,
        'rating': 4.7,
        'ratingCount': '4.5K+',
        'isBestseller': true,
        'isVeg': true,
      },
      {
        'name': 'Pasta Alfredo',
        'price': 199,
        'originalPrice': 279,
        'rating': 4.6,
        'ratingCount': '3.8K+',
        'isBestseller': true,
        'isVeg': true,
      },
      {
        'name': 'Veg Lasagna',
        'price': 229,
        'rating': 4.5,
        'ratingCount': '2.9K+',
        'isBestseller': true,
        'isVeg': true,
      },
      {
        'name': 'Greek Salad',
        'price': 159,
        'rating': 4.4,
        'ratingCount': '1.8K+',
        'isBestseller': false,
        'isVeg': true,
      },
      {
        'name': 'Garlic Bread',
        'price': 99,
        'rating': 4.3,
        'ratingCount': '2.5K+',
        'isBestseller': false,
        'isVeg': true,
      },
      {
        'name': 'Bruschetta',
        'price': 129,
        'rating': 4.4,
        'ratingCount': '1.6K+',
        'isBestseller': false,
        'isVeg': true,
      },
    ],
    'Whitefield': [
      {
        'name': 'Paneer Paratha',
        'price': 129,
        'originalPrice': 179,
        'rating': 4.5,
        'ratingCount': '3.4K+',
        'isBestseller': true,
        'isVeg': true,
      },
      {
        'name': 'Chole Bhature',
        'price': 139,
        'originalPrice': 189,
        'rating': 4.6,
        'ratingCount': '4.2K+',
        'isBestseller': true,
        'isVeg': true,
      },
      {
        'name': 'Rajma Chawal',
        'price': 149,
        'rating': 4.4,
        'ratingCount': '2.8K+',
        'isBestseller': true,
        'isVeg': true,
      },
      {
        'name': 'Aloo Gobi',
        'price': 119,
        'rating': 4.3,
        'ratingCount': '1.9K+',
        'isBestseller': false,
        'isVeg': true,
      },
      {
        'name': 'Mixed Veg Curry',
        'price': 129,
        'rating': 4.4,
        'ratingCount': '2.3K+',
        'isBestseller': false,
        'isVeg': true,
      },
      {
        'name': 'Kadai Paneer',
        'price': 169,
        'rating': 4.5,
        'ratingCount': '3.1K+',
        'isBestseller': true,
        'isVeg': true,
      },
    ],
    'HSR Layout': [
      {
        'name': 'Idli [4 Nos]',
        'price': 69,
        'originalPrice': 99,
        'rating': 4.6,
        'ratingCount': '5.2K+',
        'isBestseller': true,
        'isVeg': true,
      },
      {
        'name': 'Masala Dosa',
        'price': 89,
        'originalPrice': 119,
        'rating': 4.7,
        'ratingCount': '6.8K+',
        'isBestseller': true,
        'isVeg': true,
      },
      {
        'name': 'Medhu Vada [2 Nos]',
        'price': 59,
        'rating': 4.5,
        'ratingCount': '4.1K+',
        'isBestseller': true,
        'isVeg': true,
      },
      {
        'name': 'Pongal',
        'price': 79,
        'rating': 4.4,
        'ratingCount': '3.5K+',
        'isBestseller': false,
        'isVeg': true,
      },
      {
        'name': 'Rava Dosa',
        'price': 99,
        'rating': 4.6,
        'ratingCount': '4.8K+',
        'isBestseller': true,
        'isVeg': true,
      },
      {
        'name': 'Filter Coffee',
        'price': 39,
        'rating': 4.7,
        'ratingCount': '7.2K+',
        'isBestseller': true,
        'isVeg': true,
      },
    ],
    'BTM Layout': [
      {
        'name': 'Veg Biryani [Full]',
        'price': 199,
        'originalPrice': 279,
        'rating': 4.5,
        'ratingCount': '3.9K+',
        'isBestseller': true,
        'isVeg': true,
      },
      {
        'name': 'Paneer Biryani',
        'price': 229,
        'originalPrice': 299,
        'rating': 4.6,
        'ratingCount': '4.5K+',
        'isBestseller': true,
        'isVeg': true,
      },
      {
        'name': 'Mushroom Biryani',
        'price': 209,
        'rating': 4.4,
        'ratingCount': '2.7K+',
        'isBestseller': true,
        'isVeg': true,
      },
      {
        'name': 'Raita Bowl',
        'price': 49,
        'rating': 4.3,
        'ratingCount': '1.8K+',
        'isBestseller': false,
        'isVeg': true,
      },
      {
        'name': 'Veg Curry',
        'price': 89,
        'rating': 4.4,
        'ratingCount': '2.1K+',
        'isBestseller': false,
        'isVeg': true,
      },
      {
        'name': 'Jeera Rice',
        'price': 79,
        'rating': 4.2,
        'ratingCount': '1.5K+',
        'isBestseller': false,
        'isVeg': true,
      },
    ],
  };

  List<Map<String, dynamic>> _menuItems = [];
  String _currentArea = '';

  int get _totalItems {
    return _cart.values.fold(0, (sum, count) => sum + count);
  }

  double get _totalPrice {
    double total = 0;
    _cart.forEach((itemName, count) {
      final item = _menuItems.firstWhere((item) => item['name'] == itemName);
      total += item['price'] * count;
    });
    return total;
  }

  void _addToCart(String itemName) {
    setState(() {
      _cart[itemName] = (_cart[itemName] ?? 0) + 1;
    });
  }

  void _removeFromCart(String itemName) {
    setState(() {
      if (_cart[itemName] != null && _cart[itemName]! > 0) {
        _cart[itemName] = _cart[itemName]! - 1;
        if (_cart[itemName] == 0) {
          _cart.remove(itemName);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final restaurantName = args['name'] ?? 'Green Bowl Kitchen';
    final cuisine = args['cuisine'] ?? 'North Indian';
    final area = args['area'] ?? 'Koramangala';
    
    // Set menu items based on area
    if (_currentArea != area) {
      _currentArea = area;
      _menuItems = _locationMenus[area] ?? _locationMenus['Koramangala']!;
      _cart.clear(); // Clear cart when changing location
    }
    
    final isWeb = MediaQuery.of(context).size.width > 600;
    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = isWeb ? screenWidth * 0.75 : screenWidth;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: contentWidth,
              child: CustomScrollView(
                slivers: [
                  // App Bar with back button and actions
                  SliverAppBar(
                    backgroundColor: Colors.white,
                    elevation: 0,
                    pinned: true,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    actions: [
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFF4CAF50)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.share, size: 16, color: Color(0xFF4CAF50)),
                              SizedBox(width: 4),
                              Text(
                                'SHARE',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4CAF50),
                                ),
                              ),
                            ],
                          ),
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.favorite_border, color: Colors.black),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  
                  // Restaurant Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Location Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.location_on, size: 16, color: Color(0xFF4CAF50)),
                                const SizedBox(width: 4),
                                Text(
                                  area,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Color(0xFF4CAF50),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          
                          // Restaurant Name
                          Text(
                            restaurantName,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          
                          // Cuisine with Veg Icon
                          Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  border: Border.all(color: const Color(0xFF4CAF50), width: 2),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF4CAF50),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                cuisine,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Rating and Delivery Info
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.star, size: 14, color: Colors.white),
                                    SizedBox(width: 4),
                                    Text(
                                      '4.5',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '20-25 mins',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '•',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '₹300 for two',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Offer Badge
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF4CAF50).withOpacity(0.1),
                                  const Color(0xFF66BB6A).withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF4CAF50),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.local_offer,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Special Offer',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xFF4CAF50),
                                        ),
                                      ),
                                      Text(
                                        '40% OFF on orders above ₹199',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Search Bar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search for dishes',
                            prefixIcon: Icon(Icons.search, color: Color(0xFF4CAF50)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Filter Chips
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip('Pure Veg', Icons.eco, true),
                            const SizedBox(width: 8),
                            _buildFilterChip('Ratings 4.0+', null, false),
                            const SizedBox(width: 8),
                            _buildFilterChip('Bestseller', Icons.star, false),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Free Delivery Badge
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.delivery_dining, color: Color(0xFF4CAF50), size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Free delivery on orders above ₹99',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4CAF50),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Menu Section Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Menu (${_menuItems.length} items)',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  
                  // Menu Items Grid
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isWeb ? 3 : 2,
                        childAspectRatio: 0.70,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return _buildMenuItem(_menuItems[index]);
                        },
                        childCount: _menuItems.length,
                      ),
                    ),
                  ),
                  
                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ),
          
          // Floating Menu Button
          Positioned(
            right: isWeb ? (screenWidth - contentWidth) / 2 + 16 : 16,
            bottom: _totalItems > 0 ? 100 : 30,
            child: FloatingActionButton(
              onPressed: () {
                // Show menu categories
              },
              backgroundColor: const Color(0xFF4CAF50),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.restaurant_menu, color: Colors.white, size: 20),
                  SizedBox(height: 2),
                  Text(
                    'MENU',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Cart Bottom Bar
          if (_totalItems > 0)
            Positioned(
              bottom: 0,
              left: isWeb ? (screenWidth - contentWidth) / 2 : 0,
              width: contentWidth,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '$_totalItems Item${_totalItems > 1 ? 's' : ''}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '₹${_totalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          _showCartDialog();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                'View Cart',
                                style: TextStyle(
                                  color: Color(0xFF4CAF50),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.shopping_cart, color: Color(0xFF4CAF50), size: 20),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showCartDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Your Cart'),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ..._cart.entries.map((entry) {
                final item = _menuItems.firstWhere((item) => item['name'] == entry.key);
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text('₹${item['price']} x ${entry.value} = ₹${item['price'] * entry.value}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Color(0xFF4CAF50)),
                        onPressed: () {
                          _removeFromCart(entry.key);
                          Navigator.of(ctx).pop();
                          if (_cart.isNotEmpty) {
                           _showCartDialog();
                          }
                        },
                      ),
                      Text('${entry.value}'),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline, color: Color(0xFF4CAF50)),
                        onPressed: () {
                          _addToCart(entry.key);
                          Navigator.of(ctx).pop();
                          _showCartDialog();
                        },
                      ),
                    ],
                  ),
                );
              }),
              const Divider(),
              ListTile(
                title: const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                trailing: Text(
                  '₹${_totalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF4CAF50)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Continue Shopping', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Proceeding to checkout...'),
                  backgroundColor: Color(0xFF4CAF50),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
            ),
            child: const Text('Checkout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData? icon, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFE8F5E9) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? const Color(0xFF4CAF50) : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: selected ? const Color(0xFF4CAF50) : Colors.black),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected ? const Color(0xFF4CAF50) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item) {
    final itemCount = _cart[item['name']] ?? 0;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: const Icon(Icons.fastfood, size: 50, color: Colors.grey),
                ),
                if (item['isBestseller'])
                  Positioned(
                    top: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.star, size: 10, color: Colors.white),
                          SizedBox(width: 3),
                          Text(
                            'Bestseller',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (item['isVeg'])
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFF4CAF50), width: 2),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Center(
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          if (item['originalPrice'] != null) ...[
                            Text(
                              '₹${item['originalPrice']}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            '₹${item['price']}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4CAF50),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 11, color: Color(0xFF4CAF50)),
                          const SizedBox(width: 3),
                          Text(
                            '${item['rating']} (${item['ratingCount']})',
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  // Add Button
                  itemCount == 0
                      ? GestureDetector(
                          onTap: () => _addToCart(item['name']),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFF4CAF50)),
                            ),
                            child: const Center(
                              child: Text(
                                'ADD',
                                style: TextStyle(
                                  color: Color(0xFF4CAF50),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () => _removeFromCart(item['name']),
                                child: const Icon(Icons.remove, color: Colors.white, size: 16),
                              ),
                              Text(
                                '$itemCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _addToCart(item['name']),
                                child: const Icon(Icons.add, color: Colors.white, size: 16),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}