import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // REQUIRED for Provider.of
import '../models/grocery_category.dart';
import '../models/grocery_item.dart';
import '../services/api_service.dart'; // Not used for cart anymore, but maybe for fetching
// REQUIRED: Import your provider
import '../providers/instamart_cart_provider.dart'; 

class GroceryCategoryScreen extends StatefulWidget {
  final GroceryCategory category;

  const GroceryCategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  _GroceryCategoryScreenState createState() => _GroceryCategoryScreenState();
}

class _GroceryCategoryScreenState extends State<GroceryCategoryScreen> {
  // If your category object already has items, use them. 
  // If not, you might need to fetch them here using ApiService.
  // For now, I assume category.items is populated.

  @override
  Widget build(BuildContext context) {
    // Fallback if items is null
    final items = widget.category.items ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: items.isEmpty
          ? const Center(child: Text("No items in this category"))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (ctx, i) => const Divider(),
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(item.imageUrl ?? 'https://via.placeholder.com/60'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("₹${item.price}"),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      // CORRECT ADD TO CART LOGIC
                      Provider.of<InstamartCartProvider>(context, listen: false).addItem(
                        item.id,
                        item.price.toDouble(),
                        item.name,
                        item.imageUrl ?? "",
                      );
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${item.name} added to cart")),
                      );
                    },
                    child: const Text("ADD", style: TextStyle(color: Colors.white)),
                  ),
                );
              },
            ),
    );
  }
}