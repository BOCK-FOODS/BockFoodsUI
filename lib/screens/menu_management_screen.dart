import 'package:flutter/material.dart';
import '../models/menu_item.dart';
import '../models/cloud_kitchen.dart';
import '../services/data_service.dart';

class MenuManagementScreen extends StatefulWidget {
  const MenuManagementScreen({Key? key}) : super(key: key);

  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  final DataService _dataService = DataService();
  List<MenuItem> _menuItems = [];
  List<CloudKitchen> _cloudKitchens = [];
  String? _selectedKitchenFilter;
  String _selectedTypeFilter = 'all';

  @override
  void initState() {
    super.initState();
    _dataService.initializeMockData();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _cloudKitchens = _dataService.getAllCloudKitchens();
      _menuItems = _selectedKitchenFilter == null
          ? _dataService.getAllMenuItems()
          : _dataService.getMenuItemsByCloudKitchen(_selectedKitchenFilter!);
      
      if (_selectedTypeFilter != 'all') {
        _menuItems = _menuItems.where((item) => item.type == _selectedTypeFilter).toList();
      }
    });
  }

  void _showAddEditDialog({MenuItem? item}) {
    final isEditing = item != null;
    final nameController = TextEditingController(text: item?.name ?? '');
    final descController = TextEditingController(text: item?.description ?? '');
    final priceController = TextEditingController(text: item?.price.toString() ?? '');
    final categoryController = TextEditingController(text: item?.category ?? '');
    final imageController = TextEditingController(text: item?.imageUrl ?? '');
    
    String? selectedKitchenId = item?.cloudKitchenId ?? 
        (_cloudKitchens.isNotEmpty ? _cloudKitchens[0].id : null);
    String selectedType = item?.type ?? 'food';
    bool isVeg = item?.isVeg ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Menu Item' : 'Add Menu Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedKitchenId,
                  decoration: const InputDecoration(
                    labelText: 'Cloud Kitchen',
                    border: OutlineInputBorder(),
                  ),
                  items: _cloudKitchens.map((kitchen) {
                    return DropdownMenuItem(
                      value: kitchen.id,
                      child: Text('${kitchen.name} (${kitchen.area})'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedKitchenId = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: priceController,
                        decoration: const InputDecoration(
                          labelText: 'Price (₹)',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: selectedType,
                        decoration: const InputDecoration(
                          labelText: 'Type',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'food', child: Text('Food')),
                          DropdownMenuItem(value: 'grocery', child: Text('Grocery')),
                        ],
                        onChanged: (value) {
                          setDialogState(() {
                            selectedType = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., North Indian, Vegetables',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: isVeg,
                      onChanged: (value) {
                        setDialogState(() {
                          isVeg = value ?? true;
                        });
                      },
                    ),
                    const Text('Vegetarian'),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isEmpty ||
                    priceController.text.isEmpty ||
                    categoryController.text.isEmpty ||
                    selectedKitchenId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill required fields')),
                  );
                  return;
                }

                final selectedKitchen =
                    _cloudKitchens.firstWhere((k) => k.id == selectedKitchenId);
                
                final newItem = MenuItem(
                  id: isEditing ? item.id : _dataService.generateMenuItemId(),
                  name: nameController.text,
                  description: descController.text,
                  price: double.tryParse(priceController.text) ?? 0,
                  category: categoryController.text,
                  cloudKitchenId: selectedKitchenId!,
                  cloudKitchenName: selectedKitchen.name,
                  imageUrl: imageController.text,
                  isAvailable: item?.isAvailable ?? true,
                  isVeg: isVeg,
                  type: selectedType,
                );

                if (isEditing) {
                  _dataService.updateMenuItem(item.id, newItem);
                } else {
                  _dataService.addMenuItem(newItem);
                }

                _loadData();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEditing
                          ? 'Menu item updated successfully'
                          : 'Menu item added successfully',
                    ),
                  ),
                );
              },
              child: Text(isEditing ? 'Update' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteMenuItem(MenuItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Menu Item'),
        content: Text('Are you sure you want to delete ${item.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _dataService.deleteMenuItem(item.id);
              _loadData();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menu item deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Menu Management',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('${_menuItems.length} items available'),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 12),
                    child: DropdownButtonFormField<String>(
                      value: _selectedTypeFilter,
                      decoration: const InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('All')),
                        DropdownMenuItem(value: 'food', child: Text('Food')),
                        DropdownMenuItem(value: 'grocery', child: Text('Grocery')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedTypeFilter = value!;
                          _loadData();
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 220,
                    margin: const EdgeInsets.only(right: 16),
                    child: DropdownButtonFormField<String>(
                      value: _selectedKitchenFilter,
                      decoration: const InputDecoration(
                        labelText: 'Filter by Kitchen',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All Kitchens')),
                        ..._cloudKitchens.map((kitchen) {
                          return DropdownMenuItem(
                            value: kitchen.id,
                            child: Text('${kitchen.name}'),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedKitchenFilter = value;
                          _loadData();
                        });
                      },
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddEditDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Menu Item'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: _menuItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No menu items added yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: _menuItems.length,
                  itemBuilder: (context, index) {
                    final item = _menuItems[index];
                    return Card(
                      elevation: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.green[50],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4),
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                item.type == 'food'
                                    ? Icons.fastfood
                                    : Icons.shopping_basket,
                                size: 60,
                                color: Colors.green[700],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: item.isVeg ? Colors.green : Colors.red,
                                            width: 2,
                                          ),
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 6,
                                            height: 6,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: item.isVeg ? Colors.green : Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.category,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.cloudKitchenName,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey[500],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '₹${item.price.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.green[700],
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit, size: 16),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            onPressed: () => _showAddEditDialog(item: item),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(),
                                            onPressed: () => _deleteMenuItem(item),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}