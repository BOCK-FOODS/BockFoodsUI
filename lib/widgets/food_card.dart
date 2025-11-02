import 'package:flutter/material.dart';
import '../models/food_item.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class FoodCard extends StatelessWidget {
  final FoodItem item;
  const FoodCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical:8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            // Placeholder for image
            Container(
              width: 80,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: Text(item.name.split(' ').first)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(item.isVeg ? Icons.circle : Icons.circle_outlined, size:12, color: item.isVeg ? Colors.green : Colors.red),
                      const SizedBox(width:6),
                      Expanded(child: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                      Text('₹${item.price.toStringAsFixed(0)}')
                    ],
                  ),
                  const SizedBox(height:6),
                  Text(item.description, maxLines:2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height:8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF27A600),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      ),
                      onPressed: (){
                        Provider.of<FoodCartProvider>(context, listen: false).addItem(item);
                        final snack = SnackBar(content: Text('${item.name} added to cart'));
                        ScaffoldMessenger.of(context).showSnackBar(snack);
                      },
                      child: const Text('ADD'),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
