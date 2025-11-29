import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/instamart_cart_provider.dart';
import '../models/food_item.dart';
import 'grocery_category_screen.dart';

class InstamartScreen extends StatefulWidget {
  static const routeName = '/instamart';
  const InstamartScreen({super.key});

  @override
  State<InstamartScreen> createState() => _InstamartScreenState();
}

class _InstamartScreenState extends State<InstamartScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _deliveryAddress = '';

  // Sample grocery items for hot deals
  final List<Map<String, dynamic>> groceryItems = [
    {'name': 'Fortune Sunlite Oil', 'price': '185', 'image': Icons.water_drop, 'category': 'Oils'},
    {'name': 'Parle-G Biscuits', 'price': '45', 'image': Icons.cookie, 'category': 'Biscuits'},
    {'name': 'Amul Pure Ghee', 'price': '550', 'image': Icons.liquor, 'category': 'Dairy'},
    {'name': 'India Gate Basmati', 'price': '320', 'image': Icons.grain, 'category': 'Rice'},
    {'name': 'Tata Tea Premium', 'price': '240', 'image': Icons.coffee, 'category': 'Beverages'},
    {'name': 'Britannia Bread', 'price': '35', 'image': Icons.breakfast_dining, 'category': 'Bread'},
  ];

  // Helper function to get cart count from provider
  int getItemCount(BuildContext context, String itemName) {
    final itemId = itemName.toLowerCase().replaceAll(' ', '_');
    final cart = Provider.of<InstamartCartProvider>(context);
    return cart.items[itemId]?.qty ?? 0;
  }

  void addToCart(String itemName) {
    final itemData = groceryItems.firstWhere((item) => item['name'] == itemName);
    
    final item = FoodItem(
      id: itemName.toLowerCase().replaceAll(' ', '_'),
      name: itemName,
      price: double.parse(itemData['price']),
      description: '',
      category: itemData['category'],
      imageUrl: '',
      isVeg: true,
    );
    
    Provider.of<InstamartCartProvider>(context, listen: false).addItem(item);
  }

  void removeFromCart(String itemName) {
    final itemId = itemName.toLowerCase().replaceAll(' ', '_');
    Provider.of<InstamartCartProvider>(context, listen: false).removeSingle(itemId);
  }

  void _navigateToCategory(String categoryName, IconData icon, Color color) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GroceryCategoryScreen(
          categoryName: categoryName,
          categoryIcon: icon,
          categoryColor: color,
        ),
      ),
    );
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
              backgroundColor: const Color(0xFF27A600),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 900;
    final screenWidth = MediaQuery.of(context).size.width;
    final cart = Provider.of<InstamartCartProvider>(context);
    
    // ADDING WILLPOPSCOPE WRAPPER
    return WillPopScope(
      onWillPop: () async {
        // Disable back button from leaving instamart screen
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          toolbarHeight: 70,
          title: GestureDetector(
            onTap: _showAddressDialog,
            child: Row(
              children: [
                const Icon(Icons.home, color: Color(0xFF27A600), size: 24),
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
                        _deliveryAddress.isEmpty ? '' : _deliveryAddress,
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
              icon: const CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 16,
                child: Icon(Icons.person, size: 20, color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/account');
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            // Search Bar
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: isWeb ? screenWidth * 0.125 : 16,
                vertical: 16,
              ),
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

            const SizedBox(height: 8),

            // Winter Prep Sale Banner
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: isWeb ? screenWidth * 0.125 : 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color.fromARGB(255, 49, 163, 36), Color.fromARGB(255, 59, 244, 31)],
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
                              
                              SizedBox(width: 4),
                              Text(
                                'Save\nMore',
                                style: TextStyle(
                                  color: Colors.green,
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
                horizontal: isWeb ? screenWidth * 0.125 : 16,
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
                              _buildDealCard('Free Delivery', 'On Min Order Value', Colors.green),
                              _buildDealCard('Seasonal Fruits\n& Veggies', 'STARTS AT ₹29', Colors.green),
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
                horizontal: isWeb ? screenWidth * 0.125 : 16,
              ),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 16, color: Colors.green),
                            SizedBox(width: 4),
                            Text(
                              'EXPIRES IN 7 Hours',
                              style: TextStyle(
                                color: Colors.green,
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
                horizontal: isWeb ? screenWidth * 0.125 : 16,
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
                  
                ],
              ),
            ),

            // Hot Deals Grid with Grocery Items
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isWeb ? screenWidth * 0.125 : 16,
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
                horizontal: isWeb ? screenWidth * 0.125 : 16,
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
                horizontal: isWeb ? screenWidth * 0.125 : 16,
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
                      _buildCategoryCard('Fresh Fruits', Icons.local_florist, Colors.orange),
                      _buildCategoryCard('Dairy and Bread\n', Icons.egg, Colors.blue),
                      _buildCategoryCard('Breakfast', Icons.breakfast_dining, Colors.amber),
                      _buildCategoryCard('Atta, Rice and\nDal', Icons.grain, Colors.brown),
                      _buildCategoryCard('Oils and Ghee', Icons.water_drop, Colors.yellow),
                      _buildCategoryCard('Masalas', Icons.restaurant, Colors.red),
                      _buildCategoryCard('Dry Fruits and\nSeeds Mix', Icons.food_bank, Colors.purple),
                      _buildCategoryCard('Biscuits and\nCakes', Icons.cookie, Colors.pink),
                      _buildCategoryCard('Tea, Coffee and\nMilk drinks', Icons.coffee, Colors.brown),
                      _buildCategoryCard('Sauces and\nSpreads', Icons.local_pizza, Colors.red),
                      _buildCategoryCard('Juices and\nBeverages', Icons.local_drink, Colors.red[900]!),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildGroceryCard(Map<String, dynamic> item) {
    final itemName = item['name'];
    
    return Consumer<InstamartCartProvider>(
      builder: (context, cart, child) {
        final itemCount = getItemCount(context, itemName);
        
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
      },
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
    return GestureDetector(
      onTap: () => _navigateToCategory(title, icon, color),
      child: Container(
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
      ),
    );
  }
}