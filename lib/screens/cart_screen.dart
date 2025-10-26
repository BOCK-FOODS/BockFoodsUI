import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/instamart_cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final foodCart = Provider.of<FoodCartProvider>(context);
    final instamartCart = Provider.of<InstamartCartProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, elevation: 0, centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          const SizedBox(height: 6),
          Text('Food Cart', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (foodCart.items.isEmpty)
            const Text('Food cart is empty')
          else ...foodCart.items.values.map((ci) => Card(
            margin: const EdgeInsets.symmetric(vertical:6),
            child: ListTile(
              leading: Container(width:60,height:50,color: Colors.grey[200], child: Center(child: Text(ci.item.name.split(' ').first))),
              title: Text(ci.item.name),
              subtitle: Text('₹${ci.item.price.toStringAsFixed(0)}'),
              trailing: SizedBox(
                width:110,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: ()=> foodCart.removeSingle(ci.item.id), icon: const Icon(Icons.remove)),
                    Text('${ci.qty}'),
                    IconButton(onPressed: ()=> foodCart.addItem(ci.item), icon: const Icon(Icons.add)),
                  ],
                ),
              ),
            ),
          )).toList(),

          const SizedBox(height: 12),
          Text('Instamart Cart', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (instamartCart.items.isEmpty)
            const Text('Instamart cart is empty')
          else ...instamartCart.items.values.map((ci) => Card(
            margin: const EdgeInsets.symmetric(vertical:6),
            child: ListTile(
              leading: Container(width:60,height:50,color: Colors.grey[200], child: Center(child: Text(ci.item.name.split(' ').first))),
              title: Text(ci.item.name),
              subtitle: Text('₹${ci.item.price.toStringAsFixed(0)}'),
              trailing: SizedBox(
                width:110,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: ()=> instamartCart.removeSingle(ci.item.id), icon: const Icon(Icons.remove)),
                    Text('${ci.qty}'),
                    IconButton(onPressed: ()=> instamartCart.addItem(ci.item), icon: const Icon(Icons.add)),
                  ],
                ),
              ),
            ),
          )).toList(),

          const SizedBox(height: 24),
          Container(
            color: const Color(0xFFF7F9FB),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Food total'), Text('₹${foodCart.subtotal.toStringAsFixed(0)}'),]),
                const SizedBox(height:6),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Instamart total'), Text('₹${instamartCart.subtotal.toStringAsFixed(0)}'),]),
                const SizedBox(height:6),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Delivery Fee'), Text('₹20'),]),
                const Divider(),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Grand Total', style: TextStyle(fontWeight: FontWeight.bold)), Text('₹${(foodCart.subtotal + instamartCart.subtotal + 20).toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold)),]),
                const SizedBox(height:8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF27A600), padding: const EdgeInsets.symmetric(vertical:14)),
                    onPressed: (){
                      Navigator.of(context).pushNamed(CheckoutScreen.routeName);
                    },
                    child: Text('Pay ₹${(foodCart.subtotal + instamartCart.subtotal + 20).toStringAsFixed(0)}'),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
