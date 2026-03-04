import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart'; // Make sure this is here
// Adjust path if needed
import '../providers/food_cart_provider.dart'; 
import 'cart_screen.dart';


class RestaurantDetailFinal extends StatefulWidget {
  final String restaurantId;
  const RestaurantDetailFinal({Key? key, required this.restaurantId}) : super(key: key);

  @override
  State<RestaurantDetailFinal> createState() => _RestaurantDetailFinalState();
}

class _RestaurantDetailFinalState extends State<RestaurantDetailFinal> {
  Map<String, dynamic>? restaurant;
  List<dynamic> menu = [];
  bool isLoading = true;
  String? errorMessage; // Variable to hold the specific error

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = 'http://localhost:3000/api/restaurants/${widget.restaurantId}';
    print("Fetching URL: $url"); // Print to console for debugging

    try {
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          restaurant = data;
          menu = data['menuItems'] ?? [];
          isLoading = false;
        });
      } else {
        // CAPTURE THE SERVER ERROR
        setState(() {
          isLoading = false;
          errorMessage = "Server Error: ${response.statusCode}\nBody: ${response.body}";
        });
      }
    } catch (e) {
      // CAPTURE NETWORK ERRORS
      setState(() {
        isLoading = false;
        errorMessage = "Network Error: $e";
      });
    }
  }

   @override
  Widget build(BuildContext context) {
    // Access the cart provider
    final cart = Provider.of<FoodCartProvider>(context, listen: false);

    if (isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (restaurant == null) return const Scaffold(body: Center(child: Text("No Data")));

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Go to Cart Screen
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CartScreen()));
        },
        label: const Text("View Cart"),
        icon: const Icon(Icons.shopping_cart),
        backgroundColor: Colors.orange,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(restaurant!['name'] ?? 'Restaurant', style: const TextStyle(color: Colors.black)),
              background: restaurant!['imageUrl'] != null
                  ? Image.network(restaurant!['imageUrl'], fit: BoxFit.cover, errorBuilder: (c,o,s)=>Container(color:Colors.grey))
                  : Container(color: Colors.grey),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(restaurant!['cuisine'] ?? '', style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 10),
                  const Text("Menu", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final item = menu[index];
              
              // EXTRACT DATA SAFLY
              final String itemId = item['id'].toString();
              final String itemName = item['name'] ?? 'Unknown';
              // Ensure price is a double (sometimes API sends Int or String)
              final double itemPrice = double.tryParse(item['price'].toString()) ?? 0.0;
              final String itemImage = item['imageUrl'] ?? '';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(itemName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(item['description'] ?? ''),
                  // PRICE
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("₹$itemPrice", style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  // ADD BUTTON
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Swiggy Green
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      // 1. ADD TO CART LOGIC
                      cart.addItem(itemId, itemPrice, itemName, itemImage);
                      
                      // 2. Show Feedback
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$itemName added to cart!'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: const Text("ADD", style: TextStyle(color: Colors.white)),
                  ),
                ),
              );
            }, childCount: menu.length),
          )
        ],
      ),
    );
  }
}