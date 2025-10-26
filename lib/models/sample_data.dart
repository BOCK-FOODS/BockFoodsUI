import '../models/food_item.dart';

final List<FoodItem> sampleFoods = [
  FoodItem(
    id: 'f1',
    name: 'Idly (2Pcs)',
    description: 'Steamed rice cakes - South Indian breakfast.',
    price: 48,
    category: 'Breakfast',
    imageUrl: '',
    isVeg: true,
  ),
  FoodItem(
    id: 'f2',
    name: 'Sambar Idly (2Pcs)',
    description: 'Idly with sambar.',
    price: 70,
    category: 'Breakfast',
    imageUrl: '',
    isVeg: true,
  ),
  FoodItem(
    id: 'f3',
    name: 'Ghee Pongal',
    description: 'Soft pongal with ghee.',
    price: 85,
    category: 'Breakfast',
    imageUrl: '',
    isVeg: true,
  ),
  FoodItem(
    id: 'f4',
    name: 'Veg Biryani',
    description: 'Aromatic veg biryani.',
    price: 150,
    category: 'Main',
    imageUrl: '',
    isVeg: true,
  ),
  FoodItem(
    id: 'f5',
    name: 'Chicken Curry',
    description: 'Spicy chicken curry.',
    price: 220,
    category: 'Main',
    imageUrl: '',
    isVeg: false,
  ),
];
