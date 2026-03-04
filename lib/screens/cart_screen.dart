import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/food_cart_provider.dart';
import '../providers/instamart_cart_provider.dart';
import '../models/cart_item.dart'; // Import the shared model
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Cart', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          bottom: const TabBar(
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.green,
            tabs: [
              Tab(text: "Food Delivery", icon: Icon(Icons.restaurant)),
              Tab(text: "Instamart", icon: Icon(Icons.shopping_basket)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // TAB 1: FOOD CART
            Consumer<FoodCartProvider>(
              builder: (context, cart, child) => _buildCartList(
                context, 
                cart.items.values.toList(), 
                cart.totalAmount, 
                cart.clearCart, 
                cart.addItem, 
                cart.removeSingleItem,
                "Food"
              ),
            ),
            // TAB 2: INSTAMART CART
            Consumer<InstamartCartProvider>(
              builder: (context, cart, child) => _buildCartList(
                context, 
                cart.items.values.toList(), 
                cart.totalAmount, 
                cart.clearCart, 
                cart.addItem, 
                cart.removeSingleItem,
                "Grocery"
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Reusing your Teammate's UI Logic ---
  Widget _buildCartList(
    BuildContext context, 
    List<CartItem> cartItems, 
    double totalAmount, 
    Function clearCart, 
    Function addItem, 
    Function removeItem,
    String type
  ) {
    if (cartItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(type == "Food" ? Icons.no_meals : Icons.remove_shopping_cart, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 20),
            Text('Your $type cart is empty!', style: const TextStyle(fontSize: 18, color: Colors.grey)),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Clear Cart Button (Added for convenience)
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => clearCart(),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            label: const Text("Clear Cart", style: TextStyle(color: Colors.red)),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                      ? NetworkImage(item.imageUrl!) 
                      : null,
                    child: (item.imageUrl == null || item.imageUrl!.isEmpty)
                      ? Icon(type == "Food" ? Icons.fastfood : Icons.local_grocery_store, color: Colors.green)
                      : null,
                  ),
                  title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Total: ₹${(item.price * item.quantity).toStringAsFixed(2)}'),
                  trailing: Container(
                    width: 120,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () => removeItem(item.id),
                          child: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.remove, size: 16, color: Colors.green)),
                        ),
                        Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
                        InkWell(
                          onTap: () => addItem(item.id, item.price, item.title, item.imageUrl ?? ""),
                          child: const Padding(padding: EdgeInsets.all(8.0), child: Icon(Icons.add, size: 16, color: Colors.green)),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, -5))],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Amount:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('₹${totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
  width: double.infinity,
  height: 50,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
    onPressed: () {
      // NAVIGATE TO CHECKOUT SCREEN
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutScreen(
            cartItems: cartItems,
            totalAmount: totalAmount,
            orderType: type, // "Food" or "Grocery" passed from previous step
          ),
        ),
      ).then((_) {
        // Optional: Clear cart if order was successful? 
        // Usually done inside Checkout, but if you want to clear it here:
        // clearCart(); 
      });
    },
    child: const Text("PROCEED TO PAY", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
  ),
),
            ],
          ),
        ),
      ],
    );
  }
}