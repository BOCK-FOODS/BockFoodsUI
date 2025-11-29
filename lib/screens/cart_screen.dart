import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bock_foods/providers/cart_provider.dart';
import 'package:bock_foods/providers/instamart_cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _selectedTab = 0; // 0 for Food, 1 for Instamart
  
  @override
  void initState() {
    super.initState();
    // Auto-select tab based on which cart has items
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final foodCart = Provider.of<FoodCartProvider>(context, listen: false);
      final instamartCart = Provider.of<InstamartCartProvider>(context, listen: false);
      
      if (foodCart.items.isEmpty && instamartCart.items.isNotEmpty) {
        setState(() {
          _selectedTab = 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final foodCart = Provider.of<FoodCartProvider>(context);
    final instamartCart = Provider.of<InstamartCartProvider>(context);
    final isWeb = MediaQuery.of(context).size.width > 900;
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FB),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Your Cart',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Center(
          child: Container(
            width: isWeb ? screenWidth * 0.75 : screenWidth,
            child: Column(
              children: [
                // Toggle Button
                _buildToggleButton(foodCart, instamartCart, isWeb),
                
                // Cart Content
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(isWeb ? 24 : 16),
                    children: [
                      _buildSectionHeader(
                        context,
                        _selectedTab == 0 ? 'Food Cart' : 'Instamart Cart',
                        _selectedTab == 0
                            ? foodCart.items.length
                            : instamartCart.items.length,
                      ),
                      const SizedBox(height: 12),
                      
                      // Display cart items based on selected tab
                      if (_selectedTab == 0) ...[
                        if (foodCart.items.isEmpty)
                          _buildEmptyCartMessage('Your food cart is empty')
                        else
                          ...foodCart.items.values.map((ci) => _buildCartItem(
                                context: context,
                                name: ci.item.name,
                                price: ci.item.price,
                                quantity: ci.qty,
                                onRemove: () => foodCart.removeSingle(ci.item.id),
                                onAdd: () => foodCart.addItem(ci.item),
                                isWeb: isWeb,
                              )),
                      ] else ...[
                        if (instamartCart.items.isEmpty)
                          _buildEmptyCartMessage('Your Instamart cart is empty')
                        else
                          ...instamartCart.items.values.map((ci) => _buildCartItem(
                                context: context,
                                name: ci.item.name,
                                price: ci.item.price,
                                quantity: ci.qty,
                                onRemove: () =>
                                    instamartCart.removeSingle(ci.item.id),
                                onAdd: () => instamartCart.addItem(ci.item),
                                isWeb: isWeb,
                              )),
                      ],

                      const SizedBox(height: 32),

                      // Bill Summary for selected cart
                      _buildBillSummary(
                        context: context,
                        foodCart: foodCart,
                        instamartCart: instamartCart,
                        isWeb: isWeb,
                        selectedTab: _selectedTab,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(FoodCartProvider foodCart,
      InstamartCartProvider instamartCart, bool isWeb) {
    return Container(
      margin: EdgeInsets.all(isWeb ? 24 : 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = 0;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: isWeb ? 14 : 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: _selectedTab == 0
                      ? const Color(0xFF27A600)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant,
                      color: _selectedTab == 0 ? Colors.white : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Food',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _selectedTab == 0 ? Colors.white : Colors.grey,
                      ),
                    ),
                    if (foodCart.items.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _selectedTab == 0
                              ? Colors.white.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${foodCart.items.length}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                _selectedTab == 0 ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = 1;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: isWeb ? 14 : 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: _selectedTab == 1
                      ? const Color(0xFF27A600)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      color: _selectedTab == 1 ? Colors.white : Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Instamart',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _selectedTab == 1 ? Colors.white : Colors.grey,
                      ),
                    ),
                    if (instamartCart.items.isNotEmpty) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _selectedTab == 1
                              ? Colors.white.withOpacity(0.3)
                              : Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${instamartCart.items.length}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                _selectedTab == 1 ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, int itemCount) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF27A600).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF27A600),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCartMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.shopping_bag_outlined,
              color: Colors.grey.shade400, size: 32),
          const SizedBox(width: 16),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem({
    required BuildContext context,
    required String name,
    required double price,
    required int quantity,
    required VoidCallback onRemove,
    required VoidCallback onAdd,
    required bool isWeb,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isWeb ? 16 : 12),
        child: Row(
          children: [
            Container(
              width: isWeb ? 70 : 60,
              height: isWeb ? 70 : 60,
              decoration: BoxDecoration(
                color: const Color(0xFF27A600).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  name.split(' ').first.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF27A600),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: isWeb ? 16 : 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: isWeb ? 15 : 14,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color(0xFF27A600), width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onRemove,
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(8)),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.remove,
                          size: 18,
                          color: Color(0xFF27A600),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Text(
                      '$quantity',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF27A600),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onAdd,
                      borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(8)),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Icon(
                          Icons.add,
                          size: 18,
                          color: Color(0xFF27A600),
                        ),
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

  Widget _buildBillSummary({
    required BuildContext context,
    required FoodCartProvider foodCart,
    required InstamartCartProvider instamartCart,
    required bool isWeb,
    required int selectedTab,
  }) {
    // Calculate based on selected tab
    final subtotal = selectedTab == 0 ? foodCart.subtotal : instamartCart.subtotal;
    final deliveryFee = 20.0;
    final gstCharges = (subtotal + deliveryFee) * 0.05;
    final grandTotal = subtotal + deliveryFee + gstCharges;

    // Don't show bill summary if cart is empty
    if (subtotal == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(isWeb ? 20 : 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              children: const [
                Icon(
                  Icons.receipt_long_outlined,
                  color: Color(0xFF27A600),
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  'Bill Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(isWeb ? 20 : 16),
            child: Column(
              children: [
                _buildBillRow(
                    selectedTab == 0 ? 'Food Total' : 'Instamart Total',
                    '₹${subtotal.toStringAsFixed(0)}'),
                const SizedBox(height: 12),
                _buildBillRow(
                    'Delivery Fee', '₹${deliveryFee.toStringAsFixed(0)}'),
                const SizedBox(height: 12),
                _buildBillRow('GST & Other Charges',
                    '₹${gstCharges.toStringAsFixed(2)}'),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child:
                      Divider(color: Colors.grey.shade300, thickness: 1),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Grand Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '₹${grandTotal.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF27A600),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF27A600),
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(
          vertical: isWeb ? 18 : 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0,
      shadowColor:
          const Color(0xFF27A600).withOpacity(0.3),
    ),
    onPressed: () {
      // Pass the selected order type to checkout screen
      Navigator.of(context).pushNamed(
        CheckoutScreen.routeName,
        arguments: {
          'orderType': selectedTab, // Pass which tab is currently selected (0 for Food, 1 for Instamart)
        },
      );
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'Proceed to Place Order',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(width: 8),
        Icon(Icons.arrow_forward, size: 20),
      ],
    ),
  ),
),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF27A600).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 18,
                        color: Color(0xFF27A600),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Free delivery on orders above ₹199',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
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
  }

  Widget _buildBillRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade700,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}