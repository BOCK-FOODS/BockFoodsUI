// lib/screens/grocery_store_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/grocery_store.dart';
import '../services/api_service.dart';

class GroceryStoreDetailScreen extends StatefulWidget {
  final String storeId;
  final String storeName;

  const GroceryStoreDetailScreen({Key? key, required this.storeId, required this.storeName}) : super(key: key);

  @override
  _GroceryStoreDetailScreenState createState() => _GroceryStoreDetailScreenState();
}

class _GroceryStoreDetailScreenState extends State<GroceryStoreDetailScreen> {
  late Future<GroceryStore> _storeFuture;
  final _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _storeFuture = _apiService.fetchGroceryStoreById(widget.storeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.storeName)),
      body: FutureBuilder<GroceryStore>(
        future: _storeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Store not found.'));
          }

          final store = snapshot.data!;
          return ListView.builder(
            itemCount: store.items.length,
            itemBuilder: (context, index) {
              final item = store.items[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: ListTile(
                  leading: item.imageUrl != null ? Image.network(item.imageUrl!, width: 50, height: 50, fit: BoxFit.cover) : const Icon(Icons.shopping_basket),
                  title: Text(item.name),
                  subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_shopping_cart, color: Colors.green),
                    onPressed: () {
                      _apiService.addItemToCart(context, groceryItemId: item.id);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${item.name} added to Instamart cart!'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}