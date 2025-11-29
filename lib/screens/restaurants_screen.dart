import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../models/food_item.dart';
import 'restaurant_detail_final.dart';

class RestaurantsScreen extends StatefulWidget {
  static const routeName = '/restaurants';
  const RestaurantsScreen({super.key});

  @override
  State<RestaurantsScreen> createState() => _RestaurantsScreenState();
}

class _RestaurantsScreenState extends State<RestaurantsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _deliveryAddress = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddressDialog() {
    final addressController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter Delivery Address'),
        content: TextField(
          controller: addressController,
          decoration: const InputDecoration(
            hintText: 'Enter your address',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (addressController.text.isNotEmpty) {
                setState(() {
                  _deliveryAddress = addressController.text;
                });
                Navigator.of(ctx).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Helper functions for cart management
  int getItemCount(String itemId) {
    final cart = Provider.of<FoodCartProvider>(context, listen: false);
    return cart.items[itemId]?.qty ?? 0;
  }

  void addToCart(String itemId, String itemName, double price, String description) {
    final foodItem = FoodItem(
      id: itemId,
      name: itemName,
      price: price,
      description: description,
      imageUrl: '',
      category: 'Featured',
      isVeg: true,
    );
    
    Provider.of<FoodCartProvider>(context, listen: false).addItem(foodItem);
  }

  void removeFromCart(String itemId) {
    Provider.of<FoodCartProvider>(context, listen: false).removeSingle(itemId);
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 900;
    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = isWeb ? screenWidth * 0.75 : screenWidth;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
  automaticallyImplyLeading: false, // Add this line to remove back arrow
  backgroundColor: Colors.white,
  elevation: 0,
  title: GestureDetector(
    onTap: _showAddressDialog,
    child: Row(
      children: [
        const Icon(Icons.home, color: Color(0xFF4CAF50), size: 24),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text(
                    'Address',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down, color: Colors.black, size: 20),
                ],
              ),
              Text(
                _deliveryAddress,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 11,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ],
    ),
  ),
  actions: [
    IconButton(
      icon: CircleAvatar(
        backgroundColor: Colors.grey[300],
        child: const Icon(Icons.person, color: Colors.grey),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed('/account');
      },
    ),
    const SizedBox(width: 16),
  ],
),
      body: Center(
        child: SizedBox(
          width: contentWidth,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: "Search for dishes...",
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(Icons.search, color: Color(0xFF4CAF50)),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),

                // Promotional Banner
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.local_offer, color: Colors.white, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  'Special Offers',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Get 40% OFF on\nyour first order!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: const Icon(
                          Icons.restaurant_menu,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Offer Tags
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'MIN ₹100 OFF',
                              style: TextStyle(
                                color: Color(0xFF4CAF50),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Text(
                              'FAST DELIVERY',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bestseller Items Section
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Icon(Icons.trending_up, color: Color(0xFF4CAF50), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Bestseller Items',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bestseller Items Row
                Container(
                  height: 260,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: 4,
                    itemBuilder: (ctx, i) {
                      final items = [
                        {
                          'id': 'bestseller_paneer_tikka_pizza',
                          'name': 'Paneer Tikka Pizza',
                          'rating': '4.6',
                          'time': '25-30 mins',
                          'cuisine': 'Italian',
                          'price': 249.0,
                          'originalPrice': 349.0,
                          'isVeg': true,
                          'description': 'Delicious paneer tikka pizza',
                        },
                        {
                          'id': 'bestseller_cheese_burst_pizza',
                          'name': 'Cheese Burst Pizza',
                          'rating': '4.3',
                          'time': '20-25 mins',
                          'cuisine': 'Italian',
                          'price': 299.0,
                          'originalPrice': 399.0,
                          'isVeg': true,
                          'description': 'Cheesy burst pizza',
                        },
                        {
                          'id': 'bestseller_veg_loaded_sandwich',
                          'name': 'Veg Loaded Sandwich',
                          'rating': '4.5',
                          'time': '15-20 mins',
                          'cuisine': 'Continental',
                          'price': 129.0,
                          'originalPrice': 179.0,
                          'isVeg': true,
                          'description': 'Loaded veg sandwich',
                        },
                        {
                          'id': 'bestseller_paneer_paratha',
                          'name': 'Paneer Paratha',
                          'rating': '4.4',
                          'time': '20-25 mins',
                          'cuisine': 'North Indian',
                          'price': 149.0,
                          'originalPrice': 199.0,
                          'isVeg': true,
                          'description': 'Stuffed paneer paratha',
                        },
                      ];
                      return _buildUniformCard(items[i]);
                    },
                  ),
                ),

                // Budget Meals Section
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4CAF50),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '₹99',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Budget Meals',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Budget Meals Row
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Delicious meals at ₹99 & below',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Budget Meals Items
                Container(
                  height: 260,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: 4,
                    itemBuilder: (ctx, i) {
                      final items = [
                        {
                          'id': 'budget_masala_dosa',
                          'name': 'Masala Dosa',
                          'originalPrice': 120.0,
                          'price': 89.0,
                          'rating': '4.2',
                          'reviews': '890',
                          'restaurant': 'South Indian Kitchen',
                          'isVeg': true,
                          'description': 'Crispy masala dosa',
                        },
                        {
                          'id': 'budget_chole_bhature',
                          'name': 'Chole Bhature',
                          'originalPrice': 140.0,
                          'price': 99.0,
                          'rating': '4.3',
                          'reviews': '654',
                          'restaurant': 'Punjabi Dhaba',
                          'isVeg': true,
                          'description': 'Authentic chole bhature',
                        },
                        {
                          'id': 'budget_veg_biryani',
                          'name': 'Veg Biryani',
                          'originalPrice': 150.0,
                          'price': 95.0,
                          'rating': '4.4',
                          'reviews': '1234',
                          'restaurant': 'Biryani House',
                          'isVeg': true,
                          'description': 'Aromatic veg biryani',
                        },
                        {
                          'id': 'budget_paneer_thali',
                          'name': 'Paneer Thali',
                          'originalPrice': 160.0,
                          'price': 99.0,
                          'rating': '4.5',
                          'reviews': '876',
                          'restaurant': 'Thali Express',
                          'isVeg': true,
                          'description': 'Complete paneer thali',
                        },
                      ];
                      return _buildUniformCard(items[i]);
                    },
                  ),
                ),

                // What's on your mind?
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    "What's on your mind?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Category Filters
                Container(
                  height: 120,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildCategoryIcon('Dosa', Icons.fastfood, const Color(0xFF4CAF50)),
                      _buildCategoryIcon('North Indian', Icons.restaurant, Colors.orange),
                      _buildCategoryIcon('Pizzas', Icons.local_pizza, Colors.red),
                      _buildCategoryIcon('Chinese', Icons.rice_bowl, const Color(0xFF4CAF50)),
                      _buildCategoryIcon('Thali', Icons.lunch_dining, Colors.brown),
                    ],
                  ),
                ),

                // Filter Row
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('Pure Veg', null, hasIcon: true),
                        const SizedBox(width: 8),
                        _buildFilterChip('Fast Delivery', null, hasBolt: true),
                      ],
                    ),
                  ),
                ),

                // Cloud Kitchens Section Header
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Text(
                    "Cloud Kitchens Near You",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Cloud Kitchens List
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildRestaurantCard({
                        'name': 'Green Bowl Kitchen - Koramangala',
                        'rating': '4.5',
                        'reviews': '12K+',
                        'location': 'Koramangala, 1.2 km',
                        'cuisine': 'North Indian, South Indian, Chinese',
                        'price': '₹300 for two',
                        'time': '20-25 MINS',
                        'offer': '40% OFF upto ₹80',
                        'area': 'Koramangala',
                      }),
                      const SizedBox(height: 12),
                      _buildRestaurantCard({
                        'name': 'Veggie Delight - Indiranagar',
                        'rating': '4.6',
                        'reviews': '18K+',
                        'location': 'Indiranagar, 2.1 km',
                        'cuisine': 'Italian, Continental, Healthy',
                        'price': '₹350 for two',
                        'time': '25-30 MINS',
                        'offer': 'Items at ₹99',
                        'badge': 'Best In Italian',
                        'area': 'Indiranagar',
                      }),
                      const SizedBox(height: 12),
                      _buildRestaurantCard({
                        'name': 'Pure Veg Express - Whitefield',
                        'rating': '4.3',
                        'reviews': '8K+',
                        'location': 'Whitefield, 3.5 km',
                        'cuisine': 'Thalis, Punjabi, Rajasthani',
                        'price': '₹250 for two',
                        'time': '30-35 MINS',
                        'offer': 'Free Delivery',
                        'area': 'Whitefield',
                      }),
                      const SizedBox(height: 12),
                      _buildRestaurantCard({
                        'name': 'Sattvic Kitchen - HSR Layout',
                        'rating': '4.7',
                        'reviews': '15K+',
                        'location': 'HSR Layout, 1.8 km',
                        'cuisine': 'South Indian, Sweets, Snacks',
                        'price': '₹200 for two',
                        'time': '15-20 MINS',
                        'offer': '50% OFF upto ₹100',
                        'badge': 'Best In South Indian',
                        'area': 'HSR Layout',
                      }),
                      const SizedBox(height: 12),
                      _buildRestaurantCard({
                        'name': 'Flavors of India - BTM Layout',
                        'rating': '4.4',
                        'reviews': '10K+',
                        'location': 'BTM Layout, 2.8 km',
                        'cuisine': 'Biryani, Curries, Breads',
                        'price': '₹280 for two',
                        'time': '22-27 MINS',
                        'offer': 'Items at ₹79',
                        'area': 'BTM Layout',
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: null,
    );
  }

  // New unified card widget for both bestseller and budget meals
  Widget _buildUniformCard(Map<String, dynamic> item) {
    final itemId = item['id'] as String;
    
    return Consumer<FoodCartProvider>(
      builder: (context, cart, child) {
        final itemCount = cart.items[itemId]?.qty ?? 0;
        
        return Container(
          width: 160,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image section
              Stack(
                children: [
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: const Center(
                      child: Icon(Icons.restaurant, size: 60, color: Colors.grey),
                    ),
                  ),
                  // Veg indicator
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF4CAF50), width: 2),
                        borderRadius: BorderRadius.circular(3),
                        color: Colors.white,
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
                  ),
                ],
              ),
              // Details section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Item info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              if (item['originalPrice'] != null) ...[
                                Text(
                                  '₹${(item['originalPrice'] as num).toInt()}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[500],
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 4),
                              ],
                              Text(
                                '₹${(item['price'] as num).toInt()}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF4CAF50),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, size: 12, color: Color(0xFF4CAF50)),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  item['reviews'] != null 
                                      ? '${item['rating']} (${item['reviews']})'
                                      : '${item['rating']} • ${item['time'] ?? ''}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey[700],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Add button
                      SizedBox(
                        width: double.infinity,
                        height: 32,
                        child: itemCount == 0
                            ? Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    addToCart(
                                      itemId,
                                      item['name'] as String,
                                      (item['price'] as num).toDouble(),
                                      item['description'] as String? ?? '',
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: const Color(0xFF4CAF50), width: 1.5),
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
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () => removeFromCart(itemId),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Icon(Icons.remove, color: Colors.white, size: 16),
                                      ),
                                    ),
                                    Text(
                                      '$itemCount',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        addToCart(
                                          itemId,
                                          item['name'] as String,
                                          (item['price'] as num).toDouble(),
                                          item['description'] as String? ?? '',
                                        );
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Icon(Icons.add, color: Colors.white, size: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryIcon(String label, IconData icon, Color color) {
    return Container(
      width: 90,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, IconData? icon, {bool hasIcon = false, bool hasBolt = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF4CAF50)),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (hasIcon) ...[
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF4CAF50), width: 1.5),
                borderRadius: BorderRadius.circular(2),
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
            const SizedBox(width: 4),
          ],
          if (hasBolt) ...[
            const Icon(Icons.bolt, color: Color(0xFF4CAF50), size: 16),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (icon != null) ...[
            const SizedBox(width: 4),
            Icon(icon, size: 16),
          ],
        ],
      ),
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
            'area': restaurant['area'],
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
            Stack(
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: const Center(
                    child: Icon(Icons.restaurant, size: 80, color: Colors.grey),
                  ),
                ),
                if (restaurant['offer'].isNotEmpty)
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.local_offer, color: Colors.white, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            restaurant['offer'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      restaurant['time'],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF4CAF50), width: 2),
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Container(
                        width: 10,
                        height: 10,
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
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (restaurant['badge'] != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.emoji_events, size: 14, color: Color(0xFF4CAF50)),
                          const SizedBox(width: 4),
                          Text(
                            restaurant['badge'],
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF4CAF50),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Text(
                    restaurant['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, size: 12, color: Colors.white),
                            const SizedBox(width: 2),
                            Text(
                              restaurant['rating'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${restaurant['reviews']})',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '• ${restaurant['location']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${restaurant['cuisine']} • ${restaurant['price']}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
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