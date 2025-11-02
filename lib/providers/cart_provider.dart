import 'package:flutter/material.dart';
import '../models/food_item.dart';

// Provider for restaurant/food cart
class FoodCartItem {
  final FoodItem item;
  int qty;
  FoodCartItem({required this.item, this.qty = 1});
}

class FoodCartProvider extends ChangeNotifier {
  final Map<String, FoodCartItem> _items = {};

  Map<String, FoodCartItem> get items => {..._items};

  int get totalItems => _items.values.fold(0, (t, e) => t + e.qty);

  double get subtotal => _items.values.fold(0.0, (t, e) => t + e.item.price * e.qty);

  void addItem(FoodItem item) {
    if (_items.containsKey(item.id)) {
      _items[item.id]!.qty += 1;
    } else {
      _items[item.id] = FoodCartItem(item: item, qty: 1);
    }
    notifyListeners();
  }

  void removeSingle(String id) {
    if (!_items.containsKey(id)) return;
    if (_items[id]!.qty > 1) {
      _items[id]!.qty -= 1;
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}