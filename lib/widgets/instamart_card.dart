import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../providers/instamart_cart_provider.dart' as instamart;
import 'package:provider/provider.dart';

class InstamartCard extends StatelessWidget {
  final FoodItem item;
  const InstamartCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical:8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 60,
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
              child: Center(child: Text(item.name.split(' ').first)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height:6),
                  Text('₹${item.price.toStringAsFixed(0)}', style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF27A600)),
              onPressed: (){
                Provider.of<instamart.InstamartCartProvider>(context, listen: false).addItem(item);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item.name} added to instamart cart')));
              },
              child: const Text('ADD'),
            )
          ],
        ),
      ),
    );
  }
}
