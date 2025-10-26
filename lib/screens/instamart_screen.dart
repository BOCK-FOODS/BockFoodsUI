import 'package:flutter/material.dart';
import '../widgets/instamart_card.dart';
import '../models/sample_data.dart';

class InstamartScreen extends StatefulWidget {
  static const routeName = '/instamart';
  const InstamartScreen({super.key});

  @override
  State<InstamartScreen> createState() => _InstamartScreenState();
}

class _InstamartScreenState extends State<InstamartScreen> {
  // Sample grocery items for hot deals
  final List<Map<String, dynamic>> groceryItems = [
    {'name': 'Fortune Sunlite Oil', 'price': '185', 'image': Icons.water_drop},
    {'name': 'Parle-G Biscuits', 'price': '45', 'image': Icons.cookie},
    {'name': 'Amul Pure Ghee', 'price': '550', 'image': Icons.liquor},
    {'name': 'India Gate Basmati', 'price': '320', 'image': Icons.grain},
    {'name': 'Tata Tea Premium', 'price': '240', 'image': Icons.coffee},
    {'name': 'Britannia Bread', 'price': '35', 'image': Icons.breakfast_dining},
  ];

  Map<String, int> cartItems = {};

  void addToCart(String itemName) {
    setState(() {
      cartItems[itemName] = (cartItems[itemName] ?? 0) + 1;
    });
  }

  void removeFromCart(String itemName) {
    setState(() {
      if (cartItems[itemName] != null && cartItems[itemName]! > 0) {
        cartItems[itemName] = cartItems[itemName]! - 1;
        if (cartItems[itemName] == 0) {
          cartItems.remove(itemName);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 900;
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 70,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                const Text('8 mins', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'To Home: B- Block, flat No. 305, Malibu Rising Cit...',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 16,
              child: Icon(Icons.person, size: 20, color: Colors.white),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        children: [
          // Search Bar
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: isWeb ? screenWidth * 0.15 : 16,
              vertical: 16,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for "Perfume"',
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.mic_none, color: Colors.grey),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_border, color: Colors.grey),
                  onPressed: () {},
                ),
              ],
            ),
          ),

          // Category Icons
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: isWeb ? screenWidth * 0.15 : 8,
              vertical: 12,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryIcon(Icons.shopping_basket, 'All', Colors.blue),
                  _buildCategoryIcon(Icons.kitchen, 'Midsummer', Colors.grey),
                  _buildCategoryIcon(Icons.local_drink, 'Deals Drop', Colors.grey),
                  _buildCategoryIcon(Icons.card_giftcard, 'Fresh', Colors.grey),
                  _buildCategoryIcon(Icons.medication, 'Medicines', Colors.grey),
                  _buildCategoryIcon(Icons.pets, 'Meowgic', Colors.grey),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Winter Prep Sale Banner
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: isWeb ? screenWidth * 0.15 : 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/winter_bottle.png',
                        width: 60,
                        height: 60,
                        errorBuilder: (context, error, stackTrace) => 
                          const Icon(Icons.local_drink, size: 60, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'WINTER\nPREP SALE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.arrow_forward, color: Colors.blue),
                            SizedBox(width: 4),
                            Text(
                              'Save\nMore',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
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

          // Daily Deal Drop Section
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: isWeb ? screenWidth * 0.15 : 16,
              vertical: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'DAILY\nDEAL\nDROP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildDealCard('Prep for\nWinter', 'UP TO 20% OFF', Colors.green),
                            _buildDealCard('Benjamins', 'NEW ARRIVAL', Colors.blue),
                            _buildDealCard('Seasonal Fruits\n& Veggies', 'STARTS AT ₹29', Colors.orange),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Free Cash Promotion
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: isWeb ? screenWidth * 0.15 : 16,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 16, color: Colors.blue),
                          SizedBox(width: 4),
                          Text(
                            'EXPIRES IN 7 Hours',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Claim your ₹75 FREE cash now!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'On your order above ₹399. T&C applied',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/gift_box.png',
                  width: 50,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.card_giftcard, size: 50, color: Colors.red),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Hot Deals Section
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWeb ? screenWidth * 0.15 : 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Hot deals',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Row(
                    children: [
                      Text('See All', style: TextStyle(color: Colors.green)),
                      Icon(Icons.arrow_forward, size: 16, color: Colors.green),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Hot Deals Grid with Grocery Items
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isWeb ? screenWidth * 0.15 : 16,
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                int crossAxisCount;
                if (isWeb) {
                  crossAxisCount = 4;
                } else {
                  crossAxisCount = 2;
                }
                
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: isWeb ? 0.85 : 0.7,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: groceryItems.length,
                  itemBuilder: (context, index) {
                    return _buildGroceryCard(groceryItems[index]);
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Free Delivery Banner
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: isWeb ? screenWidth * 0.15 : 16,
              vertical: 8,
            ),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Hooray! FREE DELIVERY unlocked',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Grocery & Kitchen Categories
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWeb ? screenWidth * 0.15 : 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Grocery & Kitchen',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: isWeb ? 6 : 3,
                  childAspectRatio: 0.85,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _buildCategoryCard('Fresh\nVegetables', Icons.eco, Colors.green),
                    _buildCategoryCard('Fresh Fruits', Icons.apple, Colors.orange),
                    _buildCategoryCard('Dairy, Bread\nand Eggs', Icons.egg, Colors.blue),
                    _buildCategoryCard('Breakfast &\nbreakfast', Icons.breakfast_dining, Colors.amber),
                    _buildCategoryCard('Atta, Rice and\nDal', Icons.grain, Colors.brown),
                    _buildCategoryCard('Oils and Ghee', Icons.water_drop, Colors.yellow),
                    _buildCategoryCard('Masalas', Icons.restaurant, Colors.red),
                    _buildCategoryCard('Dry Fruits and\nSeeds Mix', Icons.food_bank, Colors.purple),
                    _buildCategoryCard('Biscuits and\nCakes', Icons.cookie, Colors.pink),
                    _buildCategoryCard('Tea, Coffee and\nMilk drinks', Icons.coffee, Colors.brown),
                    _buildCategoryCard('Sauces and\nSpreads', Icons.local_pizza, Colors.red),
                    _buildCategoryCard('Meat and\nSeafood', Icons.set_meal, Colors.red[900]!),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildGroceryCard(Map<String, dynamic> item) {
    final itemName = item['name'];
    final itemCount = cartItems[itemName] ?? 0;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(
                child: Icon(
                  item['image'] as IconData,
                  size: 60,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
          // Product Details
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
                        itemName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₹${item['price']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  // Add Button or Counter
                  itemCount == 0
                      ? GestureDetector(
                          onTap: () => addToCart(itemName),
                          child: Container(
                            height: 32,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'ADD',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () => removeFromCart(itemName),
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              Text(
                                '$itemCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => addToCart(itemName),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 18,
                                ),
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

  Widget _buildCategoryIcon(IconData icon, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: color == Colors.blue ? Colors.blue : Colors.grey[700],
              fontWeight: color == Colors.blue ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDealCard(String title, String subtitle, Color color) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              subtitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(String title, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}