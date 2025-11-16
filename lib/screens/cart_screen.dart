import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bock_foods/providers/cart_provider.dart';
import 'package:bock_foods/providers/instamart_cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final foodCart = Provider.of<FoodCartProvider>(context);
    final instamartCart = Provider.of<InstamartCartProvider>(context);
    final isWeb = MediaQuery.of(context).size.width > 900;
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        // Prevents user from going back
        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FB),
        appBar: AppBar(
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
            child: ListView(
              padding: EdgeInsets.all(isWeb ? 24 : 16),
              children: [
                _buildSectionHeader(context, 'Your Cart',
                    foodCart.items.length + instamartCart.items.length),
                const SizedBox(height: 12),
                if (foodCart.items.isEmpty && instamartCart.items.isEmpty)
                  _buildEmptyCartMessage('Your cart is empty')
                else
                  ...[
                    ...foodCart.items.values.map((ci) => _buildCartItem(
                          context: context,
                          name: ci.item.name,
                          price: ci.item.price,
                          quantity: ci.qty,
                          onRemove: () => foodCart.removeSingle(ci.item.id),
                          onAdd: () => foodCart.addItem(ci.item),
                          isWeb: isWeb,
                        )),
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

                // Bill Summary
                _buildBillSummary(
                  context: context,
                  foodCart: foodCart,
                  instamartCart: instamartCart,
                  isWeb: isWeb,
                ),
              ],
            ),
          ),
        ),
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
  }) {
    final subtotal = foodCart.subtotal + instamartCart.subtotal;
    final deliveryFee = 20.0;
    final gstCharges = (subtotal + deliveryFee) * 0.05;
    final grandTotal = subtotal + deliveryFee + gstCharges;

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
                if (foodCart.subtotal > 0)
                  _buildBillRow('Food Total',
                      '₹${foodCart.subtotal.toStringAsFixed(0)}'),

                if (instamartCart.subtotal > 0) ...[
                  const SizedBox(height: 12),
                  _buildBillRow(
                      'Instamart Total',
                      '₹${instamartCart.subtotal.toStringAsFixed(0)}'),
                ],

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
                      Navigator.of(context)
                          .pushNamed(CheckoutScreen.routeName);
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
