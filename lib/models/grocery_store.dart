import 'grocery_item.dart';

class GroceryStore {
  final String id;
  final String name;
  final List<GroceryItem> items;

  GroceryStore({required this.id, required this.name, required this.items});

  factory GroceryStore.fromJson(Map<String, dynamic> json) {
    var itemList = json['items'] as List? ?? [];
    List<GroceryItem> items = itemList.map((i) => GroceryItem.fromJson(i)).toList();
    
    return GroceryStore(
      id: json['id'],
      name: json['name'],
      items: items,
    );
  }
}