import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/instamart_cart_provider.dart';
import '../screens/home_screen.dart';
import '../main.dart';

class BottomCartSlider extends StatelessWidget {
  final String cartType; // 'food' or 'instamart'
  
  const BottomCartSlider({
    super.key,
    required this.cartType,
  });

  void _showCartReview(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CartReviewSheet(cartType: cartType),
    );
  }

  @override
  Widget build(BuildContext context) {
    return cartType == 'food'
        ? Consumer<FoodCartProvider>(
            builder: (context, cart, child) {
              if (cart.itemCount == 0) return const SizedBox.shrink();
              
              return _buildCartBar(context, cart.itemCount, cart.totalAmount);
            },
          )
        : Consumer<InstamartCartProvider>(
            builder: (context, cart, child) {
              if (cart.itemCount == 0) return const SizedBox.shrink();
              
              return _buildCartBar(context, cart.itemCount, cart.totalAmount);
            },
          );
  }

  Widget _buildCartBar(BuildContext context, int itemCount, double totalAmount) {
    return GestureDetector(
      onTap: () => _showCartReview(context),
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: cartType == 'food' 
              ? const Color(0xFF4CAF50)
              : const Color(0xFF27A600),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$itemCount ${itemCount == 1 ? 'Item' : 'Items'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'View Cart',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '₹${totalAmount.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.shopping_cart,
              color: Colors.white,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}

class _CartReviewSheet extends StatelessWidget {
  final String cartType;
  
  const _CartReviewSheet({required this.cartType});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header with savings badge
              cartType == 'food'
                  ? Consumer<FoodCartProvider>(
                      builder: (context, cart, child) => _buildHeader(context, cart.totalAmount),
                    )
                  : Consumer<InstamartCartProvider>(
                      builder: (context, cart, child) => _buildHeader(context, cart.totalAmount),
                    ),
              
              // Delivery info
              cartType == 'food'
                  ? Consumer<FoodCartProvider>(
                      builder: (context, cart, child) => _buildDeliveryInfo(cart.itemCount),
                    )
                  : Consumer<InstamartCartProvider>(
                      builder: (context, cart, child) => _buildDeliveryInfo(cart.itemCount),
                    ),
              
              const Divider(height: 1),
              
              // Items list
              Expanded(
                child: cartType == 'food'
                    ? Consumer<FoodCartProvider>(
                        builder: (context, cart, child) => _buildItemsList(context, cart, scrollController),
                      )
                    : Consumer<InstamartCartProvider>(
                        builder: (context, cart, child) => _buildItemsList(context, cart, scrollController),
                      ),
              ),
              
              // View Cart Button
              cartType == 'food'
                  ? Consumer<FoodCartProvider>(
                      builder: (context, cart, child) => _buildViewCartButton(context, cart.itemCount),
                    )
                  : Consumer<InstamartCartProvider>(
                      builder: (context, cart, child) => _buildViewCartButton(context, cart.itemCount),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, double totalAmount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Review Items',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo(int itemCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Text(
            'Fast Delivery',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(width: 8),
          const Text(
            '',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              children: [
                Icon(Icons.bolt, size: 12, color: Color(0xFF4CAF50)),
                SizedBox(width: 2),
                Text(
                  'Superfast',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Text(
            '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(BuildContext context, dynamic cart, ScrollController scrollController) {
    final items = cart.items.values.toList();
    
    return ListView.separated(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: items.length,
      separatorBuilder: (context, index) => const Divider(height: 24),
      itemBuilder: (context, index) {
        final cartItem = items[index];
        final foodItem = cartItem.item; // Access the FoodItem from FoodCartItem or InstamartCartItem
        
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item image placeholder
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.fastfood, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            
            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodItem.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${foodItem.price.toInt()}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Quantity controls
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: cartType == 'food' ? const Color(0xFF4CAF50) : const Color(0xFF27A600)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (cartType == 'food') {
                        Provider.of<FoodCartProvider>(context, listen: false).removeSingle(foodItem.id);
                      } else {
                        Provider.of<InstamartCartProvider>(context, listen: false).removeSingle(foodItem.id);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.remove,
                        size: 18,
                        color: cartType == 'food' ? const Color(0xFF4CAF50) : const Color(0xFF27A600),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '${cartItem.qty}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (cartType == 'food') {
                        Provider.of<FoodCartProvider>(context, listen: false).addItem(foodItem);
                      } else {
                        Provider.of<InstamartCartProvider>(context, listen: false).addItem(foodItem);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(
                        Icons.add,
                        size: 18,
                        color: cartType == 'food' ? const Color(0xFF4CAF50) : const Color(0xFF27A600),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildViewCartButton(BuildContext context, int itemCount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: cartType == 'food' 
                    ? const Color(0xFF4CAF50).withOpacity(0.1)
                    : const Color(0xFF27A600).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: cartType == 'food' ? const Color(0xFF4CAF50) : const Color(0xFF27A600),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$itemCount ${itemCount == 1 ? 'Item' : 'Items'}',
                    style: TextStyle(
                      color: cartType == 'food' ? const Color(0xFF4CAF50) : const Color(0xFF27A600),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
              Navigator.pop(context); // Close bottom sheet first
              
              // Use the global navigator key to access the home screen state
              final navigatorContext = navigatorKey.currentContext;
              if (navigatorContext != null) {
                HomeScreen.switchToCart(navigatorContext);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: cartType == 'food' ? const Color(0xFF4CAF50) : const Color(0xFF27A600),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Close',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);
  }}

