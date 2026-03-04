// lib/models/restaurant.dart
import 'food_item.dart';

class Restaurant {
  final String id;
  final String name;
  final String address;
  final String cuisine;
  final String? imageUrl;
  final double rating;
  final List<FoodItem> menuItems; // Renamed from MenuItem to FoodItem to match existing code

  Restaurant({
    required this.id,
    required this.name,
    required this.address,
    required this.cuisine,
    this.imageUrl,
    required this.rating,
    required this.menuItems,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    // The menuItems might not be present when fetching all restaurants
    var menuList = json['menuItems'] as List<dynamic>? ?? [];
    List<FoodItem> items = menuList.map((i) => FoodItem.fromJson(i)).toList();

    return Restaurant(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      cuisine: json['cuisine'],
      imageUrl: json['imageUrl'],
      rating: (json['rating'] as num).toDouble(),
      menuItems: items,
    );
  }
}