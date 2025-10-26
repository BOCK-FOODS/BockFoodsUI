import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/instamart_cart_provider.dart';

class CheckoutScreen extends StatelessWidget {
  static const routeName = '/checkout';
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
  final foodCart = Provider.of<FoodCartProvider>(context);
  final instamartCart = Provider.of<InstamartCartProvider>(context);
  final total = foodCart.subtotal + instamartCart.subtotal + 20;
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout', style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, elevation: 0, centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Color(0xFF27A600)),
                title: const Text('Home - Bangalore'),
                subtitle: const Text('Change address'),
              ),
            ),
            const SizedBox(height:12),
            Card(
              child: Column(
                children: [
                  ListTile(title: const Text('Payment Method')),
                  RadioListTile(value: 'UPI', groupValue: 'UPI', onChanged: (_){}, title: const Text('UPI')),
                  RadioListTile(value: 'Card', groupValue: 'UPI', onChanged: (_){}, title: const Text('Card')),
                  RadioListTile(value: 'COD', groupValue: 'UPI', onChanged: (_){}, title: const Text('Cash on Delivery')),
                ],
              ),
            ),
            const Spacer(),
            Container(
              color: const Color(0xFFF7F9FB),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total'), Text('₹${0}', style: const TextStyle(fontWeight: FontWeight.bold))]),
                  const SizedBox(height:8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF27A600), padding: const EdgeInsets.symmetric(vertical:14)),
                      onPressed: (){
                        // Simulate order placed
                          foodCart.clear();
                          instamartCart.clear();
                        showDialog(context: context, builder: (_)=> AlertDialog(
                          title: const Text('Order placed'),
                          content: const Text('Your order has been placed successfully.'),
                          actions: [TextButton(onPressed: ()=> Navigator.of(context).popUntil((route) => route.isFirst), child: const Text('OK'))],
                        ));
                      },
                      child: Text('Place Order - ₹${total.toStringAsFixed(0)}'),
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
