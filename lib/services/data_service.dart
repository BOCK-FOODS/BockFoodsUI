import 'dart:math';
import '../models/city.dart';
import '../models/cloud_kitchen.dart';
import '../models/menu_item.dart';
import '../models/order.dart';

class DataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  final List<City> _cities = [];
  final List<CloudKitchen> _cloudKitchens = [];
  final List<MenuItem> _menuItems = [];

  void initializeMockData() {
    if (_cities.isEmpty) {
      _initializeCities();
      _initializeCloudKitchens();
      _initializeMenuItems();
    }
  }

  void _initializeCities() {
    _cities.add(City(
      id: 'CITY001',
      name: 'Bangalore',
      state: 'Karnataka',
      isActive: true,
      totalCloudKitchens: 5,
    ));
  }

  void _initializeCloudKitchens() {
    final bangaloreAreas = ['Koramangala', 'Indiranagar', 'Whitefield', 'HSR Layout', 'Jayanagar'];
    
    for (int i = 0; i < 5; i++) {
      _cloudKitchens.add(CloudKitchen(
        id: 'CK${(i + 1).toString().padLeft(3, '0')}',
        name: 'Bock Foods ${bangaloreAreas[i]}',
        cityId: 'CITY001',
        cityName: 'Bangalore',
        area: bangaloreAreas[i],
        address: '${i + 1}23, ${bangaloreAreas[i]} Main Road, Bangalore',
        contact: '+91 ${9800000000 + i}',
        isActive: true,
        totalMenuItems: 0,
      ));
    }
  }

  void _initializeMenuItems() {
    final foodCategories = ['North Indian', 'South Indian', 'Chinese', 'Continental', 'Beverages'];
    final groceryCategories = ['Vegetables', 'Fruits', 'Dairy', 'Snacks', 'Beverages'];
    
    for (var kitchen in _cloudKitchens) {
      // Add food items
      for (int i = 0; i < 10; i++) {
        _menuItems.add(MenuItem(
          id: 'MENU${_menuItems.length + 1}',
          name: 'Food Item ${i + 1}',
          description: 'Delicious ${foodCategories[i % 5]} dish',
          price: (100 + Random().nextDouble() * 400),
          category: foodCategories[i % 5],
          cloudKitchenId: kitchen.id,
          cloudKitchenName: kitchen.name,
          imageUrl: 'https://via.placeholder.com/150',
          isAvailable: true,
          isVeg: Random().nextBool(),
          type: 'food',
        ));
      }
      
      // Add grocery items
      for (int i = 0; i < 5; i++) {
        _menuItems.add(MenuItem(
          id: 'MENU${_menuItems.length + 1}',
          name: 'Grocery Item ${i + 1}',
          description: 'Fresh ${groceryCategories[i % 5]}',
          price: (20 + Random().nextDouble() * 200),
          category: groceryCategories[i % 5],
          cloudKitchenId: kitchen.id,
          cloudKitchenName: kitchen.name,
          imageUrl: 'https://via.placeholder.com/150',
          isAvailable: true,
          isVeg: true,
          type: 'grocery',
        ));
      }
      
      kitchen.totalMenuItems = 15;
    }
  }

  // City CRUD
  List<City> getAllCities() => List.unmodifiable(_cities);
  
  void addCity(City city) {
    _cities.add(city);
  }

  void updateCity(String id, City updatedCity) {
    final index = _cities.indexWhere((c) => c.id == id);
    if (index != -1) {
      _cities[index] = updatedCity;
    }
  }

  void deleteCity(String id) {
    _cities.removeWhere((c) => c.id == id);
    _cloudKitchens.removeWhere((ck) => ck.cityId == id);
  }

  // CloudKitchen CRUD
  List<CloudKitchen> getAllCloudKitchens() => List.unmodifiable(_cloudKitchens);
  
  List<CloudKitchen> getCloudKitchensByCity(String cityId) {
    return _cloudKitchens.where((ck) => ck.cityId == cityId).toList();
  }

  void addCloudKitchen(CloudKitchen cloudKitchen) {
    _cloudKitchens.add(cloudKitchen);
    final city = _cities.firstWhere((c) => c.id == cloudKitchen.cityId);
    city.totalCloudKitchens++;
  }

  void updateCloudKitchen(String id, CloudKitchen updated) {
    final index = _cloudKitchens.indexWhere((ck) => ck.id == id);
    if (index != -1) {
      _cloudKitchens[index] = updated;
    }
  }

  void deleteCloudKitchen(String id) {
    final ck = _cloudKitchens.firstWhere((kitchen) => kitchen.id == id);
    _cloudKitchens.removeWhere((kitchen) => kitchen.id == id);
    _menuItems.removeWhere((item) => item.cloudKitchenId == id);
    final city = _cities.firstWhere((c) => c.id == ck.cityId);
    city.totalCloudKitchens--;
  }

  // MenuItem CRUD
  List<MenuItem> getAllMenuItems() => List.unmodifiable(_menuItems);
  
  List<MenuItem> getMenuItemsByCloudKitchen(String cloudKitchenId) {
    return _menuItems.where((item) => item.cloudKitchenId == cloudKitchenId).toList();
  }

  void addMenuItem(MenuItem menuItem) {
    _menuItems.add(menuItem);
    final kitchen = _cloudKitchens.firstWhere((ck) => ck.id == menuItem.cloudKitchenId);
    kitchen.totalMenuItems++;
  }

  void updateMenuItem(String id, MenuItem updated) {
    final index = _menuItems.indexWhere((item) => item.id == id);
    if (index != -1) {
      _menuItems[index] = updated;
    }
  }

  void deleteMenuItem(String id) {
    final item = _menuItems.firstWhere((m) => m.id == id);
    _menuItems.removeWhere((m) => m.id == id);
    final kitchen = _cloudKitchens.firstWhere((ck) => ck.id == item.cloudKitchenId);
    kitchen.totalMenuItems--;
  }

  // ID Generators
  String generateCityId() => 'CITY${(_cities.length + 1).toString().padLeft(3, '0')}';
  String generateCloudKitchenId() => 'CK${(_cloudKitchens.length + 1).toString().padLeft(3, '0')}';
  String generateMenuItemId() => 'MENU${_menuItems.length + 1}';
}