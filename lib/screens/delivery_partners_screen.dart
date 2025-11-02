import 'package:flutter/material.dart';

class DeliveryPartnersScreen extends StatelessWidget {
  const DeliveryPartnersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final partners = List.generate(12, (i) => {
      'id': '#D${100 + i}',
      'name': 'Driver ${i + 1}',
      'vehicle': i % 2 == 0 ? 'Bike' : 'Car',
      'status': i % 3 == 0 ? 'Active' : 'Offline',
    });

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          color: Colors.white,
          child: const Text(
            'Delivery Partners',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                  DataColumn(label: Text('Vehicle')),
                  DataColumn(label: Text('Status')),
                ],
                rows: partners.map((p) => DataRow(cells: [
                  DataCell(Text(p['id'] as String)),
                  DataCell(Text(p['name'] as String)),
                  DataCell(Text(p['vehicle'] as String)),
                  DataCell(Text(p['status'] as String)),
                ])).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}