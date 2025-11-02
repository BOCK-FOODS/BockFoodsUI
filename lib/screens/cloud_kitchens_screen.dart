import 'package:flutter/material.dart';
import '../models/cloud_kitchen.dart';
import '../models/city.dart';
import '../services/data_service.dart';

class CloudKitchensScreen extends StatefulWidget {
  const CloudKitchensScreen({Key? key}) : super(key: key);

  @override
  State<CloudKitchensScreen> createState() => _CloudKitchensScreenState();
}

class _CloudKitchensScreenState extends State<CloudKitchensScreen> {
  final DataService _dataService = DataService();
  List<CloudKitchen> _cloudKitchens = [];
  List<City> _cities = [];
  String? _selectedCityFilter;

  @override
  void initState() {
    super.initState();
    _dataService.initializeMockData();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _cities = _dataService.getAllCities();
      _cloudKitchens = _selectedCityFilter == null
          ? _dataService.getAllCloudKitchens()
          : _dataService.getCloudKitchensByCity(_selectedCityFilter!);
    });
  }

  void _showAddEditDialog({CloudKitchen? kitchen}) {
    final isEditing = kitchen != null;
    final nameController = TextEditingController(text: kitchen?.name ?? '');
    final areaController = TextEditingController(text: kitchen?.area ?? '');
    final addressController = TextEditingController(text: kitchen?.address ?? '');
    final contactController = TextEditingController(text: kitchen?.contact ?? '');
    String? selectedCityId = kitchen?.cityId ?? (_cities.isNotEmpty ? _cities[0].id : null);

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Cloud Kitchen' : 'Add Cloud Kitchen'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedCityId,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                  ),
                  items: _cities.map((city) {
                    return DropdownMenuItem(
                      value: city.id,
                      child: Text(city.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedCityId = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Kitchen Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: areaController,
                  decoration: const InputDecoration(
                    labelText: 'Area',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Number',
                    border: OutlineInputBorder(),
                  ),
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
                    areaController.text.isEmpty ||
                    addressController.text.isEmpty ||
                    contactController.text.isEmpty ||
                    selectedCityId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                final selectedCity = _cities.firstWhere((c) => c.id == selectedCityId);
                final newKitchen = CloudKitchen(
                  id: isEditing ? kitchen.id : _dataService.generateCloudKitchenId(),
                  name: nameController.text,
                  cityId: selectedCityId!,
                  cityName: selectedCity.name,
                  area: areaController.text,
                  address: addressController.text,
                  contact: contactController.text,
                  isActive: kitchen?.isActive ?? true,
                  totalMenuItems: kitchen?.totalMenuItems ?? 0,
                );

                if (isEditing) {
                  _dataService.updateCloudKitchen(kitchen.id, newKitchen);
                } else {
                  _dataService.addCloudKitchen(newKitchen);
                }

                _loadData();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEditing
                          ? 'Cloud kitchen updated successfully'
                          : 'Cloud kitchen added successfully',
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

  void _deleteCloudKitchen(CloudKitchen kitchen) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Cloud Kitchen'),
        content: Text(
          'Are you sure you want to delete ${kitchen.name}? This will also delete all menu items.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _dataService.deleteCloudKitchen(kitchen.id);
              _loadData();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cloud kitchen deleted successfully')),
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
                    'Cloud Kitchens',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text('${_cloudKitchens.length} kitchens across ${_cities.length} cities'),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 16),
                    child: DropdownButtonFormField<String>(
                      value: _selectedCityFilter,
                      decoration: const InputDecoration(
                        labelText: 'Filter by City',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All Cities')),
                        ..._cities.map((city) {
                          return DropdownMenuItem(
                            value: city.id,
                            child: Text(city.name),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCityFilter = value;
                          _loadData();
                        });
                      },
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddEditDialog(),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Cloud Kitchen'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[700],
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: _cloudKitchens.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.store, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No cloud kitchens added yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(24),
                  itemCount: _cloudKitchens.length,
                  itemBuilder: (context, index) {
                    final kitchen = _cloudKitchens[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.store, color: Colors.orange[700], size: 30),
                        ),
                        title: Text(
                          kitchen.name,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('📍 ${kitchen.area}, ${kitchen.cityName}'),
                            Text('📞 ${kitchen.contact}'),
                            Text('🍽️ ${kitchen.totalMenuItems} Menu Items'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: kitchen.isActive,
                              onChanged: (value) {
                                final updated = CloudKitchen(
                                  id: kitchen.id,
                                  name: kitchen.name,
                                  cityId: kitchen.cityId,
                                  cityName: kitchen.cityName,
                                  area: kitchen.area,
                                  address: kitchen.address,
                                  contact: kitchen.contact,
                                  isActive: value,
                                  totalMenuItems: kitchen.totalMenuItems,
                                );
                                _dataService.updateCloudKitchen(kitchen.id, updated);
                                _loadData();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showAddEditDialog(kitchen: kitchen),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteCloudKitchen(kitchen),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}