import 'package:flutter/material.dart';
import '../models/drone.dart';
import '../models/cloud_kitchen.dart';
import '../services/data_service.dart';

class DronesScreen extends StatefulWidget {
  const DronesScreen({Key? key}) : super(key: key);

  @override
  State<DronesScreen> createState() => _DronesScreenState();
}

class _DronesScreenState extends State<DronesScreen> {
  final DataService _dataService = DataService();
  List<Drone> _drones = [];
  List<CloudKitchen> _cloudKitchens = [];
  String? _selectedKitchenFilter;

  @override
  void initState() {
    super.initState();
    _dataService.initializeMockData();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _cloudKitchens = _dataService.getAllCloudKitchens();
      _drones = _selectedKitchenFilter == null
          ? _dataService.getAllDrones()
          : _dataService.getDronesByCloudKitchen(_selectedKitchenFilter!);
    });
  }

  void _showAddEditDialog({Drone? drone}) {
    final isEditing = drone != null;
    final nameController = TextEditingController(text: drone?.name ?? '');
    final capacityController = TextEditingController(
        text: drone?.maxCarryCapacity.toString() ?? '2.5');
    final rangeController = TextEditingController(
        text: drone?.flightRange.toString() ?? '5.0');
    
    String? selectedKitchenId = drone?.cloudKitchenId ?? 
        (_cloudKitchens.isNotEmpty ? _cloudKitchens[0].id : null);
    String? selectedDroneType = drone?.droneType ?? 'Quadcopter';
    String? selectedStatus = drone?.status ?? 'Active';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Drone' : 'Add Drone'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Drone Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedKitchenId,
                  decoration: const InputDecoration(
                    labelText: 'Cloud Kitchen',
                    border: OutlineInputBorder(),
                  ),
                  items: _cloudKitchens.map((kitchen) {
                    return DropdownMenuItem(
                      value: kitchen.id,
                      child: Text(kitchen.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedKitchenId = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedDroneType,
                  decoration: const InputDecoration(
                    labelText: 'Drone Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Quadcopter', child: Text('Quadcopter')),
                    DropdownMenuItem(value: 'Hexacopter', child: Text('Hexacopter')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      selectedDroneType = value;
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
                    DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
                    DropdownMenuItem(value: 'In Maintenance', child: Text('In Maintenance')),
                  ],
                  onChanged: (value) {
                    setDialogState(() {
                      selectedStatus = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: capacityController,
                  decoration: const InputDecoration(
                    labelText: 'Max Carry Capacity (kg)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: rangeController,
                  decoration: const InputDecoration(
                    labelText: 'Flight Range (km)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
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
                    selectedKitchenId == null ||
                    selectedDroneType == null ||
                    selectedStatus == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all required fields')),
                  );
                  return;
                }

                final selectedKitchen = _cloudKitchens
                    .firstWhere((k) => k.id == selectedKitchenId);
                final capacity = double.tryParse(capacityController.text) ?? 2.5;
                final range = double.tryParse(rangeController.text) ?? 5.0;

                final newDrone = Drone(
                  id: isEditing ? drone.id : _dataService.generateDroneId(),
                  name: nameController.text,
                  droneType: selectedDroneType!,
                  cloudKitchenId: selectedKitchenId!,
                  cloudKitchenName: selectedKitchen.name,
                  status: selectedStatus!,
                  maxCarryCapacity: capacity,
                  flightRange: range,
                  totalDeliveries: drone?.totalDeliveries ?? 0,
                  isActive: drone?.isActive ?? true,
                );

                if (isEditing) {
                  _dataService.updateDrone(drone.id, newDrone);
                } else {
                  _dataService.addDrone(newDrone);
                }

                _loadData();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isEditing
                          ? 'Drone updated successfully'
                          : 'Drone added successfully',
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

  void _showDeleteConfirmation(Drone drone) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Drone'),
        content: Text('Are you sure you want to delete "${drone.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _dataService.deleteDrone(drone.id);
              _loadData();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Drone deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Active':
        return Colors.green;
      case 'Inactive':
        return Colors.grey;
      case 'In Maintenance':
        return Colors.orange;
      default:
        return Colors.grey;
    }
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
                'Drones Management',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddEditDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add Drone'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              const Text('Filter by Cloud Kitchen:'),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButton<String?>(
                  value: _selectedKitchenFilter,
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All Kitchens'),
                    ),
                    ..._cloudKitchens.map((kitchen) {
                      return DropdownMenuItem(
                        value: kitchen.id,
                        child: Text(kitchen.name),
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
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: _drones.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Center(
                        child: Text('No drones available'),
                      ),
                    )
                  : DataTable(
                      columns: const [
                        DataColumn(label: Text('ID')),
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Type')),
                        DataColumn(label: Text('Kitchen')),
                        DataColumn(label: Text('Capacity (kg)')),
                        DataColumn(label: Text('Range (km)')),
                        DataColumn(label: Text('Status')),
                        DataColumn(label: Text('Deliveries')),
                        DataColumn(label: Text('Actions')),
                      ],
                      rows: _drones.map((drone) => DataRow(
                        cells: [
                          DataCell(Text(drone.id)),
                          DataCell(Text(drone.name)),
                          DataCell(Text(drone.droneType)),
                          DataCell(Text(drone.cloudKitchenName)),
                          DataCell(Text(drone.maxCarryCapacity.toString())),
                          DataCell(Text(drone.flightRange.toString())),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _getStatusColor(drone.status),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                drone.status,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          DataCell(Text(drone.totalDeliveries.toString())),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _showAddEditDialog(drone: drone),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _showDeleteConfirmation(drone),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )).toList(),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
