import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/restaurant.dart'; // Ensure this exists or use your own model
// Import the provider
import '../providers/food_cart_provider.dart';

class FoodCard extends StatelessWidget {
  // Assuming you are passing a 'Restaurant' or 'MenuItem' object here
  // Adjust the type 'dynamic' to 'MenuItem' if you have that model
  final dynamic item; 

  const FoodCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: (item.imageUrl != null && item.imageUrl.isNotEmpty)
            ? Image.network(item.imageUrl, width: 60, height: 60, fit: BoxFit.cover)
            : Container(width: 60, height: 60, color: Colors.grey),
        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("₹${item.price}"),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
          onPressed: () {
            // FIX: Use Provider instead of ApiService
            Provider.of<FoodCartProvider>(context, listen: false).addItem(
              item.id.toString(),
              double.parse(item.price.toString()),
              item.name,
              item.imageUrl ?? "",
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${item.name} added to Food Cart!")),
            );
          },
          child: const Text("ADD", style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}