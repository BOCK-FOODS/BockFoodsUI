import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/grocery_category.dart';
import '../models/grocery_item.dart';
import 'grocery_category_screen.dart';
// Import Provider for the "Add" button logic
import 'package:provider/provider.dart';
import '../providers/instamart_cart_provider.dart';

class InstamartScreen extends StatefulWidget {
  const InstamartScreen({Key? key}) : super(key: key);

  @override
  _InstamartScreenState createState() => _InstamartScreenState();
}

class _InstamartScreenState extends State<InstamartScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<GroceryCategory>> _categoriesFuture;
  late Future<List<GroceryItem>> _featuredFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _apiService.getGroceryCategories();
    _featuredFuture = _apiService.getFeaturedGroceries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner (Static for now)
            Container(
              width: double.infinity,
              height: 150,
              color: Colors.deepPurple,
              child: const Center(
                child: Text("Instamart\nGroceries in minutes", 
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)
                ),
              ),
            ),
            
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Shop By Category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            // CATEGORIES GRID
            SizedBox(
              height: 120,
              child: FutureBuilder<List<GroceryCategory>>(
                future: _categoriesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                  if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox();
                  
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final category = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          // FIXED: Passing the 'category' object, not 'categoryId'
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GroceryCategoryScreen(category: category),
                            ),
                          );
                        },
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 35,
                                backgroundImage: NetworkImage(category.imageUrl.isNotEmpty ? category.imageUrl : 'https://via.placeholder.com/150'),
                              ),
                              const SizedBox(height: 5),
                              Text(category.name, overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Hot Deals", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),

            // FEATURED ITEMS
            FutureBuilder<List<GroceryItem>>(
              future: _featuredFuture,
              builder: (context, snapshot) {
                 if (!snapshot.hasData) return const SizedBox();
                 return ListView.builder(
                   shrinkWrap: true,
                   physics: const NeverScrollableScrollPhysics(),
                   itemCount: snapshot.data!.length,
                   itemBuilder: (context, index) {
                     final item = snapshot.data![index];
                     return ListTile(
                       leading: Image.network(item.imageUrl ?? '', width: 50, height: 50, errorBuilder: (c,o,s)=>const Icon(Icons.shopping_bag)),
                       title: Text(item.name),
                       subtitle: Text("₹${item.price}"),
                       trailing: ElevatedButton(
                         onPressed: () {
                           // ADD TO CART LOGIC
                           Provider.of<InstamartCartProvider>(context, listen: false).addItem(
                             item.id, item.price.toDouble(), item.name, item.imageUrl ?? ""
                           );
                           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Added!")));
                         },
                         child: const Text("Add"),
                       ),
                     );
                   },
                 );
              },
            ),
          ],
        ),
      ),
    );
  }
}