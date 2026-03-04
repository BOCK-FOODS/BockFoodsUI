// lib/services/api_service.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/restaurant.dart';
import '../providers/food_cart_provider.dart';
import '../providers/instamart_cart_provider.dart';
import '../models/grocery_store.dart';
import '../models/grocery_item.dart';
import '../models/grocery_category.dart'; // <-- Add this import


class ApiService {
  static const String _baseUrl = 'http://13.203.97.247:3000/api';

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt_token');
  }

  Future<void> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    if (response.statusCode != 201) {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to register');
    }
  }

  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      await _saveToken(jsonDecode(response.body)['token']);
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Failed to login');
    }
  }

Future<List<Restaurant>> getRestaurants() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/restaurants'));
      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Restaurant.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load restaurants: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Restaurant> getRestaurantDetails(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/restaurants/$id'));
    if (response.statusCode == 200) {
      return Restaurant.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load restaurant details');
    }
  }

  // --- INSTAMART (GROCERY) ---

  Future<List<GroceryCategory>> getGroceryCategories() async {
    final response = await http.get(Uri.parse('$_baseUrl/grocerystores/categories'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => GroceryCategory.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<List<GroceryItem>> getFeaturedGroceries() async {
    final response = await http.get(Uri.parse('$_baseUrl/grocerystores/featured'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => GroceryItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load featured items');
    }
  }
  
  Future<bool> placeOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/orders'), // Ensure you have this route in backend
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        print("Order Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Network Error: $e");
      return false;
    }
  }
  
  }