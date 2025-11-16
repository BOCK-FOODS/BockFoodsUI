import 'package:flutter/material.dart';

class DeliveryPartnersScreen extends StatefulWidget {
  const DeliveryPartnersScreen({Key? key}) : super(key: key);

  @override
  State<DeliveryPartnersScreen> createState() => _DeliveryPartnersScreenState();
}

class _DeliveryPartnersScreenState extends State<DeliveryPartnersScreen> {
  late List<Map<String, dynamic>> _partners;

  @override
  void initState() {
    super.initState();
    _partners = List.generate(12, (i) => {
      'id': '#D${100 + i}',
      'name': 'Driver ${i + 1}',
      'phone': '+91 ${9800000000 + i}',
      'vehicle': i % 2 == 0 ? 'Bike' : 'Car',
      'status': i % 3 == 0 ? 'Active' : 'Offline',
    });
  }

  void _showAddEditDialog({int? index}) {
    final isEditing = index != null;
    final partner = isEditing ? _partners[index] : null;
    
    final nameController = TextEditingController(text: partner?['name'] ?? '');
    final phoneController = TextEditingController(text: partner?['phone'] ?? '');
    String? selectedVehicle = partner?['vehicle'] ?? 'Bike';
    String? selectedStatus = partner?['status'] ?? 'Active';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Delivery Partner' : 'Add Delivery Partner'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Driver Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedVehicle,
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Bike', child: Text('Bike')),
                    DropdownMenuItem(value: 'Car', child: Text('Car')),
                    DropdownMenuItem(value: 'Van', child: Text('Van')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      selectedVehicle = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Active', child: Text('Active')),
                    DropdownMenuItem(value: 'Offline', child: Text('Offline')),
                    DropdownMenuItem(value: 'On Leave', child: Text('On Leave')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      selectedStatus = value;
                    });
                  },
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
                    phoneController.text.isEmpty ||
                    selectedVehicle == null ||
                    selectedStatus == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                if (isEditing) {
                  _partners[index] = {
                    'id': _partners[index]['id'],
                    'name': nameController.text,
                    'phone': phoneController.text,
                    'vehicle': selectedVehicle,
                    'status': selectedStatus,
                  };
                } else {
                  final newPartner = {
                    'id': '#D${100 + _partners.length}',
                    'name': nameController.text,
                    'phone': phoneController.text,
                    'vehicle': selectedVehicle,
                    'status': selectedStatus,
                  };
                  _partners.add(newPartner);
                }

                setState(() {});
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEditing
                          ? 'Delivery partner updated successfully'
                          : 'Delivery partner added successfully',
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

  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Delivery Partner'),
        content: Text(
            'Are you sure you want to delete "${_partners[index]['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _partners.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Delivery partner deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
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
              const Text(
                'Delivery Partners',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddEditDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add Partner'),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Phone')),
                  DataColumn(label: Text('Vehicle')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: List.generate(_partners.length, (i) {
                  final p = _partners[i];
                  return DataRow(cells: [
                    DataCell(Text(p['id'] as String)),
                    DataCell(Text(p['name'] as String)),
                    DataCell(Text(p['phone'] as String)),
                    DataCell(Text(p['vehicle'] as String)),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: p['status'] == 'Active'
                              ? Colors.green
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          p['status'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showAddEditDialog(index: i),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _showDeleteConfirmation(i),
                          ),
                        ],
                      ),
                    ),
                  ]);
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}