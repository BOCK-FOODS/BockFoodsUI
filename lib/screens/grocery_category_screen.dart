import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/instamart_cart_provider.dart';
import '../models/food_item.dart';
import '../widgets/bottom_cart_slider.dart';

class GroceryCategoryScreen extends StatefulWidget {
  static const routeName = '/grocery-category';
  
  final String categoryName;
  final IconData categoryIcon;
  final Color categoryColor;

  const GroceryCategoryScreen({
    super.key,
    required this.categoryName,
    required this.categoryIcon,
    required this.categoryColor,
  });

  @override
  State<GroceryCategoryScreen> createState() => _GroceryCategoryScreenState();
}

class _GroceryCategoryScreenState extends State<GroceryCategoryScreen> {
  
  // Sample data for different categories
  Map<String, List<Map<String, dynamic>>> getCategoryItems() {
    return {
      'Fresh\nVegetables': [
        {'name': 'Tomato', 'price': '25', 'unit': '1 kg', 'image': Icons.eco},
        {'name': 'Onion', 'price': '30', 'unit': '1 kg', 'image': Icons.eco},
        {'name': 'Potato', 'price': '20', 'unit': '1 kg', 'image': Icons.eco},
        {'name': 'Carrot', 'price': '40', 'unit': '500g', 'image': Icons.eco},
        {'name': 'Cauliflower', 'price': '35', 'unit': '1 piece', 'image': Icons.eco},
        {'name': 'Cabbage', 'price': '28', 'unit': '1 piece', 'image': Icons.eco},
        {'name': 'Capsicum', 'price': '45', 'unit': '250g', 'image': Icons.eco},
        {'name': 'Brinjal', 'price': '32', 'unit': '500g', 'image': Icons.eco},
      ],
      'Fresh Fruits': [
        {'name': 'Apple - Red', 'price': '150', 'unit': '1 kg', 'image': Icons.apple},
        {'name': 'Banana', 'price': '50', 'unit': '12 pieces', 'image': Icons.apple},
        {'name': 'Orange', 'price': '80', 'unit': '1 kg', 'image': Icons.apple},
        {'name': 'Mango - Alphonso', 'price': '200', 'unit': '1 kg', 'image': Icons.apple},
        {'name': 'Grapes - Green', 'price': '120', 'unit': '500g', 'image': Icons.apple},
        {'name': 'Watermelon', 'price': '40', 'unit': '1 kg', 'image': Icons.apple},
        {'name': 'Papaya', 'price': '35', 'unit': '1 kg', 'image': Icons.apple},
        {'name': 'Pomegranate', 'price': '180', 'unit': '1 kg', 'image': Icons.apple},
      ],
      'Dairy and Bread\n': [
        {'name': 'Amul Butter', 'price': '250', 'unit': '500g', 'image': Icons.egg},
        {'name': 'Mother Dairy Milk', 'price': '60', 'unit': '1L', 'image': Icons.egg},
        {'name': 'Britannia Bread', 'price': '35', 'unit': '400g', 'image': Icons.egg},
        {'name': 'Amul Cheese Slices', 'price': '140', 'unit': '200g', 'image': Icons.egg},
        {'name': 'Farm Fresh Eggs', 'price': '75', 'unit': '12 pieces', 'image': Icons.egg},
        {'name': 'Nestle Dahi', 'price': '30', 'unit': '400g', 'image': Icons.egg},
        {'name': 'Amul Paneer', 'price': '95', 'unit': '200g', 'image': Icons.egg},
        {'name': 'Mother Dairy Curd', 'price': '28', 'unit': '400g', 'image': Icons.egg},
      ],
      'Breakfast': [
        {'name': 'Kelloggs Corn Flakes', 'price': '180', 'unit': '475g', 'image': Icons.breakfast_dining},
        {'name': 'Quaker Oats', 'price': '165', 'unit': '1 kg', 'image': Icons.breakfast_dining},
        {'name': 'Nestle Corn Flakes', 'price': '150', 'unit': '475g', 'image': Icons.breakfast_dining},
        {'name': 'Muesli - Bagrry\'s', 'price': '280', 'unit': '500g', 'image': Icons.breakfast_dining},
        {'name': 'Granola Mix', 'price': '320', 'unit': '400g', 'image': Icons.breakfast_dining},
        {'name': 'Chocos - Kellogg\'s', 'price': '195', 'unit': '375g', 'image': Icons.breakfast_dining},
        {'name': 'Saffola Oats', 'price': '155', 'unit': '1 kg', 'image': Icons.breakfast_dining},
        {'name': 'Cornitos Cornflakes', 'price': '140', 'unit': '475g', 'image': Icons.breakfast_dining},
      ],
      'Atta, Rice and\nDal': [
        {'name': 'Aashirvaad Atta', 'price': '350', 'unit': '5 kg', 'image': Icons.grain},
        {'name': 'India Gate Basmati', 'price': '320', 'unit': '1 kg', 'image': Icons.grain},
        {'name': 'Toor Dal', 'price': '140', 'unit': '1 kg', 'image': Icons.grain},
        {'name': 'Moong Dal', 'price': '160', 'unit': '1 kg', 'image': Icons.grain},
        {'name': 'Masoor Dal', 'price': '120', 'unit': '1 kg', 'image': Icons.grain},
        {'name': 'Fortune Chakki Atta', 'price': '340', 'unit': '5 kg', 'image': Icons.grain},
        {'name': 'Daawat Basmati Rice', 'price': '310', 'unit': '1 kg', 'image': Icons.grain},
        {'name': 'Chana Dal', 'price': '130', 'unit': '1 kg', 'image': Icons.grain},
      ],
      'Oils and Ghee': [
        {'name': 'Fortune Sunlite Oil', 'price': '185', 'unit': '1L', 'image': Icons.water_drop},
        {'name': 'Amul Pure Ghee', 'price': '550', 'unit': '1L', 'image': Icons.water_drop},
        {'name': 'Saffola Gold Oil', 'price': '210', 'unit': '1L', 'image': Icons.water_drop},
        {'name': 'Dalda Vanaspati', 'price': '95', 'unit': '500g', 'image': Icons.water_drop},
        {'name': 'Dhara Mustard Oil', 'price': '175', 'unit': '1L', 'image': Icons.water_drop},
        {'name': 'Nature Fresh Oil', 'price': '168', 'unit': '1L', 'image': Icons.water_drop},
        {'name': 'Patanjali Ghee', 'price': '520', 'unit': '1L', 'image': Icons.water_drop},
        {'name': 'Sundrop Heart Oil', 'price': '195', 'unit': '1L', 'image': Icons.water_drop},
      ],
      'Masalas': [
        {'name': 'MDH Garam Masala', 'price': '85', 'unit': '100g', 'image': Icons.restaurant},
        {'name': 'Everest Turmeric', 'price': '55', 'unit': '100g', 'image': Icons.restaurant},
        {'name': 'Catch Red Chilli', 'price': '65', 'unit': '100g', 'image': Icons.restaurant},
        {'name': 'MDH Biryani Masala', 'price': '95', 'unit': '100g', 'image': Icons.restaurant},
        {'name': 'Everest Coriander', 'price': '50', 'unit': '100g', 'image': Icons.restaurant},
        {'name': 'Catch Chat Masala', 'price': '48', 'unit': '100g', 'image': Icons.restaurant},
        {'name': 'MDH Kasuri Methi', 'price': '68', 'unit': '25g', 'image': Icons.restaurant},
        {'name': 'Everest Pav Bhaji', 'price': '72', 'unit': '100g', 'image': Icons.restaurant},
      ],
      'Dry Fruits and\nSeeds Mix': [
        {'name': 'Almonds', 'price': '650', 'unit': '500g', 'image': Icons.food_bank},
        {'name': 'Cashews', 'price': '580', 'unit': '500g', 'image': Icons.food_bank},
        {'name': 'Raisins', 'price': '280', 'unit': '500g', 'image': Icons.food_bank},
        {'name': 'Walnuts', 'price': '720', 'unit': '500g', 'image': Icons.food_bank},
        {'name': 'Pistachios', 'price': '850', 'unit': '500g', 'image': Icons.food_bank},
        {'name': 'Mixed Dry Fruits', 'price': '480', 'unit': '400g', 'image': Icons.food_bank},
        {'name': 'Dates - Premium', 'price': '320', 'unit': '500g', 'image': Icons.food_bank},
        {'name': 'Pumpkin Seeds', 'price': '280', 'unit': '250g', 'image': Icons.food_bank},
      ],
      'Biscuits and\nCakes': [
        {'name': 'Parle-G Biscuits', 'price': '45', 'unit': '800g', 'image': Icons.cookie},
        {'name': 'Britannia Good Day', 'price': '55', 'unit': '600g', 'image': Icons.cookie},
        {'name': 'Oreo Cookies', 'price': '85', 'unit': '600g', 'image': Icons.cookie},
        {'name': 'Dark Fantasy', 'price': '95', 'unit': '600g', 'image': Icons.cookie},
        {'name': 'Monaco Biscuits', 'price': '38', 'unit': '400g', 'image': Icons.cookie},
        {'name': 'Bourbon Biscuits', 'price': '42', 'unit': '400g', 'image': Icons.cookie},
        {'name': 'Britannia NutriChoice', 'price': '68', 'unit': '500g', 'image': Icons.cookie},
        {'name': 'Hide & Seek', 'price': '58', 'unit': '600g', 'image': Icons.cookie},
      ],
      'Tea, Coffee and\nMilk drinks': [
        {'name': 'Tata Tea Premium', 'price': '240', 'unit': '1 kg', 'image': Icons.coffee},
        {'name': 'Red Label Tea', 'price': '220', 'unit': '1 kg', 'image': Icons.coffee},
        {'name': 'Nescafe Classic', 'price': '285', 'unit': '200g', 'image': Icons.coffee},
        {'name': 'Bru Coffee', 'price': '265', 'unit': '200g', 'image': Icons.coffee},
        {'name': 'Horlicks', 'price': '385', 'unit': '1 kg', 'image': Icons.coffee},
        {'name': 'Boost', 'price': '375', 'unit': '1 kg', 'image': Icons.coffee},
        {'name': 'Taj Mahal Tea', 'price': '235', 'unit': '1 kg', 'image': Icons.coffee},
        {'name': 'Complan', 'price': '395', 'unit': '1 kg', 'image': Icons.coffee},
      ],
      'Sauces and\nSpreads': [
        {'name': 'Maggi Tomato Ketchup', 'price': '95', 'unit': '1 kg', 'image': Icons.local_pizza},
        {'name': 'Kissan Mixed Jam', 'price': '180', 'unit': '700g', 'image': Icons.local_pizza},
        {'name': 'Veeba Mayonnaise', 'price': '145', 'unit': '700g', 'image': Icons.local_pizza},
        {'name': 'Ching\'s Chilli Sauce', 'price': '85', 'unit': '680g', 'image': Icons.local_pizza},
        {'name': 'Nutella', 'price': '425', 'unit': '750g', 'image': Icons.local_pizza},
        {'name': 'Del Monte Pasta Sauce', 'price': '135', 'unit': '700g', 'image': Icons.local_pizza},
        {'name': 'Heinz Tomato Ketchup', 'price': '110', 'unit': '900g', 'image': Icons.local_pizza},
        {'name': 'Tops Tomato Sauce', 'price': '75', 'unit': '900g', 'image': Icons.local_pizza},
      ],
      'Juices and\nBeverages': [
        {'name': 'Real Fruit Juice - Orange', 'price': '120', 'unit': '1L', 'image': Icons.local_drink},
        {'name': 'Tropicana Juice - Mixed Fruit', 'price': '135', 'unit': '1L', 'image': Icons.local_drink},
        {'name': 'Paper Boat Aamras', 'price': '45', 'unit': '250ml', 'image': Icons.local_drink},
        {'name': 'B Natural Juice - Apple', 'price': '110', 'unit': '1L', 'image': Icons.local_drink},
        {'name': 'Frooti Mango Drink', 'price': '80', 'unit': '1.2L', 'image': Icons.local_drink},
        {'name': 'Coca Cola', 'price': '90', 'unit': '2L', 'image': Icons.local_drink},
        {'name': 'Pepsi', 'price': '85', 'unit': '2L', 'image': Icons.local_drink},
        {'name': 'Red Bull Energy Drink', 'price': '125', 'unit': '250ml', 'image': Icons.local_drink},
      ],
    };
  }

  // Helper function to get cart count from provider
  int getItemCount(BuildContext context, String itemName) {
    final itemId = itemName.toLowerCase().replaceAll(' ', '_');
    final cart = Provider.of<InstamartCartProvider>(context);
    return cart.items[itemId]?.qty ?? 0;
  }

  void addToCart(String itemName) {
    final itemData = getCategoryItems()[widget.categoryName]!
        .firstWhere((item) => item['name'] == itemName);
    
    final item = FoodItem(
      id: itemName.toLowerCase().replaceAll(' ', '_'),
      name: itemName,
      price: double.parse(itemData['price']),
      description: itemData['unit'],
      category: widget.categoryName,
      imageUrl: '',
      isVeg: true,
    );
    
    Provider.of<InstamartCartProvider>(context, listen: false).addItem(item);
  }

  void removeFromCart(String itemName) {
    final itemId = itemName.toLowerCase().replaceAll(' ', '_');
    Provider.of<InstamartCartProvider>(context, listen: false).removeSingle(itemId);
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = MediaQuery.of(context).size.width > 900;
    final screenWidth = MediaQuery.of(context).size.width;
    final cart = Provider.of<InstamartCartProvider>(context);
    final totalCartItems = cart.items.values.fold(0, (sum, item) => sum + item.qty);
    
    final items = getCategoryItems()[widget.categoryName] ?? [];
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.categoryName.replaceAll('\n', ' '),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Category Header Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: isWeb ? screenWidth * 0.125 : 16,
                  vertical: 24,
                ),
                decoration: BoxDecoration(
                  color: widget.categoryColor.withOpacity(0.1),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: widget.categoryColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.categoryIcon,
                        size: 40,
                        color: widget.categoryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.categoryName.replaceAll('\n', ' '),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${items.length} items available',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Items Grid
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(
                      left: isWeb ? screenWidth * 0.125 : 16,
                      right: isWeb ? screenWidth * 0.125 : 16,
                      top: 16,
                      bottom: totalCartItems > 0 ? 100 : 16, // Extra padding when cart has items
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isWeb ? 4 : 2,
                        childAspectRatio: isWeb ? 0.75 : 0.65,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return _buildProductCard(items[index]);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Bottom Cart Slider
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomCartSlider(cartType: 'instamart'),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> item) {
    final itemName = item['name'];
    
    return Consumer<InstamartCartProvider>(
      builder: (context, cart, child) {
        final itemCount = getItemCount(context, itemName);
        
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
              // Product Image
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: widget.categoryColor.withOpacity(0.05),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Center(
                    child: Icon(
                      item['image'] as IconData,
                      size: 70,
                      color: widget.categoryColor.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
              // Product Details
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                    const SizedBox(height: 4),
                    Text(
                      item['unit'],
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${item['price']}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Add Button or Counter
                    itemCount == 0
                        ? GestureDetector(
                            onTap: () => addToCart(itemName),
                            child: Container(
                              height: 34,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green, width: 2),
                              ),
                              child: const Center(
                                child: Text(
                                  'ADD',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            height: 34,
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
            ],
          ),
        );
      },
    );
  }
}