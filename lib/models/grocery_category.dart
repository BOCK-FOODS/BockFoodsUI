import 'grocery_item.dart';

class GroceryCategory {
  final String id;
  final String name;
  final String imageUrl;
  // This was missing and causing the error
  final List<GroceryItem>? items; 

  GroceryCategory({
    required this.id, 
    required this.name, 
    required this.imageUrl,
    this.items,
  });

  factory GroceryCategory.fromJson(Map<String, dynamic> json) {
    // Safely parse the items list if the backend sends it
    var list = json['items'] as List<dynamic>?;
    List<GroceryItem>? itemsList = list != null 
        ? list.map((i) => GroceryItem.fromJson(i)).toList() 
        : [];

    return GroceryCategory(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      items: itemsList,
    );
  }
}